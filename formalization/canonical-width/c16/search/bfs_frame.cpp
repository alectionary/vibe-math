// Best-first search over column swaps that do not decrease the dual-hit score.
#include <algorithm>
#include <array>
#include <chrono>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <queue>
#include <unordered_map>
#include <unordered_set>
#include <vector>

using U = unsigned __int128;
struct UH {
    size_t operator()(U v) const { return (size_t)v ^ (size_t)(v >> 64); }
};
static int dot(U a, U b) {
    return (__builtin_popcountll((uint64_t)a & (uint64_t)b) +
            __builtin_popcountll((uint64_t)(a >> 64) & (uint64_t)(b >> 64))) & 1;
}
static std::vector<U> load(const std::string& path) {
    std::ifstream in(path);
    std::vector<U> out;
    std::string line;
    while (std::getline(in, line)) {
        if (line.empty()) continue;
        U v = 0;
        for (char c : line) v = (v << 4) | (unsigned)((c <= '9') ? c - '0' : c - 'a' + 10);
        out.push_back(v);
    }
    return out;
}
static U ebit(int s, int p) { return (U)1 << (16 * s + ((p % 16) + 16) % 16); }
static std::string hex128(U v) {
    std::string s(32, '0');
    for (int k = 0; k < 32; ++k) s[31 - k] = "0123456789abcdef"[(int)((v >> (4 * k)) & 0xf)];
    return s;
}

static bool invert_idx(const std::vector<U>& X, const std::array<uint16_t, 128>& idx, std::array<U, 128>& dual) {
    U cols[128], used = 0;
    for (int i = 0; i < 128; ++i) { cols[i] = X[idx[i]]; used |= cols[i]; }
    std::vector<int> pos;
    for (int b = 0; b < 128; ++b) if ((used >> b) & 1) pos.push_back(b);
    if ((int)pos.size() != 128) return false;
    int index[128];
    for (int i = 0; i < 128; ++i) index[i] = -1;
    for (int i = 0; i < (int)pos.size(); ++i) index[pos[i]] = i;
    U rows[128] = {}, inv[128] = {};
    for (int c = 0; c < 128; ++c) {
        U col = 0, cc = cols[c];
        while (cc) {
            int b = (uint64_t)cc ? __builtin_ctzll((uint64_t)cc) : 64 + __builtin_ctzll((uint64_t)(cc >> 64));
            col |= (U)1 << index[b];
            cc ^= (U)1 << b;
        }
        while (col) {
            int r = (uint64_t)col ? __builtin_ctzll((uint64_t)col) : 64 + __builtin_ctzll((uint64_t)(col >> 64));
            rows[r] |= (U)1 << c;
            col ^= (U)1 << r;
        }
    }
    for (int r = 0; r < 128; ++r) inv[r] = (U)1 << r;
    int pivot[128];
    for (int i = 0; i < 128; ++i) pivot[i] = -1;
    for (int r = 0; r < 128; ++r) {
        U row = rows[r], iv = inv[r];
        bool found = false;
        while (row) {
            int p = (uint64_t)row ? __builtin_ctzll((uint64_t)row) : 64 + __builtin_ctzll((uint64_t)(row >> 64));
            if (pivot[p] < 0) {
                pivot[p] = r;
                U mb = (U)1 << p;
                for (int s = 0; s < 128; ++s) if (s != r && (rows[s] & mb)) { rows[s] ^= row; inv[s] ^= iv; }
                rows[r] = row;
                inv[r] = iv;
                found = true;
                break;
            }
            row ^= rows[pivot[p]];
            iv ^= inv[pivot[p]];
        }
        if (!found) return false;
    }
    for (int p = 0; p < 128; ++p) if (pivot[p] < 0 || rows[pivot[p]] != ((U)1 << p)) return false;
    for (int p = 0; p < 128; ++p) {
        U row = inv[pivot[p]], ambient = 0;
        while (row) {
            int b = (uint64_t)row ? __builtin_ctzll((uint64_t)row) : 64 + __builtin_ctzll((uint64_t)(row >> 64));
            ambient |= (U)1 << pos[b];
            row ^= (U)1 << b;
        }
        dual[p] = ambient;
    }
    return true;
}

struct Key {
    std::array<uint16_t, 128> a;
    bool operator==(const Key& o) const { return a == o.a; }
};
struct KH {
    size_t operator()(const Key& k) const {
        uint64_t h = 1469598103934665603ULL;
        for (uint16_t x : k.a) { h ^= x; h *= 1099511628211ULL; }
        return (size_t)h;
    }
};

struct Node {
    int score;
    int depth;
    std::array<uint16_t, 128> idx;
    bool operator<(const Node& o) const {
        if (score != o.score) return score < o.score;  // max-heap via priority_queue
        return depth > o.depth;
    }
};

static int score_of(const std::array<U, 128>& dual, const std::unordered_set<U, UH>& Zset) {
    int h = 0;
    for (U z : dual) h += Zset.count(z);
    return h;
}

int main(int argc, char** argv) {
    double seconds = argc > 1 ? std::stod(argv[1]) : 420;
    int node_cap = argc > 2 ? std::stoi(argv[2]) : 150000;
    auto X = load("formalization/canonical-width/c16/pools/xcoords.txt");
    auto Zv = load("formalization/canonical-width/c16/pools/zcoords.txt");
    std::unordered_set<U, UH> Zset(Zv.begin(), Zv.end());
    std::unordered_map<U, uint16_t, UH> xid;
    for (int i = 0; i < (int)X.size(); ++i) xid[X[i]] = (uint16_t)i;

    std::array<uint16_t, 128> start{};
    int n = 0;
    for (int h = 0; h < 16; ++h) {
        U cs[8] = {
            ebit(0, h), ebit(1, h), ebit(2, h + 3) ^ ebit(3, h), ebit(3, h),
            ebit(4, h), ebit(4, h) ^ ebit(5, h), ebit(7, h), ebit(6, h + 3) ^ ebit(7, h)
        };
        for (U c : cs) {
            if (!xid.count(c)) { std::cout << "start vector missing\n"; return 1; }
            start[n++] = xid[c];
        }
    }
    std::array<U, 128> dual{};
    if (!invert_idx(X, start, dual)) { std::cout << "singular start\n"; return 1; }
    int base = score_of(dual, Zset);
    std::cout << "start hits " << base << " pool " << X.size() << "\n" << std::flush;

    auto key_of = [](std::array<uint16_t, 128> a) {
        std::sort(a.begin(), a.end());
        return Key{a};
    };
    std::priority_queue<Node> pq;
    std::unordered_set<Key, KH> seen;
    pq.push({base, 0, start});
    seen.insert(key_of(start));
    int best = base;
    long expanded = 0, pushed = 0;
    auto t0 = std::chrono::steady_clock::now();
    std::array<uint16_t, 128> best_idx = start;

    while (!pq.empty()) {
        double sec = std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count();
        if (sec > seconds || expanded >= node_cap) break;
        Node cur = pq.top(); pq.pop();
        if (cur.score < best - 0) {
            // priority queue may contain stale lower scores; still expand ties at the frontier
        }
        std::array<U, 128> du{};
        if (!invert_idx(X, cur.idx, du)) continue;
        int sc = score_of(du, Zset);
        if (sc != cur.score) { std::cout << "score mismatch\n"; return 1; }
        ++expanded;
        std::unordered_set<uint16_t> inset(cur.idx.begin(), cur.idx.end());
        uint8_t hit[128];
        for (int t = 0; t < 128; ++t) hit[t] = Zset.count(du[t]);

        // Gather candidate x indices per column by one pass over X.
        // Store as vector of vectors.
        std::vector<int> part[128];
        for (int j = 0; j < (int)X.size(); ++j) {
            if (inset.count((uint16_t)j)) continue;
            U x = X[j];
            for (int i = 0; i < 128; ++i) if (dot(du[i], x)) part[i].push_back(j);
        }
        int local_best = sc;
        int zero_edges = 0, pos_edges = 0;
        for (int i = 0; i < 128; ++i) {
            U zi = du[i];
            for (int j : part[i]) {
                U x = X[j];
                int delta = 0;
                for (int t = 0; t < 128; ++t) {
                    if (t == i) continue;
                    if (!dot(du[t], x)) continue;
                    U nz = du[t] ^ zi;
                    bool was = hit[t];
                    bool now = Zset.count(nz);
                    if (was && !now) --delta;
                    else if (!was && now) ++delta;
                }
                if (delta < 0) continue;
                if (delta > 0) ++pos_edges; else ++zero_edges;
                std::array<uint16_t, 128> nxt = cur.idx;
                nxt[i] = (uint16_t)j;
                Key k = key_of(nxt);
                if (!seen.insert(k).second) continue;
                int ns = sc + delta;
                pq.push({ns, cur.depth + 1, nxt});
                ++pushed;
                if (ns > best) {
                    best = ns;
                    best_idx = nxt;
                    std::cout << "best " << best << " depth " << cur.depth + 1
                              << " expanded " << expanded << " t " << sec << "\n" << std::flush;
                    std::ofstream out("/tmp/lf91/bfs-best.txt");
                    for (uint16_t id : nxt) out << hex128(X[id]) << "\n";
                    if (best == 128) { std::cout << "FOUND\n"; return 0; }
                }
                (void)local_best;
            }
        }
        if (expanded % 20 == 0) {
            std::cout << "exp " << expanded << " score " << sc << " depth " << cur.depth
                      << " zero " << zero_edges << " pos " << pos_edges
                      << " q " << pq.size() << " seen " << seen.size()
                      << " best " << best << " t " << sec << "\n" << std::flush;
        }
    }
    std::cout << "stop best " << best << " expanded " << expanded << " pushed " << pushed
              << " seen " << seen.size() << "\n";
    return 0;
}
