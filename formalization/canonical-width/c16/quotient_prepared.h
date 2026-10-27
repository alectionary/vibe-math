// The same partitioned search, with pairing/coordinate bitsets prepared once
// for the whole pool instead of rebuilt for every partner assignment.
struct PreparedQuotient {
    const std::vector<U>& X;const std::vector<U>& Z;
    std::vector<Bits> xa,za,xo,zo;
    PreparedQuotient(const std::vector<U>& x,const std::vector<U>& z):X(x),Z(z),xa(x.size()),za(z.size()),xo(128),zo(128){
        if(x.size()>1024 || z.size()>1024)std::exit(1);
        for(int i=0;i<(int)X.size();++i){
            for(int j=0;j<(int)Z.size();++j)if(dot(X[i],Z[j])){xa[i].set(j);za[j].set(i);}
            for(int b=0;b<128;++b)if((X[i]>>b)&1)xo[b].set(i);
        }
        for(int j=0;j<(int)Z.size();++j)for(int b=0;b<128;++b)if((Z[j]>>b)&1)zo[b].set(j);
    }
    bool complete(Bits initialX,Bits initialZ,int need,uint64_t cap,uint64_t& nodes,bool& capped,
                  std::vector<std::pair<int,int>>* out){
        int wx=(X.size()+63)/64,wz=(Z.size()+63)/64;
        auto overlap=[](const Bits&a,const Bits&b,int words){int n=0;for(int w=0;w<words;++w)n+=pop2(a.w[w]&b.w[w]);return n;};
        capped=false;bool found=false;std::vector<std::pair<int,int>> chosen;chosen.reserve(need);
        std::function<void(GE,GE,Bits,Bits)> rec=[&](GE gx,GE gz,Bits a,Bits b){
            if(found || capped)return;
            if(nodes>=cap){capped=true;return;}++nodes;
            int left=need-chosen.size();
            if(!left){found=true;if(out)*out=chosen;return;}
            if(a.count()<left || b.count()<left)return;
            if(extend_rank(X.data(),a,gx,left)<left || extend_rank(Z.data(),b,gz,left)<left)return;
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
                if(found || capped)return;
                Bits partners=side?za[v]:xa[v];partners.keep(side?a:b);
                partners.each([&](int w){
                    if(found || capped)return;
                    int i=side?w:v,j=side?v:w;Bits aa=a,bb=b;
                    aa.reset(i);bb.reset(j);aa.exclude(za[j]);bb.exclude(xa[i]);
                    if(aa.count()<left-1 || bb.count()<left-1)return;
                    GE xx=gx,zz=gz;if(!xx.insert(X[i]) || !zz.insert(Z[j]))return;
                    chosen.push_back({i,j});rec(xx,zz,aa,bb);chosen.pop_back();
                });
                if(side)b.reset(v);else a.reset(v);
            });
        };
        rec(GE{},GE{},initialX,initialZ);return found;
    }
};
