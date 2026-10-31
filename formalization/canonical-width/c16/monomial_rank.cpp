// Exact maximum of rank(X pool orthogonal to all 16 dual partners of the
// seed-4 monomials), over the 3^16 partner-type assignments.
// A CSS frame containing every seed-4 X monomial needs this rank to be at
// least 112. The kernel of 16 independent partners has dimension 112.
#include <bits/stdc++.h>
using namespace std;
using U = unsigned __int128;
static int dot(U a, U b) {
    return (__builtin_popcountll((uint64_t)a & (uint64_t)b) +
            __builtin_popcountll((uint64_t)(a >> 64) & (uint64_t)(b >> 64))) &
           1;
}
static uint32_t blockB(U v) { return (uint32_t)((v >> 64) & 0xffffffffu); }
static U rot(U v, int h) {
    U o = 0;
    for (int s = 0; s < 8; s++) {
        uint32_t b = (uint32_t)((v >> (16 * s)) & 0xffffu);
        if (h) b = ((b << h) | (b >> (16 - h))) & 0xffffu;
        o |= (U)b << (16 * s);
    }
    return o;
}
static vector<U> load(const string& p) {
    ifstream in(p);
    vector<U> v;
    string s;
    while (in >> s) {
        U x = 0;
        for (char c : s) {
            x <<= 4;
            x += (c <= '9' ? c - '0' : c - 'a' + 10);
        }
        v.push_back(x);
    }
    return v;
}
static int lead(U v) {
    if (v >> 64) return 127 - __builtin_clzll((uint64_t)(v >> 64));
    return 63 - __builtin_clzll((uint64_t)v);
}
static int rank_of(const vector<U>& rows) {
    vector<U> piv;
    for (U v : rows) {
        for (U row : piv) {
            int p = lead(row);
            if ((v >> p) & 1) v ^= row;
        }
        if (!v) continue;
        int p = lead(v);
        for (U& row : piv)
            if ((row >> p) & 1) row ^= v;
        piv.push_back(v);
    }
    return (int)piv.size();
}
int main() {
    auto X = load("formalization/canonical-width/c16/pools/xcoords.txt");
    auto Z = load("formalization/canonical-width/c16/pools/zcoords.txt");
    U xs4 = 0;
    for (U a : X)
        if (blockB(a) == 1) xs4 = a;
    vector<U> zp;
    for (U b : Z)
        if ((blockB(b) & 0xffffu) == 1 && dot(xs4, b)) zp.push_back(b);
    if (zp.size() != 3) {
        cerr << "expected 3 protos, got " << zp.size() << "\n";
        return 1;
    }
    int n = X.size();
    // allowed[x][p] bitmask of types that commute
    vector<array<uint8_t, 16>> allowed(n);
    for (int i = 0; i < n; i++) {
        for (int p = 0; p < 16; p++) {
            uint8_t m = 0;
            for (int t = 0; t < 3; t++)
                if (!dot(X[i], rot(zp[t], p))) m |= (uint8_t)(1 << t);
            allowed[i][p] = m;
        }
    }
    // Gray-ish: recursive odometer, one coordinate changes.
    vector<int> tz(16, 0);
    vector<int> rej(n, 0);
    for (int i = 0; i < n; i++)
        for (int p = 0; p < 16; p++)
            if ((allowed[i][p] & 1) == 0) rej[i]++;
    auto active_rows = [&]() {
        vector<U> rows;
        for (int i = 0; i < n; i++)
            if (rej[i] == 0) rows.push_back(X[i]);
        return rows;
    };
    int maxRank = rank_of(active_rows());
    int maxCount = 0;
    for (int i = 0; i < n; i++)
        if (rej[i] == 0) maxCount++;
    uint64_t seen = 1, ranked = 1;
    // Odometer from the all-zero assignment. Each step rolls the lowest coordinates.
    while (true) {
        int p = 0;
        while (p < 16 && tz[p] == 2) {
            // roll to 0
            for (int i = 0; i < n; i++) {
                bool was = allowed[i][p] & (1 << 2);
                bool now = allowed[i][p] & 1;
                if (was && !now) rej[i]++;
                if (!was && now) rej[i]--;
            }
            tz[p] = 0;
            p++;
        }
        if (p == 16) break;
        int nw = tz[p] + 1;
        for (int i = 0; i < n; i++) {
            bool was = allowed[i][p] & (1 << tz[p]);
            bool now = allowed[i][p] & (1 << nw);
            if (was && !now) rej[i]++;
            if (!was && now) rej[i]--;
        }
        tz[p] = nw;
        seen++;
        int cnt = 0;
        for (int i = 0; i < n; i++)
            if (rej[i] == 0) cnt++;
        if (cnt > maxCount) maxCount = cnt;
        if (cnt >= 112) {
            int r = rank_of(active_rows());
            ranked++;
            if (r > maxRank) {
                maxRank = r;
                cerr << "new max rank " << maxRank << " count " << cnt << " seen " << seen << "\n";
            }
        }
        if ((seen & 0x3ffff) == 0) cerr << "seen " << seen << " maxRank " << maxRank << " maxCount " << maxCount << " ranked " << ranked << "\n";
    }
    cout << "seen " << seen << " maxRank " << maxRank << " maxCount " << maxCount << " ranked " << ranked << "\n";
    cout << (maxRank < 112 ? "MONOMIAL_CASE_IMPOSSIBLE" : "MONOMIAL_CASE_OPEN") << "\n";
}
