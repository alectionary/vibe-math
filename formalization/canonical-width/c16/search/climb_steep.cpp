// Steepest sampled ascent for a width-16 canonical frame, with checkpoints.
#include <algorithm>
#include <chrono>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <random>
#include <string>
#include <unordered_set>
#include <vector>

using U = unsigned __int128;
struct UHash {
    size_t operator()(U v) const { return (size_t)v ^ ((size_t)(v >> 64) * 0x9e3779b97f4a7c15ULL); }
};
static int pop2(uint64_t x) { return __builtin_popcountll(x); }
static int dot(U a, U b) {
    return (pop2((uint64_t)a & (uint64_t)b) + pop2((uint64_t)(a >> 64) & (uint64_t)(b >> 64))) & 1;
}
static std::vector<U> load(const std::string& path) {
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
static void dump(const std::string& path, const std::vector<U>& cols) {
    std::ofstream out(path);
    for (U v : cols) out << hex128(v) << "\n";
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
    std::vector<U> rows(n), inv(n);
    for (int c = 0; c < n; ++c) {
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
                for (int s = 0; s < n; ++s) if (s != r && (rows[s] & mb)) { rows[s] ^= row; inv[s] ^= iv; }
                rows[r] = row; inv[r] = iv; found = true; break;
            }
            row ^= rows[pivot[p]]; iv ^= inv[pivot[p]];
        }
        if (!found) return false;
    }
    for (int p = 0; p < n; ++p) if (pivot[p] < 0 || rows[pivot[p]] != ((U)1 << p)) return false;
    dual.assign(n, 0);
    for (int p = 0; p < n; ++p) {
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
static int hits_of(const std::vector<U>& dual, const std::unordered_set<U, UHash>& Z) {
    int h = 0; for (U v : dual) h += Z.count(v); return h;
}
static std::string support_sig(U v) {
    std::string s;
    for (int i = 0; i < 8; ++i) if ((v >> (16 * i)) & 0xFFFF) { if (!s.empty()) s += ','; s += std::to_string(i); }
    return s.empty() ? "." : s;
}

int main(int argc, char** argv) {
    double seconds = argc > 1 ? std::stod(argv[1]) : 600;
    uint64_t seed = argc > 2 ? std::stoull(argv[2]) : 11;
    int samples = argc > 3 ? std::stoi(argv[3]) : 400;
    auto X = load("formalization/canonical-width/c16/pools/xcoords.txt");
    auto Zv = load("formalization/canonical-width/c16/pools/zcoords.txt");
    std::unordered_set<U, UHash> Zset(Zv.begin(), Zv.end()), Xset(X.begin(), X.end());
    const int dim = 128;
    std::vector<U> cols;
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
    int inx = 0; for (U c : cols) inx += Xset.count(c);
    std::vector<U> dual;
    if (!invert(cols, dual) || inx != dim) { std::cout << "bad start " << inx << "\n"; return 1; }
    int score = hits_of(dual, Zset);
    std::cout << "start hits " << score << " samples " << samples << " seed " << seed << "\n" << std::flush;
    std::mt19937_64 rng(seed);
    auto t0 = std::chrono::steady_clock::now();
    int best = score;
    long steps = 0, stall = 0;
    std::vector<char> in_cols_mark; // membership via hash
    std::unordered_set<U, UHash> colset(cols.begin(), cols.end());
    while (true) {
        double sec = std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count();
        if (sec > seconds) break;
        int best_i = -1, local = score;
        U best_x = 0;
        std::vector<U> best_nd;
        for (int s = 0; s < samples; ++s) {
            int i = rng() % dim;
            U xnew = X[rng() % X.size()];
            if (colset.count(xnew) || !dot(dual[i], xnew)) continue;
            std::vector<U> nd = dual;
            for (int k = 0; k < dim; ++k) if (k != i && dot(dual[k], xnew)) nd[k] ^= dual[i];
            int ns = hits_of(nd, Zset);
            ++steps;
            if (ns > local) { local = ns; best_i = i; best_x = xnew; best_nd.swap(nd); }
        }
        if (best_i < 0) {
            // plateau: take a tie move to travel
            for (int s = 0; s < samples && best_i < 0; ++s) {
                int i = rng() % dim;
                U xnew = X[rng() % X.size()];
                if (colset.count(xnew) || !dot(dual[i], xnew)) continue;
                std::vector<U> nd = dual;
                for (int k = 0; k < dim; ++k) if (k != i && dot(dual[k], xnew)) nd[k] ^= dual[i];
                int ns = hits_of(nd, Zset);
                ++steps;
                if (ns == score) { best_i = i; best_x = xnew; best_nd.swap(nd); local = ns; }
            }
            ++stall;
        } else stall = 0;
        if (best_i < 0) continue;
        colset.erase(cols[best_i]);
        cols[best_i] = best_x;
        colset.insert(best_x);
        dual.swap(best_nd);
        score = local;
        if (score > best) {
            best = score;
            dump("/tmp/lf91/best-" + std::to_string(seed) + ".txt", cols);
            int miss_seed6 = 0;
            std::vector<std::string> newhits;
            for (U z : dual) if (Zset.count(z)) {
                // count later
            }
            std::cout << "best " << best << " steps " << steps << " t " << sec << " seed " << seed << "\n" << std::flush;
            if (best == dim) {
                dump("/tmp/lf91/frame128.txt", cols);
                std::cout << "FOUND\n";
                return 0;
            }
        }
        if (steps % 200000 == 0) {
            std::cout << "step " << steps << " score " << score << " best " << best << " t " << sec << "\n" << std::flush;
        }
    }
    dump("/tmp/lf91/best-" + std::to_string(seed) + ".txt", cols);
    std::cout << "done best " << best << " score " << score << " steps " << steps << " seed " << seed << "\n";
    return 0;
}
