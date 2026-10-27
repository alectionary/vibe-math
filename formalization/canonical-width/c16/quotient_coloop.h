// Propagate mandatory basis members (matroid coloops) before branching.
// If a pool vector is not in the span of the other surviving vectors, every
// completing basis must use it. A vector pairing with two mandatory members
// on the opposite side is unusable. Two mandatory anticommuting members must
// be paired with each other.
struct ColoopQuotient:PreparedQuotient {
    using PreparedQuotient::PreparedQuotient;
    struct RankInfo{int rank=0;Bits mandatory;};
    static RankInfo info(const std::vector<U>& values,const Bits& active){
        U piv[128]{},tag[128]{},used=0;int ids[128]{};RankInfo out;
        active.each([&](int i){
            U v=values[i],comb=0;
            while(v){int p=ctz128(v);if(!piv[p])break;v^=piv[p];comb^=tag[p];}
            if(!v){used|=comb;return;}
            int p=ctz128(v),label=out.rank++;ids[label]=i;
            piv[p]=v;tag[p]=comb^(U(1)<<label);
        });
        for(int k=0;k<out.rank;++k)if(!((used>>k)&1))out.mandatory.set(ids[k]);
        return out;
    }
    bool complete(Bits initialX,Bits initialZ,int need,uint64_t cap,uint64_t& nodes,bool& capped,
                  std::vector<std::pair<int,int>>* out){
        capped=false;bool found=false;std::vector<std::pair<int,int>> chosen;chosen.reserve(need);
        int wx=(X.size()+63)/64,wz=(Z.size()+63)/64;
        auto overlap=[](const Bits&a,const Bits&b,int words){int n=0;for(int w=0;w<words;++w)n+=pop2(a.w[w]&b.w[w]);return n;};
        std::function<void(Bits,Bits)> rec=[&](Bits a,Bits b){
            if(found || capped)return;if(nodes>=cap){capped=true;return;}++nodes;
            struct Reset{std::vector<std::pair<int,int>>&v;size_t n;~Reset(){v.resize(n);}} reset{chosen,chosen.size()};
            while(true){
                int left=need-chosen.size();
                if(!left){found=true;if(out)*out=chosen;return;}
                if(a.count()<left || b.count()<left)return;
                auto ix=info(X,a),iz=info(Z,b);
                if(ix.rank<left || iz.rank<left)return;
                if(ix.rank>left || iz.rank>left){std::cerr<<"initial target span contract violated\n";std::exit(1);}
                Bits aa=a,bb=b;
                a.each([&](int i){if(overlap(xa[i],iz.mandatory,wz)>1)aa.reset(i);});
                b.each([&](int j){if(overlap(za[j],ix.mandatory,wx)>1)bb.reset(j);});
                bool changed=aa.count()!=a.count() || bb.count()!=b.count();a=aa;b=bb;
                if(changed)continue;
                std::vector<std::pair<int,int>> forced;
                ix.mandatory.each([&](int i){
                    Bits mates=xa[i];mates.keep(iz.mandatory);
                    mates.each([&](int j){forced.push_back({i,j});});
                });
                if(!forced.empty()){
                    for(auto[i,j]:forced){chosen.push_back({i,j});a.reset(i);b.reset(j);a.exclude(za[j]);b.exclude(xa[i]);}
                    continue;
                }
                break;
            }
            int best=100000;bool side=false;Bits candidates;
            auto consider=[&](const Bits&owners,const Bits&avail,int words,bool zs){
                int n=overlap(owners,avail,words);
                if(n && n<best){best=n;side=zs;candidates=owners;candidates.keep(avail);}
            };
            for(int q=0;q<128 && best>1;++q){consider(xo[q],a,wx,false);consider(zo[q],b,wz,true);}
            if(best>1)initialZ.each([&](int j){if(best>1)consider(za[j],a,wx,false);});
            if(best>1)initialX.each([&](int i){if(best>1)consider(xa[i],b,wz,true);});
            if(best==100000)return;
            candidates.each([&](int v){
                if(found || capped)return;Bits partners=side?za[v]:xa[v];partners.keep(side?a:b);
                partners.each([&](int w){
                    if(found || capped)return;int i=side?w:v,j=side?v:w;Bits aa=a,bb=b;
                    aa.reset(i);bb.reset(j);aa.exclude(za[j]);bb.exclude(xa[i]);
                    chosen.push_back({i,j});rec(aa,bb);chosen.pop_back();
                });
                if(side)b.reset(v);else a.reset(v);
            });
        };
        rec(initialX,initialZ);return found;
    }
};
