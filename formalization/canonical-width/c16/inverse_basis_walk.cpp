// Basis-exchange construction with exact inverse updates and a short-word metric.
// The optional three-thin-family restriction is justified for the source128 case
// by the separately checked block obstruction. A failed walk proves nothing.
#define main inherited_climb_main
#include "search/climb_steep.cpp"
#undef main
#include <unordered_map>
struct Walk {
 std::vector<U>X,Z,dual,coord;std::vector<int>basis,labels,count,tabu;std::unordered_map<U,int,UHash>zindex;std::unordered_set<U,UHash>pairball;std::mt19937_64 rng;int n,minfamilies;bool secondary;long step=0;uint64_t moves=0;int good=0,near=0;
 Walk(std::vector<U>x,std::vector<U>z,std::vector<int>b,std::vector<int>lab,uint64_t seed,bool sec,int thin):X(x),Z(z),basis(b),labels(lab),rng(seed),minfamilies(thin),secondary(sec){n=b.size();tabu.assign(X.size(),0);count.assign(32,0);for(int i=0;i<(int)Z.size();++i)zindex[Z[i]]=i;pairball.insert(0);for(U z:Z)pairball.insert(z);for(int i=0;i<(int)Z.size();++i)for(int j=0;j<i;++j)pairball.insert(Z[i]^Z[j]);rebuild();}
 int metric(U v)const{if(zindex.count(v))return 1024;return secondary&&pairball.count(v)?1:0;}
 int active()const{int a=0;for(int v:count)a+=v>0;return a;}
 void rebuild(){std::vector<U>cols;std::fill(count.begin(),count.end(),0);for(int i:basis){cols.push_back(X[i]);++count[labels[i]];}if(!invert(cols,dual))std::exit(7);coord.assign(X.size(),0);for(int k=0;k<(int)X.size();++k)for(int j=0;j<n;++j)if(dot(X[k],dual[j]))coord[k]|=(U)1<<j;good=near=0;for(U z:dual){good+=zindex.count(z);near+=!zindex.count(z)&&pairball.count(z);}check();}
 void check()const{for(int i=0;i<n;++i)for(int j=0;j<n;++j)if(dot(X[basis[i]],dual[j])!=(i==j))std::exit(8);for(int k=0;k<(int)X.size();++k)for(int i=0;i<n;++i)if(bool(coord[k]&((U)1<<i))!=bool(dot(X[k],dual[i])))std::exit(9);}
 int score()const{return 1024*good+(secondary?near:0);}
 void exchange(int i,int k){U a=coord[k],pivot=dual[i];if(!(a&((U)1<<i)))std::exit(10);for(int j=0;j<n;++j)if(j!=i&&(a&((U)1<<j)))dual[j]^=pivot;U delta=a^((U)1<<i);for(U&c:coord)if(c&((U)1<<i))c^=delta;int old=basis[i];--count[labels[old]];++count[labels[k]];basis[i]=k;tabu[old]=step+23+(rng()%17);good=near=0;for(U z:dual){good+=zindex.count(z);near+=!zindex.count(z)&&pairball.count(z);}if(n<=16||step%257==0)check();}
 std::pair<int,int> choose(bool inject=false){std::vector<char>in(X.size());for(int k:basis)in[k]=1;int ai=-1,ak=-1,best=-100000000,act=active();long ties=0;std::array<int,6>dv{-1024,-1023,-1,1,1023,1024};
  for(int i=0;i<n;++i){std::array<U,6>masks{};for(int j=0;j<n;++j)if(j!=i){int d=metric(dual[j]^dual[i])-metric(dual[j]);for(int t=0;t<6;++t)if(d==dv[t])masks[t]|=(U)1<<j;}
   for(int k=0;k<(int)X.size();++k){if(in[k]||!(coord[k]&((U)1<<i)))continue;int next=act;if(labels[k]!=labels[basis[i]])next-=count[labels[basis[i]]]==1,next+=count[labels[k]]==0;if(next<minfamilies)continue;if(inject&&count[labels[k]]>0)continue;
    int delta=0;for(int t=0;t<6;++t){U v=coord[k]&masks[t];delta+=dv[t]*(pop2(uint64_t(v))+pop2(uint64_t(v>>64)));}++moves;if(tabu[k]>step&&delta<=0)continue;
    if(delta>best){best=delta;ai=i;ak=k;ties=1;}else if(delta==best&&rng()%++ties==0){ai=i;ak=k;}
   }
  }return {ai,ak};}
 void kick(int amount){for(int j=0;j<amount;++j){for(int trial=0;trial<500;++trial){int i=rng()%n,k=rng()%X.size();if(!(coord[k]&((U)1<<i)))continue;bool exists=false;for(int a:basis)if(a==k)exists=true;if(exists)continue;int next=active();if(labels[k]!=labels[basis[i]])next-=count[labels[basis[i]]]==1,next+=count[labels[k]]==0;if(next<minfamilies)continue;exchange(i,k);break;}}}
};
int main(int argc,char**argv){if(argc<10)return 1;auto X=load(argv[1]),Z=load(argv[2]);std::ifstream bi(argv[3]),li(argv[4]);std::vector<int>b,labels;int k;while(bi>>k)b.push_back(k);while(li>>k)labels.push_back(k);if(labels.size()!=X.size())return 2;double seconds=std::stod(argv[6]);uint64_t seed=std::stoull(argv[7]);bool secondary=std::stoi(argv[8]);int thin=std::stoi(argv[9]);long maxsteps=argc>10?std::stol(argv[10]):0;Walk w(X,Z,b,labels,seed,secondary,thin);auto start=std::chrono::steady_clock::now();auto elapsed=[&](){return std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count();};
 if(w.active()<thin){auto[i,k]=w.choose(true);if(i<0)return 3;w.exchange(i,k);}int best=-1,bestnear=-1;long last=0;std::vector<int>incumbent=w.basis;
 auto save=[&](){w.check();std::ofstream out(std::string(argv[5])+".json");out<<"{\"status\":\""<<(w.good==w.n?"FULL_POOL_FRAME_CHECKED":"PARTIAL_POOL_FRAME_CHECKED")<<"\",\"dimension\":"<<w.n<<",\"pairs\":"<<w.good<<",\"near_duals\":"<<w.near<<",\"steps\":"<<w.step<<",\"evaluated_exchanges\":"<<w.moves<<",\"seconds\":"<<elapsed()<<",\"seed\":"<<seed<<",\"secondary_word_metric\":"<<(secondary?"true":"false")<<",\"minimum_X_thin_families\":"<<thin<<",\"active_X_thin_families\":"<<w.active()<<",\"X_basis\":[";for(int i=0;i<w.n;++i)out<<(i?",":"")<<w.basis[i];out<<"],\"pool_pairs\":[";bool comma=false;for(int i=0;i<w.n;++i){auto it=w.zindex.find(w.dual[i]);if(it!=w.zindex.end()){if(comma)out<<",";comma=true;out<<"["<<w.basis[i]<<","<<it->second<<"]";}}out<<"]}\n";std::cout<<"BEST "<<w.good<<" near "<<w.near<<" step "<<w.step<<" active "<<w.active()<<" seconds "<<elapsed()<<std::endl;};
 while(elapsed()<seconds&&(!maxsteps||w.step<maxsteps)){if(w.good>best||(secondary&&w.good==best&&w.near>bestnear)){best=w.good;bestnear=w.near;incumbent=w.basis;last=w.step;save();}if(w.good==w.n)break;auto[i,k]=w.choose();if(i<0)w.kick(8);else w.exchange(i,k);++w.step;if(w.step-last>600){w.basis=incumbent;w.rebuild();w.kick(4+(w.rng()%13));last=w.step;}if(w.step%10000==0)std::cout<<"PROGRESS "<<w.step<<" best "<<best<<" current "<<w.good<<" seconds "<<elapsed()<<std::endl;}
 std::ofstream out(std::string(argv[5])+".summary.json");out<<"{\"status\":\"BOUNDED_CONSTRUCTION_ONLY\",\"best_pairs\":"<<best<<",\"best_near_duals\":"<<bestnear<<",\"steps\":"<<w.step<<",\"evaluated_exchanges\":"<<w.moves<<",\"seconds\":"<<elapsed()<<",\"seed\":"<<seed<<",\"source_C16_answered\":"<<(best==128?"true":"false")<<"}\n";std::cout<<"DONE best "<<best<<" steps "<<w.step<<" seconds "<<elapsed()<<"\n";
}
