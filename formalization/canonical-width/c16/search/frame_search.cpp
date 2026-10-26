#include <bits/stdc++.h>
using namespace std;
using U = unsigned __int128;
static inline int dot(U a, U b){ return __builtin_popcountll((uint64_t)a & (uint64_t)b) + __builtin_popcountll((uint64_t)(a>>64) & (uint64_t)(b>>64)) & 1; }
static vector<U> load(const string& p){
    ifstream in(p); vector<U> v; string s;
    while(in>>s){ U x=0; for(char c: s){ x<<=4; if(c>='0'&&c<='9') x+=c-'0'; else x+=c-'a'+10; } v.push_back(x); }
    return v;
}
// bitset 720
struct BS{
    uint64_t w[12]{};
    void set(int i){ w[i>>6] |= 1ull<<(i&63); }
    void reset(int i){ w[i>>6] &= ~(1ull<<(i&63)); }
    int test(int i) const { return (w[i>>6]>>(i&63))&1; }
    BS& operator&=(const BS& o){ for(int i=0;i<12;i++) w[i]&=o.w[i]; return *this; }
    int count() const { int c=0; for(int i=0;i<12;i++) c+=__builtin_popcountll(w[i]); return c; }
    int next(int i) const {
        if(i<0) i=0;
        int b=i>>6, o=i&63;
        for(int k=b;k<12;k++){
            uint64_t m=w[k]; if(k==b) m &= ~0ull<<o;
            if(m) return (k<<6)+__builtin_ctzll(m);
        }
        return -1;
    }
};
int main(){
    auto X=load("formalization/canonical-width/c16/pools/xcoords.txt");
    auto Z=load("formalization/canonical-width/c16/pools/zcoords.txt");
    const int n=X.size();
    fprintf(stderr,"n %d\n",n);
    // dot Z with X: for each x, BS of z with dot 0 and dot 1
    vector<BS> zx0(n), zx1(n);
    for(int i=0;i<n;i++) for(int j=0;j<n;j++){
        if(dot(X[i],Z[j])) zx1[i].set(j); else zx0[i].set(j);
    }
    // symmetry: first z is orbit min. translation rotates each 16-bit block
    auto rot=[&](U v, int h){
        U o=0;
        for(int s=0;s<8;s++){
            uint32_t b=(v>>(16*s))&0xFFFF;
            if(h) b=((b<<h)|(b>>(16-h)))&0xFFFF;
            o|=(U)b<<(16*s);
        }
        return o;
    };
    unordered_map<U,int> zindex; for(int i=0;i<n;i++) zindex[Z[i]]=i;
    vector<int> reps;
    vector<char> seen(n);
    for(int i=0;i<n;i++) if(!seen[i]){
        int best=i; U bv=Z[i];
        for(int h=0;h<16;h++){
            U r=rot(Z[i],h); int id=zindex[r]; seen[id]=1; if(r<bv){bv=r; best=id;}
        }
        reps.push_back(best);
    }
    fprintf(stderr,"reps %zu\n", reps.size());
    // search
    vector<int> xz, zz;
    BS zalive, xalive; for(int i=0;i<n;i++){ zalive.set(i); xalive.set(i); }
    // also track span via gaussian on selected, but independence checked by dot against maintained dual basis of selected.
    // We'll store selected and require Gram updates.
    // x_orth constraints: z must be in intersection of zx0[x] for selected x
    // z_orth: x in intersection of xz0. Build xz0 similarly: for each z, x with dot 0.
    vector<BS> xz0(n);
    for(int j=0;j<n;j++) for(int i=0;i<n;i++) if(!dot(X[i],Z[j])) xz0[j].set(i);
    uint64_t nodes=0, leaves=0;
    int best=0;
    auto start=chrono::steady_clock::now();
    function<void()> rec = [&](){
        nodes++;
        int r=zz.size();
        if(r>best){ best=r; auto t=chrono::duration<double>(chrono::steady_clock::now()-start).count();
            fprintf(stderr,"best %d nodes %llu t %.2f zcand %d xcand %d\n", best,(unsigned long long)nodes,t,zalive.count(),xalive.count()); }
        if(r==128){ leaves++; fprintf(stderr,"FOUND\n"); 
            ofstream out("/tmp/lf91/frame128.txt");
            for(int i: xz){ U x=X[i]; for(int b=31;b>=0;b--){ int d=(x>>(4*b))&15; out<<char(d<10?'0'+d:'a'+d-10);} out<<"\n"; }
            exit(0);
        }
        if((nodes&0x3ffff)==0){
            auto t=chrono::duration<double>(chrono::steady_clock::now()-start).count();
            if(t>1200){ fprintf(stderr,"TIMEOUT best %d nodes %llu\n",best,(unsigned long long)nodes); exit(2);} }
        // MRV: pick z in zalive with fewest x in xalive having dot 1, among those with at least 1, and z independent.
        // Independence: z not in span of selected Z. Maintain Z basis reducer.
        int bestz=-1, bestc=1e9;
        for(int j=zalive.next(0); j>=0; j=zalive.next(j+1)){
            // count partners
            int c=0;
            // iterate xalive and test dot — slow if both large. Use zx1[?] we have zx1 indexed by x.
            // Count x in xalive with dot(X,Z[j])=1. Precompute? loop xalive.
            for(int i=xalive.next(0); i>=0; i=xalive.next(i+1)) if(dot(X[i],Z[j])){ c++; if(c>=bestc) break; }
            if(c==0) continue;
            if(c<bestc){ bestc=c; bestz=j; if(c==1) break; }
        }
        if(bestz<0) return;
        // collect partners
        vector<int> xs;
        for(int i=xalive.next(0); i>=0; i=xalive.next(i+1)) if(dot(X[i],Z[bestz])) xs.push_back(i);
        for(int i: xs){
            // choose pair (i, bestz)
            BS oldz=zalive, oldx=xalive;
            zalive.reset(bestz); xalive.reset(i);
            zalive &= zx0[i];
            xalive &= xz0[bestz];
            // remove any z that dots selected? already zx0. Also remove z equal bestz done.
            zz.push_back(bestz); xz.push_back(i);
            // linear independence: a vector in the orthogonal of previous dual and pairing 1 with new is automatically outside the span
            // of previous, because previous are orthogonal to the new opposite vector while this one dots to 1.
            // For the SET of Z's: new z dots to 1 with new x, while old z's dot to 0 with new x, so new z not in span of old z. Good.
            rec();
            zz.pop_back(); xz.pop_back();
            zalive=oldz; xalive=oldx;
        }
    };
    // To use reps, we still branch all first z but only reps, and all compatible x.
    // Modify: top level only.
    auto t0=chrono::steady_clock::now();
    for(int rep: reps){
        for(int i=0;i<n;i++) if(dot(X[i],Z[rep])){
            BS oldz=zalive, oldx=xalive;
            zalive.reset(rep); xalive.reset(i);
            zalive &= zx0[i]; xalive &= xz0[rep];
            zz.push_back(rep); xz.push_back(i);
            rec();
            zz.pop_back(); xz.pop_back();
            zalive=oldz; xalive=oldx;
        }
        auto t=chrono::duration<double>(chrono::steady_clock::now()-t0).count();
        fprintf(stderr,"finished rep %d t %.1f best %d nodes %llu\n", rep,t,best,(unsigned long long)nodes);
    }
    fprintf(stderr,"DONE best %d nodes %llu\n", best,(unsigned long long)nodes);
}
