// Exact quotient search with disjoint branches and a choice of either side.
// Requires the U, Bits, GE and dot definitions in seed4_fifteen.cpp.
// Unlike the historical routine, a candidate is deleted after all its partner
// branches have been exhausted: later branches cover only completions avoiding
// that candidate. This partitions completions rather than repeating them.
static bool fast_complete(const std::vector<U>& X, const std::vector<U>& Z, int need,
                          uint64_t cap, uint64_t& nodes, bool& capped,
                          std::vector<std::pair<int,int>>* out, bool extra_functionals=true) {
    int nx=X.size(),nz=Z.size();
    if(nx>1024 || nz>1024 || need>128)std::exit(1);
    int wx=(nx+63)/64,wz=(nz+63)/64;
    std::vector<Bits> xa(nx),za(nz),xo(128),zo(128);
    for(int i=0;i<nx;++i){
        for(int j=0;j<nz;++j)if(dot(X[i],Z[j])){xa[i].set(j);za[j].set(i);}
        for(int b=0;b<128;++b)if((X[i]>>b)&1)xo[b].set(i);
    }
    for(int j=0;j<nz;++j)for(int b=0;b<128;++b)if((Z[j]>>b)&1)zo[b].set(j);
    auto overlap=[](const Bits& a,const Bits& b,int words){
        int n=0;for(int w=0;w<words;++w)n+=pop2(a.w[w]&b.w[w]);return n;
    };
    Bits ax,az;ax.fill(nx);az.fill(nz);capped=false;
    bool found=false;std::vector<std::pair<int,int>> chosen;
    std::function<void(GE,GE,Bits,Bits)> rec=[&](GE gx,GE gz,Bits a,Bits b){
        if(found || capped)return;
        if(nodes>=cap){capped=true;return;}
        ++nodes;int left=need-chosen.size();
        if(!left){found=true;if(out)*out=chosen;return;}
        if(a.count()<left || b.count()<left)return;
        if(extend_rank(X.data(),a,gx,left)<left || extend_rank(Z.data(),b,gz,left)<left)return;
        int best=100000;bool side=false;Bits candidates;
        auto consider=[&](const Bits& owners,const Bits& available,int words,bool zside){
            int count=overlap(owners,available,words);
            if(count && count<best){best=count;side=zside;candidates=owners;candidates.keep(available);}
        };
        for(int q=0;q<128 && best>1;++q){consider(xo[q],a,wx,false);consider(zo[q],b,wz,true);}
        // Any linear functional nonzero on the remaining span must be carried
        // by some member of a completion. Pairing with an initial pool vector
        // is such a functional, whether or not that vector is itself selected.
        if(extra_functionals && best>1){
            for(int j=0;j<nz && best>1;++j)consider(za[j],a,wx,false);
            for(int i=0;i<nx && best>1;++i)consider(xa[i],b,wz,true);
        }
        if(best==100000)return;
        candidates.each([&](int v){
            if(found || capped)return;
            Bits partners=side?za[v]:xa[v];partners.keep(side?a:b);
            partners.each([&](int w){
                if(found || capped)return;
                int i=side?w:v,j=side?v:w;
                Bits aa=a,bb=b;aa.reset(i);bb.reset(j);aa.exclude(za[j]);bb.exclude(xa[i]);
                if(aa.count()<left-1 || bb.count()<left-1)return;
                GE xx=gx,zz=gz;
                if(!xx.insert(X[i]) || !zz.insert(Z[j]))return;
                chosen.push_back({i,j});rec(xx,zz,aa,bb);chosen.pop_back();
            });
            // Every completion containing v was covered above. Later choices
            // may therefore exclude it without losing any unsearched frame.
            if(side)b.reset(v);else a.reset(v);
        });
    };
    rec(GE{},GE{},ax,az);return found;
}
