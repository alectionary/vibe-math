// Iterated local search: strict ascent, then a random kick, from a saved basis.
#include <chrono>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <random>
#include <string>
#include <unordered_set>
#include <vector>

using U = unsigned __int128;
struct UH { size_t operator()(U v) const { return (size_t)v ^ (size_t)(v >> 64); } };
static int dot(U a, U b) {
    return (__builtin_popcountll((uint64_t)a & (uint64_t)b) +
            __builtin_popcountll((uint64_t)(a >> 64) & (uint64_t)(b >> 64))) & 1;
}
static std::vector<U> load(const std::string& path) {
    std::ifstream in(path); std::vector<U> out; std::string line;
    while (std::getline(in, line)) {
        if (line.empty()) continue;
        U v = 0;
        for (char c : line) v = (v << 4) | (unsigned)((c <= '9') ? c - '0' : c - 'a' + 10);
        out.push_back(v);
    }
    return out;
}
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
    std::vector<int> pos; U used = 0;
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
            col |= (U)1 << index[b]; cc ^= (U)1 << b;
        }
        while (col) {
            int r = (uint64_t)col ? __builtin_ctzll((uint64_t)col) : 64 + __builtin_ctzll((uint64_t)(col >> 64));
            rows[r] |= (U)1 << c; col ^= (U)1 << r;
        }
    }
    for (int r = 0; r < n; ++r) inv[r] = (U)1 << r;
    std::vector<int> pivot(n, -1);
    for (int r = 0; r < n; ++r) {
        U row = rows[r], iv = inv[r]; bool found = false;
        while (row) {
            int p = (uint64_t)row ? __builtin_ctzll((uint64_t)row) : 64 + __builtin_ctzll((uint64_t)(row >> 64));
            if (pivot[p] < 0) {
                pivot[p] = r; U mb = (U)1 << p;
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
            ambient |= (U)1 << pos[b]; row ^= (U)1 << b;
        }
        dual[p] = ambient;
    }
    return true;
}
static int hits_of(const std::vector<U>& d, const std::unordered_set<U, UH>& Z) {
    int h = 0; for (U v : d) h += Z.count(v); return h;
}

int main(int argc, char** argv) {
    std::string start_path = argc > 1 ? argv[1] : "/tmp/lf91/best-11.txt";
    int kick = argc > 2 ? std::stoi(argv[2]) : 8;
    double seconds = argc > 3 ? std::stod(argv[3]) : 1200;
    uint64_t seed = argc > 4 ? std::stoull(argv[4]) : 19;
    auto X = load("formalization/canonical-width/c16/pools/xcoords.txt");
    auto Zv = load("formalization/canonical-width/c16/pools/zcoords.txt");
    std::unordered_set<U, UH> Zset(Zv.begin(), Zv.end());
    std::vector<U> cols = load(start_path);
    std::vector<U> dual;
    if (!invert(cols, dual)) { std::cout << "bad start\n"; return 1; }
    int score = hits_of(dual, Zset);
    int best = score;
    std::vector<U> best_cols = cols;
    std::cout << "start " << score << " kick " << kick << " seed " << seed << "\n" << std::flush;
    std::mt19937_64 rng(seed);
    std::unordered_set<U, UH> colset(cols.begin(), cols.end());
    auto t0 = std::chrono::steady_clock::now();
    long steps = 0, kicks = 0;
    auto climb = [&](int rounds) {
        for (int r = 0; r < rounds; ++r) {
            bool improved = false;
            for (int s = 0; s < 2000; ++s) {
                int i = rng() % 128;
                U xnew = X[rng() % X.size()];
                if (colset.count(xnew) || !dot(dual[i], xnew)) continue;
                std::vector<U> nd = dual;
                for (int k = 0; k < 128; ++k) if (k != i && dot(dual[k], xnew)) nd[k] ^= dual[i];
                int ns = hits_of(nd, Zset);
                ++steps;
                if (ns > score) {
                    colset.erase(cols[i]); cols[i] = xnew; colset.insert(xnew);
                    dual.swap(nd); score = ns; improved = true;
                    if (score > best) {
                        best = score; best_cols = cols;
                        dump("/tmp/lf91/ils-best-" + std::to_string(seed) + ".txt", cols);
                        double sec = std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count();
                        std::cout << "best " << best << " kicks " << kicks << " steps " << steps
                                  << " t " << sec << "\n" << std::flush;
                        if (best == 128) return true;
                    }
                    break;
                }
            }
            if (!improved) return false;
        }
        return false;
    };
    climb(100000);
    while (std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count() < seconds) {
        // Kick from the incumbent best, not from a drifted state.
        cols = best_cols;
        colset = std::unordered_set<U, UH>(cols.begin(), cols.end());
        if (!invert(cols, dual)) { std::cout << "best singular\n"; return 1; }
        score = best;
        std::vector<U> trial = cols;
        std::unordered_set<U, UH> tset = colset;
        for (int k = 0; k < kick; ++k) {
            int i = rng() % 128;
            for (int attempt = 0; attempt < 30; ++attempt) {
                U xnew = X[rng() % X.size()];
                if (tset.count(xnew)) continue;
                tset.erase(trial[i]); trial[i] = xnew; tset.insert(xnew);
                break;
            }
        }
        std::vector<U> nd;
        if (!invert(trial, nd)) continue;
        int ns = hits_of(nd, Zset);
        cols.swap(trial); dual.swap(nd); colset.swap(tset); score = ns;
        ++kicks;
        if (climb(100000)) { std::cout << "FOUND\n"; return 0; }
        if (kicks % 20 == 0) {
            double sec = std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count();
            std::cout << "kick " << kicks << " score " << score << " best " << best
                      << " t " << sec << "\n" << std::flush;
        }
    }
    std::cout << "done best " << best << " kicks " << kicks << "\n";
    return 0;
}
