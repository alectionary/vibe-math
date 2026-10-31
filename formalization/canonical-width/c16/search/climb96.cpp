#include <algorithm>
#include <chrono>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <numeric>
#include <random>
#include <string>
#include <unordered_set>
#include <vector>

struct Vec { uint64_t lo, hi; };
int dot(Vec a, Vec b) {
    return (__builtin_popcountll(a.lo & b.lo) + __builtin_popcountll(a.hi & b.hi)) & 1;
}
bool operator==(Vec a, Vec b) { return a.lo == b.lo && a.hi == b.hi; }
struct Hash {
    size_t operator()(Vec v) const { return (size_t)v.lo ^ ((size_t)v.hi << 1); }
};

std::vector<Vec> load(const std::string& path) {
    std::ifstream in(path);
    std::vector<Vec> out;
    std::string line;
    while (std::getline(in, line)) {
        if (line.empty()) continue;
        unsigned __int128 v = 0;
        for (char c : line) {
            int d = c <= '9' ? c - '0' : c - 'a' + 10;
            v = (v << 4) | (unsigned)d;
        }
        out.push_back({(uint64_t)v, (uint64_t)(v >> 64)});
    }
    return out;
}

Vec ebit(int seed, int pos) {
    int bit = 16 * seed + ((pos % 16) + 16) % 16;
    Vec v{0, 0};
    if (bit < 64) v.lo = 1ULL << bit;
    else v.hi = 1ULL << (bit - 64);
    return v;
}
Vec add(Vec a, Vec b) { return {a.lo ^ b.lo, a.hi ^ b.hi}; }

// Inverse of the matrix with the given columns. Rows of the inverse are returned
// as the dual basis: dual[j] · column[i] = delta_ij, and dual[j] is the coordinate vector.
bool invert(const std::vector<Vec>& cols, std::vector<Vec>& dual) {
    const int n = (int)cols.size();
    // Compress to bits that appear. For the reduced problem bits 32..127 are 96 bits.
    std::vector<int> pos;
    Vec used{0, 0};
    for (auto c : cols) { used.lo |= c.lo; used.hi |= c.hi; }
    for (int b = 0; b < 64; ++b) if ((used.lo >> b) & 1) pos.push_back(b);
    for (int b = 0; b < 64; ++b) if ((used.hi >> b) & 1) pos.push_back(64 + b);
    if ((int)pos.size() != n) return false;
    std::vector<int> index(128, -1);
    for (int i = 0; i < n; ++i) index[pos[i]] = i;
    auto comp = [&](Vec c) {
        unsigned __int128 out = 0;
        // walk bits
        uint64_t lo = c.lo, hi = c.hi;
        while (lo) {
            int b = __builtin_ctzll(lo);
            out |= (unsigned __int128)1 << index[b];
            lo &= lo - 1;
        }
        while (hi) {
            int b = __builtin_ctzll(hi);
            out |= (unsigned __int128)1 << index[64 + b];
            hi &= hi - 1;
        }
        return out;
    };
    std::vector<unsigned __int128> rows(n), inv(n);
    for (int c = 0; c < n; ++c) {
        auto col = comp(cols[c]);
        while (col) {
            int r = __builtin_ctzll((uint64_t)col);
            // ctz of 128-bit: handle high
            if ((uint64_t)col) r = __builtin_ctzll((uint64_t)col);
            else r = 64 + __builtin_ctzll((uint64_t)(col >> 64));
            rows[r] |= (unsigned __int128)1 << c;
            col ^= (unsigned __int128)1 << r;
        }
    }
    for (int r = 0; r < n; ++r) inv[r] = (unsigned __int128)1 << r;
    std::vector<int> pivot(n, -1);
    for (int r = 0; r < n; ++r) {
        auto row = rows[r];
        auto iv = inv[r];
        while (row) {
            int p;
            if ((uint64_t)row) p = __builtin_ctzll((uint64_t)row);
            else p = 64 + __builtin_ctzll((uint64_t)(row >> 64));
            if (pivot[p] < 0) {
                pivot[p] = r;
                auto mb = (unsigned __int128)1 << p;
                for (int s = 0; s < n; ++s) if (s != r && (rows[s] & mb)) {
                    rows[s] ^= row;
                    inv[s] ^= iv;
                }
                rows[r] = row;
                inv[r] = iv;
                break;
            }
            row ^= rows[pivot[p]];
            iv ^= inv[pivot[p]];
        }
        if (pivot[std::min(r, n - 1)] < 0 && row == 0) {
            // may still be singular; checked below
        }
    }
    for (int p = 0; p < n; ++p) {
        if (pivot[p] < 0 || rows[pivot[p]] != ((unsigned __int128)1 << p)) return false;
    }
    dual.assign(n, {});
    for (int p = 0; p < n; ++p) {
        auto row = inv[pivot[p]];
        Vec ambient{0, 0};
        while (row) {
            int b;
            if ((uint64_t)row) b = __builtin_ctzll((uint64_t)row);
            else b = 64 + __builtin_ctzll((uint64_t)(row >> 64));
            int amb = pos[b];
            if (amb < 64) ambient.lo |= 1ULL << amb;
            else ambient.hi |= 1ULL << (amb - 64);
            row ^= (unsigned __int128)1 << b;
        }
        dual[p] = ambient;
    }
    return true;
}

int hits(const std::vector<Vec>& dual, const std::unordered_set<Vec, Hash>& target) {
    int h = 0;
    for (auto v : dual) if (target.count(v)) ++h;
    return h;
}

int main() {
    auto Zall = load("formalization/canonical-width/c16/pools/zcoords.txt");
    auto Xall = load("formalization/canonical-width/c16/pools/xcoords.txt");
    const uint64_t low32 = 0xffffffffULL;
    std::vector<Vec> X, Z;
    for (auto v : Xall) if ((v.lo & low32) == 0) X.push_back(v);
    for (auto v : Zall) if ((v.lo & low32) == 0) Z.push_back(v);
    std::unordered_set<Vec, Hash> Zset(Z.begin(), Z.end());
    std::cout << "reduced X " << X.size() << " Z " << Z.size() << "\n";

    std::vector<Vec> base;
    for (int h = 0; h < 16; ++h) {
        base.push_back(add(ebit(2, h + 3), ebit(3, h)));
        base.push_back(ebit(3, h));
        base.push_back(ebit(4, h));
        base.push_back(add(ebit(4, h), ebit(5, h)));
        base.push_back(ebit(7, h));
        base.push_back(add(ebit(6, h + 3), ebit(7, h)));
    }
    std::unordered_set<Vec, Hash> Xset(X.begin(), X.end());
    int inx = 0;
    for (auto v : base) inx += Xset.count(v);
    std::cout << "base in X " << inx << "/" << base.size() << "\n";
    std::vector<Vec> dual;
    if (!invert(base, dual)) { std::cout << "base singular\n"; return 1; }
    int score = hits(dual, Zset);
    std::cout << "base hits " << score << "\n" << std::flush;

    std::mt19937_64 rng(7);
    auto t0 = std::chrono::steady_clock::now();
    int best = score;
    long steps = 0, accepted = 0;
    std::vector<Vec> cols = base;
    while (true) {
        double sec = std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count();
        if (sec > 180) break;
        int i = rng() % cols.size();
        Vec cand = X[rng() % X.size()];
        Vec old = cols[i];
        cols[i] = cand;
        std::vector<Vec> nd;
        if (!invert(cols, nd)) { cols[i] = old; ++steps; continue; }
        int ns = hits(nd, Zset);
        ++steps;
        if (ns >= score) {
            score = ns;
            dual.swap(nd);
            ++accepted;
            if (score > best) {
                best = score;
                std::cout << "best " << best << " steps " << steps << " t " << sec << "\n" << std::flush;
                if (best == (int)cols.size()) {
                    std::ofstream out("/tmp/lf91/frame96-x.txt");
                    for (auto v : cols) {
                        unsigned __int128 x = ((unsigned __int128)v.hi << 64) | v.lo;
                        for (int k = 31; k >= 0; --k) {
                            int d = (x >> (4 * k)) & 0xf;
                            out << "0123456789abcdef"[d];
                        }
                        out << "\n";
                    }
                    break;
                }
            }
        } else cols[i] = old;
        if (steps % 5000 == 0) {
            std::cout << "step " << steps << " score " << score << " best " << best
                      << " acc " << accepted << " t " << sec << "\n" << std::flush;
        }
    }
    std::cout << "done best " << best << " steps " << steps << "\n";
    return 0;
}
