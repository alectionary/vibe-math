/* la_gen.c - exact frame search with general items (each item = 1..8 pool pairs).
 *
 * Same method as la_dfs.c (residual R = I - sum of chosen outer products; branch on an entry
 * R[c][k] = 1 with fewest live items; rank pruning), but items are arbitrary sets of pairs and
 * availability is tracked per pool vector, so a frame invariant under any involution of the
 * symmetry group can be searched (items = orbits of pairs). See gen_items.py.
 *
 * Instance format (text):
 *   NX NZ NI DIM
 *   dmask_lo dmask_hi                (hex, the coordinates of the space)
 *   NX lines: lo hi (hex)            X vectors
 *   NZ lines: lo hi (hex)            Z vectors
 *   NI lines: k x1 z1 ... xk zk      items (vector indices)
 *
 *   la_gen [-l] [-f] [-1] [-t SEC] [-k PROBES] [-r SEED] [-s i -S n [-D depth]] [-o FRAMES] INSTANCE
 *   shards split the children at the given depth (default 0) round-robin in visiting order
 *   -l  restrict X'/Z' to vectors of live items
 *   -f  per-vector look-ahead filter (cached)     -F  -f plus the exact per-item test
 */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

typedef struct { uint64_t w[2]; } v128;
static inline int bit(v128 v, int c) { return (v.w[c >> 6] >> (c & 63)) & 1; }
static inline int dot(v128 a, v128 b) { return (__builtin_popcountll(a.w[0] & b.w[0]) + __builtin_popcountll(a.w[1] & b.w[1])) & 1; }
static inline v128 vxor(v128 a, v128 b) { v128 r = {{a.w[0] ^ b.w[0], a.w[1] ^ b.w[1]}}; return r; }
static inline int vzero(v128 a) { return !(a.w[0] | a.w[1]); }

#define MAXK 8
static int NX, NZ, NI, DIM;
static v128 *XV, *ZV, Dmask;
static int *ik, (*ix)[MAXK], (*iz)[MAXK];
static uint8_t *orthxz;   /* orthxz[i*NZ+j] = <x_i,z_j> == 0 */
static long long shard_ctr = 0; static int shard_depth = 0;
static int live_sides = 0, filter_items = 0, full_filter = 0, only_first = 0, shard = 0, nshard = 1, knuth = 0;
static double kprod, kest; static unsigned long long rng = 88172645463325252ULL;
static unsigned long long xr(void) { rng ^= rng << 13; rng ^= rng >> 7; rng ^= rng << 17; return rng; }
static long long nodes[300], prunes_rank[300], prunes_empty[300], nsol = 0;
static FILE *solf; static int chosen[300];
static time_t t0; static long long time_limit = 0; static int timed_out = 0;

static int ins(v128 *piv, uint8_t *has, v128 v) {
    for (;;) {
        if (vzero(v)) return 0;
        int h = v.w[1] ? 64 + 63 - __builtin_clzll(v.w[1]) : 63 - __builtin_clzll(v.w[0]);
        if (!has[h]) { piv[h] = v; has[h] = 1; return 1; }
        v = vxor(v, piv[h]);
    }
}
static int span_rank(const uint8_t *ok, int n, const v128 *V, int need, v128 *basis) {
    v128 p[128]; uint8_t h[128] = {0}; int r = 0;
    for (int a = 0; a < n && r < need; a++) if (ok[a] && ins(p, h, V[a])) { if (basis) basis[r] = V[a]; r++; }
    return r;
}
static int pair_rank(const uint8_t *okx, const uint8_t *okz, int need) {
    v128 bx[128], bz[128];
    int rx = span_rank(okx, NX, XV, DIM, bx); if (rx < need) return rx;
    int rz = span_rank(okz, NZ, ZV, DIM, bz); if (rz < need) return rz;
    v128 pr[128]; uint8_t hr[128] = {0}; int r = 0;
    for (int i = 0; i < rx; i++) {
        v128 row = {{0, 0}};
        for (int j = 0; j < rz; j++) if (dot(bx[i], bz[j])) row.w[j >> 6] |= 1ULL << (j & 63);
        r += ins(pr, hr, row);
    }
    return r;
}
/* availability after choosing item q */
static void child_ok(int q, const uint8_t *okx, const uint8_t *okz, uint8_t *okx2, uint8_t *okz2) {
    for (int i = 0; i < NX; i++) { int o = okx[i]; for (int s = 0; s < ik[q] && o; s++) o = orthxz[i * NZ + iz[q][s]]; okx2[i] = o; }
    for (int j = 0; j < NZ; j++) { int o = okz[j]; for (int s = 0; s < ik[q] && o; s++) o = orthxz[ix[q][s] * NZ + j]; okz2[j] = o; }
    for (int s = 0; s < ik[q]; s++) { okx2[ix[q][s]] = 0; okz2[iz[q][s]] = 0; }
}
static int item_live(int q, const uint8_t *okx, const uint8_t *okz) {
    for (int s = 0; s < ik[q]; s++) if (!okx[ix[q][s]] || !okz[iz[q][s]]) return 0;
    return 1;
}

static void search(v128 *R, uint8_t *okx, uint8_t *okz, int *live, int nlive, int depth, int need) {
    nodes[depth]++;
    if (time_limit && (nodes[depth] & 255) == 0 && time(NULL) - t0 > time_limit) timed_out = 1;
    if (timed_out) return;
    if (need == 0) {
        nsol++; fprintf(solf, "FRAME");
        for (int d = 0; d < depth; d++) for (int s = 0; s < ik[chosen[d]]; s++) fprintf(solf, " %d %d", ix[chosen[d]][s], iz[chosen[d]][s]);
        fprintf(solf, "\n"); fflush(solf); return;
    }
    uint8_t *okxL = malloc(NX), *okzL = malloc(NZ); int *own = NULL;
    #define LEAVE do { free(okxL); free(okzL); free(own); return; } while (0)
    if (live_sides) {
        memset(okxL, 0, NX); memset(okzL, 0, NZ);
        for (int t = 0; t < nlive; t++) { int q = live[t]; for (int s = 0; s < ik[q]; s++) { okxL[ix[q][s]] = 1; okzL[iz[q][s]] = 1; } }
        okx = okxL; okz = okzL;
    }
    if (pair_rank(okx, okz, need) < need) { prunes_rank[depth]++; LEAVE; }
    if (filter_items) {
        uint8_t *tx = malloc(NX), *tz = malloc(NZ);
        for (int round = 0; round < 8; round++) {
            int nk = 0; int *keep = malloc(sizeof(int) * (nlive + 1));
            /* per-vector test (-f): if z_b is in the frame, the other remaining frame X vectors lie in
             * X' ∩ z_b^⊥ and span C ∩ z_b^⊥ (dim need-1); same for x_a on the Z side. Cached per vector. */
            uint8_t *vx = malloc(NX), *vz = malloc(NZ); memset(vx, 2, NX); memset(vz, 2, NZ);
            for (int t = 0; t < nlive; t++) {
                int q = live[t], k = ik[q], good = need - k >= 0;
                for (int s = 0; s < k && good; s++) {
                    int a = ix[q][s], b = iz[q][s];
                    if (vz[b] == 2) { for (int i = 0; i < NX; i++) tx[i] = okx[i] && orthxz[i * NZ + b];
                                      vz[b] = span_rank(tx, NX, XV, need - 1, NULL) >= need - 1; }
                    if (!vz[b]) { good = 0; break; }
                    if (vx[a] == 2) { for (int j = 0; j < NZ; j++) tz[j] = okz[j] && orthxz[a * NZ + j];
                                      vx[a] = span_rank(tz, NZ, ZV, need - 1, NULL) >= need - 1; }
                    if (!vx[a]) good = 0;
                }
                if (good && full_filter && k > 1) {
                    child_ok(q, okx, okz, tx, tz);
                    good = span_rank(tx, NX, XV, need - k, NULL) >= need - k && span_rank(tz, NZ, ZV, need - k, NULL) >= need - k;
                }
                if (good) keep[nk++] = q;
            }
            free(vx); free(vz);
            int changed = nk < nlive; free(own); own = keep; live = keep; nlive = nk;
            if (!changed || !live_sides) break;
            memset(okxL, 0, NX); memset(okzL, 0, NZ);
            for (int t = 0; t < nlive; t++) { int q = live[t]; for (int s = 0; s < ik[q]; s++) { okxL[ix[q][s]] = 1; okzL[iz[q][s]] = 1; } }
            okx = okxL; okz = okzL;
            if (pair_rank(okx, okz, need) < need) { prunes_rank[depth]++; free(tx); free(tz); LEAVE; }
        }
        free(tx); free(tz);
    }
    /* entry counts: bit (c,k) of item q = XOR over its pairs of x[c] z[k] */
    int (*C)[128] = calloc(128, sizeof *C);
    for (int t = 0; t < nlive; t++) {
        int q = live[t]; v128 rows[128]; uint8_t touched[128] = {0}; int tl[128], nt = 0;
        for (int s = 0; s < ik[q]; s++) {
            v128 x = XV[ix[q][s]], z = ZV[iz[q][s]];
            for (int wx = 0; wx < 2; wx++) for (uint64_t mx = x.w[wx]; mx; mx &= mx - 1) {
                int c = wx * 64 + __builtin_ctzll(mx);
                if (!touched[c]) { touched[c] = 1; rows[c] = z; tl[nt++] = c; } else rows[c] = vxor(rows[c], z);
            }
        }
        for (int u = 0; u < nt; u++) { int c = tl[u]; v128 z = rows[c];
            for (int wz = 0; wz < 2; wz++) for (uint64_t mz = z.w[wz]; mz; mz &= mz - 1) C[c][wz * 64 + __builtin_ctzll(mz)]++; }
    }
    int bc = -1, bk = -1, best = 1 << 30;
    for (int c = 0; c < 128; c++) for (int w = 0; w < 2; w++) for (uint64_t m = R[c].w[w]; m; m &= m - 1) {
        int k = w * 64 + __builtin_ctzll(m);
        if (C[c][k] < best) { best = C[c][k]; bc = c; bk = k; }
    }
    free(C);
    if (best == 0 || bc < 0) { prunes_empty[depth]++; LEAVE; }
    int *ch = malloc(sizeof(int) * (best + 1)), nch = 0;
    for (int t = 0; t < nlive; t++) {
        int q = live[t], b = 0;
        for (int s = 0; s < ik[q]; s++) b ^= bit(XV[ix[q][s]], bc) & bit(ZV[iz[q][s]], bk);
        if (b) ch[nch++] = q;
    }
    if (knuth) { kprod *= nch; kest += kprod; ch[0] = ch[xr() % nch]; nch = 1; }
    uint8_t *excl = calloc(NI, 1), *okx2 = malloc(NX), *okz2 = malloc(NZ); int *live2 = malloc(sizeof(int) * (nlive + 1));
    v128 R2[128];
    for (int u = 0; u < nch && !timed_out; u++) {
        int q = ch[u];
        if (!knuth && depth == shard_depth && (shard_ctr++ % nshard) != shard) { excl[q] = 1; continue; }
        if (ik[q] > need) { excl[q] = 1; continue; }
        memcpy(R2, R, sizeof R2);
        for (int s = 0; s < ik[q]; s++) { v128 x = XV[ix[q][s]], z = ZV[iz[q][s]]; for (int c = 0; c < 128; c++) if (bit(x, c)) R2[c] = vxor(R2[c], z); }
        child_ok(q, okx, okz, okx2, okz2);
        int n2 = 0;
        for (int t = 0; t < nlive; t++) { int r = live[t]; if (!excl[r] && r != q && item_live(r, okx2, okz2)) live2[n2++] = r; }
        chosen[depth] = q;
        search(R2, okx2, okz2, live2, n2, depth + 1, need - ik[q]);
        excl[q] = 1;
        if (only_first && nsol) break;
    }
    free(ch); free(excl); free(okx2); free(okz2); free(live2);
    LEAVE;
}

static v128 rd(FILE *f) { unsigned long long a, b; v128 v = {{0, 0}}; if (fscanf(f, "%llx %llx", &a, &b) == 2) { v.w[0] = a; v.w[1] = b; } return v; }
int main(int argc, char **argv) {
    const char *in = NULL, *out = "/dev/null"; int a;
    for (a = 1; a < argc; a++) {
        if (!strcmp(argv[a], "-l")) live_sides = 1;
        else if (!strcmp(argv[a], "-f")) filter_items = 1;
        else if (!strcmp(argv[a], "-F")) filter_items = full_filter = 1;
        else if (!strcmp(argv[a], "-1")) only_first = 1;
        else if (!strcmp(argv[a], "-t")) time_limit = atoll(argv[++a]);
        else if (!strcmp(argv[a], "-k")) knuth = atoi(argv[++a]);
        else if (!strcmp(argv[a], "-r")) rng ^= strtoull(argv[++a], NULL, 10) * 0x9E3779B97F4A7C15ULL;
        else if (!strcmp(argv[a], "-s")) shard = atoi(argv[++a]);
        else if (!strcmp(argv[a], "-S")) nshard = atoi(argv[++a]);
        else if (!strcmp(argv[a], "-D")) shard_depth = atoi(argv[++a]);
        else if (!strcmp(argv[a], "-o")) out = argv[++a];
        else in = argv[a];
    }
    FILE *f = fopen(in, "r"); if (!f) { perror(in); return 2; }
    if (fscanf(f, "%d %d %d %d", &NX, &NZ, &NI, &DIM) != 4) return 2;
    Dmask = rd(f);
    XV = malloc(sizeof(v128) * NX); ZV = malloc(sizeof(v128) * NZ);
    for (int i = 0; i < NX; i++) XV[i] = rd(f);
    for (int j = 0; j < NZ; j++) ZV[j] = rd(f);
    ik = malloc(sizeof(int) * NI); ix = malloc(sizeof *ix * NI); iz = malloc(sizeof *iz * NI);
    for (int q = 0; q < NI; q++) {
        if (fscanf(f, "%d", &ik[q]) != 1 || ik[q] < 1 || ik[q] > MAXK) return 3;
        for (int s = 0; s < ik[q]; s++) if (fscanf(f, "%d %d", &ix[q][s], &iz[q][s]) != 2) return 3;
    }
    fclose(f);
    orthxz = malloc((size_t)NX * NZ);
    for (int i = 0; i < NX; i++) for (int j = 0; j < NZ; j++) orthxz[i * NZ + j] = !dot(XV[i], ZV[j]);
    /* sanity: each item's pairs must have Gram matrix = identity */
    for (int q = 0; q < NI; q++) for (int s = 0; s < ik[q]; s++) for (int u = 0; u < ik[q]; u++)
        if (dot(XV[ix[q][s]], ZV[iz[q][u]]) != (s == u)) { fprintf(stderr, "item %d not a partial frame\n", q); return 4; }
    solf = fopen(out, "w"); t0 = time(NULL);
    v128 R[128]; for (int c = 0; c < 128; c++) { R[c].w[0] = R[c].w[1] = 0; if (bit(Dmask, c)) R[c].w[c >> 6] = 1ULL << (c & 63); }
    uint8_t *okx = malloc(NX), *okz = malloc(NZ); memset(okx, 1, NX); memset(okz, 1, NZ);
    int *live = malloc(sizeof(int) * NI); for (int q = 0; q < NI; q++) live[q] = q;
    if (knuth) {
        double sum = 0, mx = 0; long long leaf[300] = {0};
        for (int p = 0; p < knuth; p++) {
            kprod = 1; kest = 1; long long before[300]; memcpy(before, nodes, sizeof before);
            search(R, okx, okz, live, NI, 0, DIM);
            int d = 0; for (int i = 0; i < 300; i++) if (nodes[i] > before[i]) d = i;
            leaf[d]++; sum += kest; if (kest > mx) mx = kest;
        }
        printf("{\"knuth_probes\": %d, \"mean_tree\": %.4g, \"max\": %.4g, \"seconds\": %ld, \"frames_hit\": %lld, \"leaf_depths\": {", knuth, sum / knuth, mx, (long)(time(NULL) - t0), nsol);
        int first = 1; for (int i = 0; i < 300; i++) if (leaf[i]) { printf("%s\"%d\": %lld", first ? "" : ", ", i, leaf[i]); first = 0; }
        printf("}}\n"); return 0;
    }
    search(R, okx, okz, live, NI, 0, DIM);
    long long tot = 0; int maxd = 0; for (int i = 0; i < 300; i++) { tot += nodes[i]; if (nodes[i]) maxd = i; }
    printf("{\"status\": \"%s\", \"frames\": %lld, \"nodes\": %lld, \"seconds\": %ld, \"shard\": %d, \"nshard\": %d, \"per_depth\": [",
           timed_out ? "TIME_LIMIT" : "COMPLETE", nsol, tot, (long)(time(NULL) - t0), shard, nshard);
    for (int i = 0; i <= maxd; i++) printf("%s[%lld,%lld,%lld]", i ? "," : "", nodes[i], prunes_rank[i], prunes_empty[i]);
    printf("]}\n");
    return 0;
}
