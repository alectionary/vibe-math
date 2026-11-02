/* Linear-algebra-aware exact search for frames (C16 restricted cases).
 *
 * A frame is a set of pairs (x_i, z_i) with x_i . z_j = delta_ij. Equivalently,
 * the outer products sum to the identity on the target coordinates D:
 *   sum_i x_i z_i^T = I_D.
 * Items are groups of pairs chosen together (one pair for unrestricted search,
 * g = 2 or 4 pairs for subgroup-invariant search: a sub-orbit pair (i,j,h)).
 *
 * Search state: chosen items; residual R = I_D - sum of their outer products.
 *  - Branch: take an entry (c,k) with R[c][k] = 1, using the fewest live candidates.
 *    Every completion's outer products sum to R, so some remaining item has a 1 at (c,k).
 *    Branch over exactly those items. A sibling's item is excluded in later siblings'
 *    subtrees: the sibling's own subtree already covered every completion containing it.
 *  - Prune: the vectors still needed number `need`. They must come from
 *      X' = unused X groups orthogonal to every chosen Z vector, and
 *      Z' = unused Z groups orthogonal to every chosen X vector,
 *    and the pairing restricted to span X' x span Z' must have rank >= need.
 *
 * Input: see gen_instance.py. Output: node counts per depth and every frame
 * found (or only the first, with -1). Shards: -s k -S K explores root children
 * with index = k mod K.
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <time.h>

typedef struct { uint64_t w[2]; } v128;
static inline int bit(v128 v, int c) { return (v.w[c >> 6] >> (c & 63)) & 1; }
static inline int dot(v128 a, v128 b) { return (__builtin_popcountll(a.w[0] & b.w[0]) + __builtin_popcountll(a.w[1] & b.w[1])) & 1; }
static inline v128 vxor(v128 a, v128 b) { v128 r = {{a.w[0] ^ b.w[0], a.w[1] ^ b.w[1]}}; return r; }
static inline int vzero(v128 a) { return !(a.w[0] | a.w[1]); }

static int NX, NZ, GX, GZ, g, NI, DIM, MAXD;
static v128 *XV, *ZV;            /* pool vectors */
static int *gxv, *gzv;           /* group -> g vector indices */
static int *itx, *itz, *ipx, *ipz;  /* item -> group x, group z, pair vectors (g each) */
static uint8_t *orth;            /* orth[gx*GZ+gz] = 1 if all vectors orthogonal */
static v128 Dmask;
static int only_first = 0, shard = 0, nshard = 1, knuth = 0; static double kprod, kest; static unsigned long long rng = 88172645463325252ULL;
static unsigned long long xr(void) { rng ^= rng << 13; rng ^= rng >> 7; rng ^= rng << 17; return rng; }
static long long nodes[200], prunes_rank[200], prunes_empty[200], nsol = 0;
static FILE *solf;
static int chosen[200];
static time_t t0; static long long time_limit = 0; static int timed_out = 0;

/* basis insertion (pivot = highest set bit); returns 1 if v increased rank */
static int ins(v128 *piv, uint8_t *has, v128 v) {
    for (;;) {
        if (vzero(v)) return 0;
        int h = v.w[1] ? 64 + 63 - __builtin_clzll(v.w[1]) : 63 - __builtin_clzll(v.w[0]);
        if (!has[h]) { piv[h] = v; has[h] = 1; return 1; }
        v = vxor(v, piv[h]);
    }
}
static int pair_rank(const uint8_t *okx, const uint8_t *okz, int need) {
    v128 px[128], pz[128]; uint8_t hx[128] = {0}, hz[128] = {0}; int rx = 0, rz = 0;
    v128 bx[128], bz[128];
    for (int a = 0; a < GX && rx < DIM; a++) if (okx[a]) for (int s = 0; s < g; s++) if (ins(px, hx, XV[gxv[a * g + s]])) bx[rx++] = XV[gxv[a * g + s]];
    if (rx < need) return rx;
    for (int b = 0; b < GZ && rz < DIM; b++) if (okz[b]) for (int s = 0; s < g; s++) if (ins(pz, hz, ZV[gzv[b * g + s]])) bz[rz++] = ZV[gzv[b * g + s]];
    if (rz < need) return rz;
    v128 pr[128]; uint8_t hr[128] = {0}; int r = 0;
    for (int i = 0; i < rx; i++) {
        v128 row = {{0, 0}};
        for (int j = 0; j < rz; j++) if (dot(bx[i], bz[j])) row.w[j >> 6] |= 1ULL << (j & 63);
        r += ins(pr, hr, row);
    }
    return r;
}


static int use_coloops = 0;
/* Groups that every basis drawn from the given vectors must use: a vector that is not in
 * the span of the others (a coloop) lies in every basis. Writes up to 128 group ids. */
static int coloop_groups(const uint8_t *ok, int G, const int *gv, const v128 *V, int *out) {
    v128 piv[128], pexp[128]; uint8_t has[128] = {0}; int owner[128]; int nb = 0;
    v128 used = {{0, 0}};
    for (int a = 0; a < G; a++) if (ok[a]) for (int s = 0; s < g; s++) {
        v128 v = V[gv[a * g + s]], e = {{0, 0}};
        for (;;) {
            if (vzero(v)) { used.w[0] |= e.w[0]; used.w[1] |= e.w[1]; break; }
            int h = v.w[1] ? 64 + 63 - __builtin_clzll(v.w[1]) : 63 - __builtin_clzll(v.w[0]);
            if (!has[h]) { has[h] = 1; piv[h] = v; e.w[nb >> 6] |= 1ULL << (nb & 63); pexp[h] = e; owner[nb++] = a; break; }
            v = vxor(v, piv[h]); e = vxor(e, pexp[h]);
        }
    }
    int n = 0;
    for (int b = 0; b < nb; b++) if (!((used.w[b >> 6] >> (b & 63)) & 1)) {
        int dup = 0; for (int u = 0; u < n; u++) if (out[u] == owner[b]) dup = 1;
        if (!dup) out[n++] = owner[b];
    }
    return n;
}

static void search(v128 *R, uint8_t *okx, uint8_t *okz, int *live, int nlive, int depth, int need) {
    nodes[depth]++;
    if (time_limit && (nodes[depth] & 255) == 0 && time(NULL) - t0 > time_limit) { timed_out = 1; return; }
    if (timed_out) return;
    if (need == 0) {
        nsol++;
        fprintf(solf, "FRAME"); for (int d = 0; d < depth; d++) fprintf(solf, " %d", chosen[d]); fprintf(solf, "\n"); fflush(solf);
        return;
    }
    if (pair_rank(okx, okz, need) < need) { prunes_rank[depth]++; return; }
    /* counts of live items with a 1 at each entry (c,k) */
    static int cnt[200][128][128];
    int (*C)[128] = cnt[depth];
    memset(C, 0, sizeof(int) * 128 * 128);
    for (int t = 0; t < nlive; t++) {
        int q = live[t];
        if (g == 1) {
            v128 x = XV[ipx[q]], z = ZV[ipz[q]];
            for (int wx = 0; wx < 2; wx++) for (uint64_t mx = x.w[wx]; mx; mx &= mx - 1) {
                int c = wx * 64 + __builtin_ctzll(mx);
                for (int wz = 0; wz < 2; wz++) for (uint64_t mz = z.w[wz]; mz; mz &= mz - 1) C[c][wz * 64 + __builtin_ctzll(mz)]++;
            }
        } else {
            /* entry bit = XOR over the g pairs; build the item's outer product rows */
            v128 rows[128]; uint8_t touched[128] = {0}; int tl[128], nt = 0;
            for (int s = 0; s < g; s++) {
                v128 x = XV[ipx[q * g + s]], z = ZV[ipz[q * g + s]];
                for (int wx = 0; wx < 2; wx++) for (uint64_t mx = x.w[wx]; mx; mx &= mx - 1) {
                    int c = wx * 64 + __builtin_ctzll(mx);
                    if (!touched[c]) { touched[c] = 1; rows[c] = z; tl[nt++] = c; } else rows[c] = vxor(rows[c], z);
                }
            }
            for (int u = 0; u < nt; u++) { int c = tl[u]; v128 z = rows[c];
                for (int wz = 0; wz < 2; wz++) for (uint64_t mz = z.w[wz]; mz; mz &= mz - 1) C[c][wz * 64 + __builtin_ctzll(mz)]++; }
        }
    }
    int bc = -1, bk = -1, best = 1 << 30;
    for (int c = 0; c < 128; c++) {
        if (vzero(R[c])) continue;
        for (int w = 0; w < 2; w++) for (uint64_t m = R[c].w[w]; m; m &= m - 1) {
            int k = w * 64 + __builtin_ctzll(m);
            if (C[c][k] < best) { best = C[c][k]; bc = c; bk = k; }
        }
    }
    if (best == 0) { prunes_empty[depth]++; return; }
    int forced_side = -1, forced_group = -1;
    if (use_coloops) {
        int cg[128], n;
        n = coloop_groups(okx, GX, gxv, XV, cg);
        for (int u = 0; u < n; u++) { int c = 0; for (int t = 0; t < nlive; t++) c += itx[live[t]] == cg[u];
            if (c < best) { best = c; forced_side = 0; forced_group = cg[u]; } }
        n = coloop_groups(okz, GZ, gzv, ZV, cg);
        for (int u = 0; u < n; u++) { int c = 0; for (int t = 0; t < nlive; t++) c += itz[live[t]] == cg[u];
            if (c < best) { best = c; forced_side = 1; forced_group = cg[u]; } }
        if (best == 0) { prunes_empty[depth]++; return; }
    }
    /* children: live items with a 1 at (bc,bk), or the live items of a forced group */
    int *ch = malloc(sizeof(int) * (best + 1)), nch = 0;
    for (int t = 0; t < nlive; t++) {
        int q = live[t], b = 0;
        if (forced_side == 0) b = itx[q] == forced_group;
        else if (forced_side == 1) b = itz[q] == forced_group;
        else for (int s = 0; s < g; s++) b ^= bit(XV[ipx[q * g + s]], bc) & bit(ZV[ipz[q * g + s]], bk);
        if (b) ch[nch++] = q;
    }
    if (knuth) { kprod *= nch; kest += kprod; int u = xr() % nch; int keep = ch[u]; free(ch); ch = malloc(sizeof(int)); ch[0] = keep; nch = 1; }
    uint8_t *excl = calloc(NI, 1);
    v128 R2[128]; uint8_t *okx2 = malloc(GX), *okz2 = malloc(GZ); int *live2 = malloc(sizeof(int) * (nlive + 1));
    for (int u = 0; u < nch && !timed_out; u++) {
        int q = ch[u];
        if (!knuth && depth == 0 && (u % nshard) != shard) { excl[q] = 1; continue; }
        memcpy(R2, R, sizeof(v128) * 128);
        for (int s = 0; s < g; s++) {
            v128 x = XV[ipx[q * g + s]], z = ZV[ipz[q * g + s]];
            for (int c = 0; c < 128; c++) if (bit(x, c)) R2[c] = vxor(R2[c], z);
        }
        int a = itx[q], b = itz[q];
        for (int i = 0; i < GX; i++) okx2[i] = okx[i] && orth[i * GZ + b];
        for (int j = 0; j < GZ; j++) okz2[j] = okz[j] && orth[a * GZ + j];
        okx2[a] = 0; okz2[b] = 0;
        int n2 = 0;
        for (int t = 0; t < nlive; t++) { int r = live[t]; if (!excl[r] && r != q && okx2[itx[r]] && okz2[itz[r]]) live2[n2++] = r; }
        chosen[depth] = q;
        search(R2, okx2, okz2, live2, n2, depth + 1, need - g);
        excl[q] = 1;
        if (only_first && nsol) break;
    }
    free(ch); free(excl); free(okx2); free(okz2); free(live2);
}

int main(int argc, char **argv) {
    const char *in = NULL, *out = "frames.txt";
    for (int a = 1; a < argc; a++) {
        if (!strcmp(argv[a], "-1")) only_first = 1;
        else if (!strcmp(argv[a], "-s")) shard = atoi(argv[++a]);
        else if (!strcmp(argv[a], "-S")) nshard = atoi(argv[++a]);
        else if (!strcmp(argv[a], "-t")) time_limit = atoll(argv[++a]);
        else if (!strcmp(argv[a], "-o")) out = argv[++a];
        else if (!strcmp(argv[a], "-k")) knuth = atoi(argv[++a]);
        else if (!strcmp(argv[a], "-c")) use_coloops = 1;
        else if (!strcmp(argv[a], "-r")) rng ^= strtoull(argv[++a], 0, 10) * 0x9E3779B97F4A7C15ULL;
        else in = argv[a];
    }
    FILE *f = fopen(in, "r"); if (!f) { perror(in); return 2; }
    unsigned long long a0, a1;
    if (fscanf(f, "%d %d %d %d %d %d %d", &NX, &NZ, &GX, &GZ, &g, &NI, &DIM) != 7) return 2;
    if (fscanf(f, "%llx %llx", &a0, &a1) != 2) return 2; Dmask.w[0] = a0; Dmask.w[1] = a1;
    XV = malloc(sizeof(v128) * NX); ZV = malloc(sizeof(v128) * NZ);
    for (int i = 0; i < NX; i++) { if (fscanf(f, "%llx %llx", &a0, &a1) != 2) return 2; XV[i].w[0] = a0; XV[i].w[1] = a1; }
    for (int i = 0; i < NZ; i++) { if (fscanf(f, "%llx %llx", &a0, &a1) != 2) return 2; ZV[i].w[0] = a0; ZV[i].w[1] = a1; }
    gxv = malloc(sizeof(int) * GX * g); gzv = malloc(sizeof(int) * GZ * g);
    for (int i = 0; i < GX * g; i++) if (fscanf(f, "%d", &gxv[i]) != 1) return 2;
    for (int i = 0; i < GZ * g; i++) if (fscanf(f, "%d", &gzv[i]) != 1) return 2;
    itx = malloc(sizeof(int) * NI); itz = malloc(sizeof(int) * NI); ipx = malloc(sizeof(int) * NI * g); ipz = malloc(sizeof(int) * NI * g);
    for (int q = 0; q < NI; q++) {
        if (fscanf(f, "%d %d", &itx[q], &itz[q]) != 2) return 2;
        for (int s = 0; s < g; s++) if (fscanf(f, "%d %d", &ipx[q * g + s], &ipz[q * g + s]) != 2) return 2;
    }
    orth = malloc((size_t)GX * GZ);
    for (int i = 0; i < GX; i++) { char buf[4096]; if (fscanf(f, "%4095s", buf) != 1) return 2; for (int j = 0; j < GZ; j++) orth[i * GZ + j] = buf[j] == '1'; }
    fclose(f);
    solf = fopen(out, "a");
    v128 R[128]; memset(R, 0, sizeof R);
    for (int c = 0; c < 128; c++) if (bit(Dmask, c)) R[c].w[c >> 6] |= 1ULL << (c & 63);
    uint8_t *okx = malloc(GX), *okz = malloc(GZ); memset(okx, 1, GX); memset(okz, 1, GZ);
    int *live = malloc(sizeof(int) * NI); for (int q = 0; q < NI; q++) live[q] = q;
    t0 = time(NULL);
    if (knuth) {
        double sum = 0, mx = 0; int md[200] = {0};
        for (int p = 0; p < knuth; p++) { kprod = 1; kest = 1; long long before[200]; memcpy(before, nodes, sizeof before);
            search(R, okx, okz, live, NI, 0, DIM); sum += kest; if (kest > mx) mx = kest;
            int dd = 0; for (int d = 0; d < 200; d++) if (nodes[d] > before[d]) dd = d; md[dd]++; }
        printf("{\"knuth_probes\": %d, \"mean_tree\": %.4g, \"max\": %.4g, \"seconds\": %ld, \"leaf_depths\": {", knuth, sum / knuth, mx, (long)(time(NULL) - t0));
        int first = 1; for (int d = 0; d < 200; d++) if (md[d]) { printf("%s\"%d\": %d", first ? "" : ", ", d, md[d]); first = 0; }
        printf("}, \"frames_hit\": %lld}\n", nsol); return 0;
    }
    search(R, okx, okz, live, NI, 0, DIM);
    long long tot = 0; for (int d = 0; d < 200; d++) tot += nodes[d];
    printf("{\"status\": \"%s\", \"frames\": %lld, \"nodes\": %lld, \"seconds\": %ld, \"shard\": %d, \"nshard\": %d, \"per_depth\": [", timed_out ? "TIME_LIMIT" : "COMPLETE", nsol, tot, (long)(time(NULL) - t0), shard, nshard);
    for (int d = 0; d < 200 && nodes[d]; d++) printf("%s[%lld,%lld,%lld]", d ? "," : "", nodes[d], prunes_rank[d], prunes_empty[d]);
    printf("]}\n");
    return 0;
}
