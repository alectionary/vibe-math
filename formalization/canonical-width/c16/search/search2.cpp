#include <bits/stdc++.h>
using namespace std;
using U = unsigned __int128;
static inline int dot(U a,U b){
    return (__builtin_popcountll((uint64_t)a&(uint64_t)b)+__builtin_popcountll((uint64_t)(a>>64)&(uint64_t)(b>>64)))&1;
}
static vector<U> load(const string& p){
    ifstream in(p); vector<U> v; string s;
    while(in>>s){ U x=0; for(char c:s){ x<<=4; x+= (c<='9'?c-'0':c-'a'+10); } v.push_back(x);} return v;
}
struct BS{
    uint64_t w[12]{};
    void set(int i){ w[i>>6]|=1ull<<(i&63);} 
    int count() const { int c=0; for(int i=0;i<12;i++) c+=__builtin_popcountll(w[i]); return c; }
    BS operator&(const BS& o) const { BS r; for(int i=0;i<12;i++) r.w[i]=w[i]&o.w[i]; return r; }
    template<class F> void each(F f) const {
        for(int k=0;k<12;k++){ uint64_t m=w[k]; while(m){ int b=__builtin_ctzll(m); f((k<<6)+b); m&=m-1; } }
    }
};
int main(int argc, char** argv){
    int rep0=argc>1?atoi(argv[1]):0, rep1=argc>2?atoi(argv[2]):45;
    double limit=argc>3?atof(argv[3]):600;
    auto X=load("formalization/canonical-width/c16/pools/xcoords.txt"), Z=load("formalization/canonical-width/c16/pools/zcoords.txt");
    int n=X.size();
    vector<BS> xp(n), zp(n); // xp[i] = z's with dot 1; zp[j]= x's with dot 1
    vector<BS> xz0(n), zx0(n);
    for(int i=0;i<n;i++) for(int j=0;j<n;j++){
        if(dot(X[i],Z[j])){ xp[i].set(j); zp[j].set(i);} else { xz0[j].set(i); zx0[i].set(j); }
    }
    auto rot=[&](U v,int h){ U o=0; for(int s=0;s<8;s++){ uint32_t b=(v>>(16*s))&0xFFFF; if(h) b=((b<<h)|(b>>(16-h)))&0xFFFF; o|=(U)b<<(16*s);} return o; };
    map<pair<uint64_t,uint64_t>,int> idx;
    auto key=[&](U v){ return pair<uint64_t,uint64_t>((uint64_t)v,(uint64_t)(v>>64)); };
    for(int i=0;i<n;i++) idx[key(Z[i])]=i;
    vector<int> reps; vector<char> seen(n);
    for(int i=0;i<n;i++) if(!seen[i]){
        int best=i; U bv=Z[i];
        for(int h=0;h<16;h++){ U r=rot(Z[i],h); int id=idx[key(r)]; seen[id]=1; if(r<bv){bv=r;best=id;} }
        reps.push_back(best);
    }
    fprintf(stderr,"reps %zu n %d range %d %d\n", reps.size(), n, rep0, rep1);
    vector<int> zz,xz;
    BS zalive,xalive; for(int i=0;i<n;i++){ zalive.set(i); xalive.set(i); }
    uint64_t nodes=0; int best=0; auto t0=chrono::steady_clock::now();
    auto elapsed=[&](){ return chrono::duration<double>(chrono::steady_clock::now()-t0).count(); };
    function<void()> rec=[&](){
        if(++nodes, false){}
        nodes++;
        int r=zz.size();
        if(r>best){ best=r; fprintf(stderr,"best %d nodes %llu t %.2f z %d x %d\n", best,(unsigned long long)nodes,elapsed(),zalive.count(),xalive.count()); }
        if(r==128){ fprintf(stderr,"FOUND\n"); exit(0); }
        if(elapsed()>limit){ fprintf(stderr,"TIMEOUT best %d nodes %llu\n",best,(unsigned long long)nodes); exit(3); }
        int need=128-r;
        if(zalive.count()<need || xalive.count()<need) return;
        int bestj=-1, bestc=1e9;
        zalive.each([&](int j){
            int c=(xalive & zp[j]).count();
            if(c && c<bestc){ bestc=c; bestj=j; }
        });
        if(bestj<0) return;
        BS partners=xalive & zp[bestj];
        // copy alive
        BS oz=zalive, ox=xalive;
        partners.each([&](int i){
            zalive=oz; xalive=ox;
            // remove chosen and apply orthogonality
            // intersect
            BS nz=oz, nx=ox;
            // clear chosen bits: intersect with complement is harder; just rely on later dot? must remove.
            // We'll AND with precomputed orth bitsets which include dot 0, so chosen z (dot 1 with chosen x) is already excluded from zx0.
            nz.w[0]&=zx0[i].w[0]; // do all
            for(int k=0;k<12;k++){ nz.w[k]=oz.w[k]&zx0[i].w[k]; nx.w[k]=ox.w[k]&xz0[bestj].w[k]; }
            zalive=nz; xalive=nx;
            zz.push_back(bestj); xz.push_back(i);
            rec();
            zz.pop_back(); xz.pop_back();
        });
        zalive=oz; xalive=ox;
    };
    for(int ri=rep0; ri<rep1 && ri<(int)reps.size(); ri++){
        int rep=reps[ri];
        BS ox=xalive, oz=zalive;
        BS part=xalive & zp[rep];
        int cnt=0;
        part.each([&](int i){
            for(int k=0;k<12;k++){ zalive.w[k]=oz.w[k]&zx0[i].w[k]; xalive.w[k]=ox.w[k]&xz0[rep].w[k]; }
            zz.push_back(rep); xz.push_back(i); rec(); zz.pop_back(); xz.pop_back();
            cnt++;
        });
        fprintf(stderr,"rep %d/%d partners %d best %d nodes %llu t %.1f\n", ri, (int)reps.size(), cnt, best,(unsigned long long)nodes, elapsed());
        zalive=oz; xalive=ox;
    }
    fprintf(stderr,"DONE best %d nodes %llu t %.1f\n", best,(unsigned long long)nodes, elapsed());
}
