// Compatibility-graph coloring and targeted hill climb for width-16 canonical frames.
// Logical coordinates: bit i pairs with canonical opposite-sector frame operator i.
// A vertex is an ordered pool pair (x,z) with x·z = 1. Two vertices are adjacent when
// the cross pairings vanish. A canonical frame is a clique of size equal to the
// dimension whose x-columns and z-rows are bases. A proper coloring with fewer
// colors than that dimension rules a frame out.
#include <algorithm>
#include <chrono>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <numeric>
#include <random>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

using U = unsigned __int128;
struct UHash {
    size_t operator()(U v) const {
        return (size_t)v ^ ((size_t)(v >> 64) << 1);
    }
};

static int pop2(uint64_t x) { return __builtin_popcountll(x); }
static int dot(U a, U b) {
    return (pop2((uint64_t)a & (uint64_t)b) + pop2((uint64_t)(a >> 64) & (uint64_t)(b >> 64))) & 1;
}

static std::vector<U> load(const std::string& path, bool reduced) {
    std::ifstream in(path);
    std::vector<U> out;
    std::string line;
    while (std::getline(in, line)) {
        if (line.empty()) continue;
        U v = 0;
        for (char c : line) {
            int d = (c <= '9') ? c - '0' : c - 'a' + 10;
            v = (v << 4) | (unsigned)d;
        }
        if (reduced && ((uint64_t)v & 0xffffffffULL)) continue;
        out.push_back(v);
    }
    return out;
}

struct Bitset {
    std::vector<uint64_t> w;
    explicit Bitset(int n = 0) : w((n + 63) / 64) {}
    void set(int i) { w[i >> 6] |= 1ULL << (i & 63); }
    bool test(int i) const { return (w[i >> 6] >> (i & 63)) & 1; }
    void clear(int i) { w[i >> 6] &= ~(1ULL << (i & 63)); }
};

static int greedy_color(const std::vector<U>& X, const std::vector<U>& Z, const std::vector<std::pair<int,int>>& verts,
                        const std::string& order_name, std::mt19937_64& rng) {
    const int n = (int)verts.size();
    std::vector<int> order(n);
    std::iota(order.begin(), order.end(), 0);
    if (order_name == "random") std::shuffle(order.begin(), order.end(), rng);
    else if (order_name == "rev") std::reverse(order.begin(), order.end());
    // degree-based: count partners roughly by sampling? Full degree is O(n^2).
    // For n<=12000 we compute degree exactly while coloring on the fly only once.
    std::vector<int> color(n, -1);
    int ncolors = 0;
    std::vector<int> forbid(n + 1);
    int stamp = 1;
    for (int idx : order) {
        auto [xi, zi] = verts[idx];
        U x = X[xi], z = Z[zi];
        ++stamp;
        if (stamp == 0) { std::fill(forbid.begin(), forbid.end(), 0); stamp = 1; }
        for (int j = 0; j < n; ++j) if (color[j] >= 0) {
            auto [xj, zj] = verts[j];
            // adjacent = compatible = cross pairings zero, and distinct pairs
            if (xj == xi || zj == zi) continue;
            if (dot(x, Z[zj]) == 0 && dot(X[xj], z) == 0) forbid[color[j]] = stamp;
        }
        int c = 0;
        while (forbid[c] == stamp) ++c;
        color[idx] = c;
        if (c + 1 > ncolors) ncolors = c + 1;
    }
    // verify
    for (int i = 0; i < n; ++i) for (int j = i + 1; j < n && false; ++j) {}
    return ncolors;
}

// Faster coloring: build adjacency bitset first (n up to ~10k).
static int color_with_graph(const std::vector<U>& X, const std::vector<U>& Z,
                            const std::vector<std::pair<int,int>>& verts, const std::string& how,
                            std::mt19937_64& rng) {
    const int n = (int)verts.size();
    std::cout << "building graph n=" << n << "\n" << std::flush;
    std::vector<Bitset> adj(n, Bitset(n));
    std::vector<int> deg(n);
    for (int i = 0; i < n; ++i) {
        U x = X[verts[i].first], z = Z[verts[i].second];
        for (int j = i + 1; j < n; ++j) {
            int xj = verts[j].first, zj = verts[j].second;
            if (xj == verts[i].first || zj == verts[i].second) continue;
            if (dot(x, Z[zj]) == 0 && dot(X[xj], z) == 0) {
                adj[i].set(j); adj[j].set(i); deg[i]++; deg[j]++;
            }
        }
        if ((i + 1) % 500 == 0) std::cout << "  row " << i + 1 << "\n" << std::flush;
    }
    std::vector<int> order(n);
    std::iota(order.begin(), order.end(), 0);
    if (how == "degree") std::sort(order.begin(), order.end(), [&](int a, int b) { return deg[a] > deg[b]; });
    else if (how == "random") std::shuffle(order.begin(), order.end(), rng);
    else if (how == "revdeg") std::sort(order.begin(), order.end(), [&](int a, int b) { return deg[a] < deg[b]; });
    std::vector<int> color(n, -1);
    int ncolors = 0;
    std::vector<int> forbid(n);
    for (int idx : order) {
        std::fill(forbid.begin(), forbid.begin() + ncolors + 1, 0);
        for (int word = 0; word < (int)adj[idx].w.size(); ++word) {
            uint64_t bits = adj[idx].w[word];
            while (bits) {
                int b = __builtin_ctzll(bits);
                int j = (word << 6) + b;
                if (j < n && color[j] >= 0) forbid[color[j]] = 1;
                bits &= bits - 1;
            }
        }
        int c = 0;
        while (c <= ncolors && forbid[c]) ++c;
        color[idx] = c;
        if (c + 1 > ncolors) ncolors = c + 1;
    }
    // spot-verify 2000 random edges
    std::uniform_int_distribution<int> dist(0, n - 1);
    for (int t = 0; t < 2000; ++t) {
        int i = dist(rng), j = dist(rng);
        if (i == j || !adj[i].test(j)) continue;
        if (color[i] == color[j]) {
            std::cout << "COLORING BUG\n";
            return -1;
        }
    }
    std::cout << "colored " << how << " -> " << ncolors << " maxdeg " << *std::max_element(deg.begin(), deg.end()) << "\n";
    return ncolors;
}

static bool invert(const std::vector<U>& cols, std::vector<U>& dual) {
    const int n = (int)cols.size();
    std::vector<int> pos;
    U used = 0;
    for (U c : cols) used |= c;
    for (int b = 0; b < 128; ++b) if ((used >> b) & 1) pos.push_back(b);
    if ((int)pos.size() != n) return false;
    std::vector<int> index(128, -1);
    for (int i = 0; i < n; ++i) index[pos[i]] = i;
    auto comp = [&](U c) {
        U out = 0;
        while (c) {
            int b = (uint64_t)c ? __builtin_ctzll((uint64_t)c) : 64 + __builtin_ctzll((uint64_t)(c >> 64));
            out |= (U)1 << index[b];
            c ^= (U)1 << b;
        }
        return out;
    };
    std::vector<U> rows(n), inv(n);
    for (int c = 0; c < n; ++c) {
        U col = comp(cols[c]);
        while (col) {
            int r = (uint64_t)col ? __builtin_ctzll((uint64_t)col) : 64 + __builtin_ctzll((uint64_t)(col >> 64));
            rows[r] |= (U)1 << c;
            col ^= (U)1 << r;
        }
    }
    for (int r = 0; r < n; ++r) inv[r] = (U)1 << r;
    std::vector<int> pivot(n, -1);
    for (int r = 0; r < n; ++r) {
        U row = rows[r], iv = inv[r];
        bool found = false;
        while (row) {
            int p = (uint64_t)row ? __builtin_ctzll((uint64_t)row) : 64 + __builtin_ctzll((uint64_t)(row >> 64));
            if (pivot[p] < 0) {
                pivot[p] = r;
                U mb = (U)1 << p;
                for (int s = 0; s < n; ++s) if (s != r && (rows[s] & mb)) {
                    rows[s] ^= row; inv[s] ^= iv;
                }
                rows[r] = row; inv[r] = iv;
                found = true;
                break;
            }
            row ^= rows[pivot[p]];
            iv ^= inv[pivot[p]];
        }
        if (!found) return false;
    }
    for (int p = 0; p < n; ++p)
        if (pivot[p] < 0 || rows[pivot[p]] != ((U)1 << p)) return false;
    dual.assign(n, 0);
    for (int p = 0; p < n; ++p) {
        U row = inv[pivot[p]];
        U ambient = 0;
        while (row) {
            int b = (uint64_t)row ? __builtin_ctzll((uint64_t)row) : 64 + __builtin_ctzll((uint64_t)(row >> 64));
            ambient |= (U)1 << pos[b];
            row ^= (U)1 << b;
        }
        dual[p] = ambient;
    }
    return true;
}

static int hits_of(const std::vector<U>& dual, const std::unordered_set<U, UHash>& target) {
    int h = 0;
    for (U v : dual) if (target.count(v)) ++h;
    return h;
}

static U ebit(int seed, int pos) {
    return (U)1 << (16 * seed + ((pos % 16) + 16) % 16);
}

static void climb(const std::vector<U>& X, const std::unordered_set<U, UHash>& Zset, bool reduced, double seconds, uint64_t seed) {
    const int dim = reduced ? 96 : 128;
    std::vector<U> cols;
    if (reduced) {
        for (int h = 0; h < 16; ++h) {
            cols.push_back(ebit(2, h + 3) ^ ebit(3, h));
            cols.push_back(ebit(3, h));
            cols.push_back(ebit(4, h));
            cols.push_back(ebit(4, h) ^ ebit(5, h));
            cols.push_back(ebit(7, h));
            cols.push_back(ebit(6, h + 3) ^ ebit(7, h));
        }
    } else {
        for (int h = 0; h < 16; ++h) {
            cols.push_back(ebit(0, h));
            cols.push_back(ebit(1, h));
            cols.push_back(ebit(2, h + 3) ^ ebit(3, h));
            cols.push_back(ebit(3, h));
            cols.push_back(ebit(4, h));
            cols.push_back(ebit(4, h) ^ ebit(5, h));
            cols.push_back(ebit(7, h));
            cols.push_back(ebit(6, h + 3) ^ ebit(7, h));
        }
    }
    int inx = 0;
    std::unordered_set<U, UHash> Xset(X.begin(), X.end());
    for (U c : cols) inx += Xset.count(c);
    std::vector<U> dual;
    if (!invert(cols, dual)) { std::cout << "start singular reduced=" << reduced << "\n"; return; }
    int score = hits_of(dual, Zset);
    std::cout << "start inX " << inx << "/" << cols.size() << " hits " << score << " dim " << dim << "\n" << std::flush;
    // Partner lists: for each dual, we recompute against X on demand via a hash of dots.
    // Precompute for every pool X the... we'll just scan X (720) which is fine.
    std::mt19937_64 rng(seed);
    auto t0 = std::chrono::steady_clock::now();
    long steps = 0, accepted = 0;
    int best = score;
    std::vector<U> best_cols = cols, best_dual = dual;
    while (true) {
        double sec = std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count();
        if (sec > seconds) break;
        // Targeted repair attempts mixed with random swaps.
        bool targeted = (rng() % 3) == 0;
        int i = -1, pick = -1;
        if (targeted) {
            // Find a missing dual k and a column i such that z_k + z_i is in the pool.
            int k = -1;
            for (int t = 0; t < 40 && k < 0; ++t) {
                int cand = rng() % dim;
                if (!Zset.count(dual[cand])) k = cand;
            }
            if (k >= 0) {
                for (int t = 0; t < 30; ++t) {
                    int ii = rng() % dim;
                    if (ii == k) continue;
                    if (Zset.count(dual[k] ^ dual[ii])) { i = ii; break; }
                }
            }
        }
        if (i < 0) i = rng() % dim;
        // x must pair with dual[i]
        // sample random X until one pairs, bounded tries
        U xnew = 0;
        bool found = false;
        for (int t = 0; t < 80; ++t) {
            U cand = X[rng() % X.size()];
            if (cand != cols[i] && dot(dual[i], cand)) { xnew = cand; found = true; break; }
        }
        if (!found) { ++steps; continue; }
        bool dup = false;
        for (U c : cols) if (c == xnew) dup = true;
        if (dup) { ++steps; continue; }
        // Apply Sherman-Morrison update over F2.
        std::vector<U> nd = dual;
        for (int k = 0; k < dim; ++k) if (k != i && dot(dual[k], xnew)) nd[k] ^= dual[i];
        // z_i unchanged. Sanity: new column pairs with new duals as identity on i.
        int ns = hits_of(nd, Zset);
        ++steps;
        bool ok_accept = ns >= score;
        // rare downhill
        if (!ok_accept && ns + 1 >= score && (rng() % 50) == 0) ok_accept = true;
        if (ok_accept) {
            cols[i] = xnew;
            dual.swap(nd);
            score = ns;
            ++accepted;
            if (score > best) {
                best = score;
                best_cols = cols;
                best_dual = dual;
                std::cout << "best " << best << " steps " << steps << " t " << sec
                          << " reduced " << reduced << " seed " << seed << "\n" << std::flush;
                if (best == dim) {
                    std::ofstream out(reduced ? "/tmp/lf91/frame96.txt" : "/tmp/lf91/frame128.txt");
                    for (U v : cols) {
                        for (int k = 31; k >= 0; --k) out << "0123456789abcdef"[(int)((v >> (4 * k)) & 0xf)];
                        out << "\n";
                    }
                    std::cout << "FOUND\n";
                    return;
                }
            }
        }
        if (steps % 20000 == 0) {
            std::cout << "step " << steps << " score " << score << " best " << best
                      << " acc " << accepted << " t " << sec << " red " << reduced << "\n" << std::flush;
        }
    }
    std::cout << "done best " << best << " steps " << steps << " red " << reduced << " seed " << seed << "\n";
}

static void selftest() {
    auto X = load("formalization/canonical-width/c16/pools/xcoords.txt", true);
    auto Zv = load("formalization/canonical-width/c16/pools/zcoords.txt", true);
    std::unordered_set<U, UHash> Zset(Zv.begin(), Zv.end());
    std::vector<U> cols;
    for (int h = 0; h < 16; ++h) {
        cols.push_back(ebit(2, h + 3) ^ ebit(3, h));
        cols.push_back(ebit(3, h));
        cols.push_back(ebit(4, h));
        cols.push_back(ebit(4, h) ^ ebit(5, h));
        cols.push_back(ebit(7, h));
        cols.push_back(ebit(6, h + 3) ^ ebit(7, h));
    }
    std::vector<U> dual;
    if (!invert(cols, dual)) { std::cout << "selftest singular\n"; return; }
    int score = hits_of(dual, Zset);
    std::cout << "selftest base hits " << score << "\n";
    std::mt19937_64 rng(3);
    int checks = 0;
    for (int t = 0; t < 200; ++t) {
        int i = rng() % 96;
        U xnew = 0; bool found = false;
        for (int s = 0; s < 100; ++s) {
            U cand = X[rng() % X.size()];
            bool dup = false; for (U c : cols) if (c == cand) dup = true;
            if (!dup && dot(dual[i], cand)) { xnew = cand; found = true; break; }
        }
        if (!found) continue;
        std::vector<U> nd = dual;
        for (int k = 0; k < 96; ++k) if (k != i && dot(dual[k], xnew)) nd[k] ^= dual[i];
        std::vector<U> cols2 = cols; cols2[i] = xnew;
        std::vector<U> exact;
        if (!invert(cols2, exact)) { std::cout << "selftest formula accepted singular\n"; return; }
        if (exact != nd) { std::cout << "selftest MISMATCH\n"; return; }
        // Gram check
        for (int a = 0; a < 96; ++a) for (int b = 0; b < 96; ++b) {
            if (dot(cols2[a], exact[b]) != (a == b)) { std::cout << "gram fail\n"; return; }
        }
        cols.swap(cols2); dual.swap(nd); ++checks;
    }
    std::cout << "selftest ok updates " << checks << "\n";
}

int main(int argc, char** argv) {
    std::string mode = argc > 1 ? argv[1] : "climb";
    if (mode == "selftest") { selftest(); return 0; }
    if (mode == "color-reduced") {
        auto X = load("formalization/canonical-width/c16/pools/xcoords.txt", true);
        auto Z = load("formalization/canonical-width/c16/pools/zcoords.txt", true);
        std::cout << "pools " << X.size() << " " << Z.size() << "\n";
        std::vector<std::pair<int,int>> verts;
        for (int i = 0; i < (int)X.size(); ++i)
            for (int j = 0; j < (int)Z.size(); ++j)
                if (dot(X[i], Z[j])) verts.push_back({i, j});
        std::cout << "vertices " << verts.size() << "\n" << std::flush;
        std::mt19937_64 rng(1);
        color_with_graph(X, Z, verts, "degree", rng);
        return 0;
    }
    bool reduced = mode == "climb96";
    double seconds = argc > 2 ? std::stod(argv[2]) : 600;
    uint64_t seed = argc > 3 ? std::stoull(argv[3]) : 1;
    auto X = load("formalization/canonical-width/c16/pools/xcoords.txt", reduced);
    auto Zv = load("formalization/canonical-width/c16/pools/zcoords.txt", reduced);
    std::unordered_set<U, UHash> Zset(Zv.begin(), Zv.end());
    climb(X, Zset, reduced, seconds, seed);
    return 0;
}
