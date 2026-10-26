#include <algorithm>
#include <chrono>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <numeric>
#include <random>
#include <string>
#include <vector>

struct Vec {
    uint64_t lo, hi;
};

int dot(Vec a, Vec b) {
    return (__builtin_popcountll(a.lo & b.lo) + __builtin_popcountll(a.hi & b.hi)) & 1;
}

std::vector<Vec> load(const std::string& path) {
    std::ifstream in(path);
    std::vector<Vec> out;
    std::string line;
    while (std::getline(in, line)) {
        if (line.empty()) continue;
        unsigned __int128 v = 0;
        for (char c : line) {
            int d = (c <= '9') ? c - '0' : c - 'a' + 10;
            v = (v << 4) | d;
        }
        Vec x;
        x.lo = (uint64_t)v;
        x.hi = (uint64_t)(v >> 64);
        out.push_back(x);
    }
    return out;
}

int main() {
    auto Z = load("formalization/canonical-width/c16/pools/zcoords.txt");
    auto X = load("formalization/canonical-width/c16/pools/xcoords.txt");
    const int nz = (int)Z.size(), nx = (int)X.size();
    std::mt19937_64 rng(1);
    std::vector<int> zord(nz), xord(nx);
    std::iota(zord.begin(), zord.end(), 0);
    std::iota(xord.begin(), xord.end(), 0);
    int best = 0;
    long trials = 0;
    auto t0 = std::chrono::steady_clock::now();
    std::vector<int> bestz, bestx;
    while (true) {
        auto now = std::chrono::steady_clock::now();
        double sec = std::chrono::duration<double>(now - t0).count();
        if (sec > 90) break;
        std::shuffle(zord.begin(), zord.end(), rng);
        std::shuffle(xord.begin(), xord.end(), rng);
        std::vector<int> cz, cx;
        cz.reserve(128);
        cx.reserve(128);
        std::vector<char> uz(nz), ux(nx);
        for (int zi : zord) {
            bool ok = true;
            for (int j : cx) if (dot(Z[zi], X[j])) { ok = false; break; }
            if (!ok) continue;
            for (int xi : xord) {
                if (ux[xi]) continue;
                if (!dot(Z[zi], X[xi])) continue;
                bool orth = true;
                for (int i : cz) if (dot(Z[i], X[xi])) { orth = false; break; }
                if (!orth) continue;
                cz.push_back(zi);
                cx.push_back(xi);
                uz[zi] = ux[xi] = 1;
                break;
            }
            if ((int)cz.size() == 128) break;
        }
        ++trials;
        int depth = (int)cz.size();
        if (depth > best) {
            best = depth;
            bestz = cz;
            bestx = cx;
            std::cout << "best " << best << " trials " << trials << " t " << sec << "\n" << std::flush;
            if (best == 128) break;
        }
    }
    auto now = std::chrono::steady_clock::now();
    double sec = std::chrono::duration<double>(now - t0).count();
    std::cout << "done trials " << trials << " best " << best << " sec " << sec << "\n";
    return 0;
}
