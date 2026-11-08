// Exact anchored outer-product span; continuation of full_identity_span.cpp.
// A full original frame at anchor a/b requires I - x_a z_b^T in this span.
// Span membership alone is not a compatible matching or a completed case.
#define main old_linear_cover_main
#include "prune_linear_cover.cpp"
#undef main
#include <algorithm>
#include <sys/resource.h>
int main(int argc,char**argv){
 if(argc!=6)return 2;auto start=std::chrono::steady_clock::now();auto X=load(argv[1]),Z=load(argv[2]);int a=std::stoi(argv[3]),b=std::stoi(argv[4]);if(X.size()!=720||Z.size()!=720||!parity(X[a]&Z[b]))return 3;
 Elim E;std::vector<Vec> labels(16384);std::vector<std::pair<int,int>> originals;long long edges=0;std::vector<int> chain;
 auto reduce=[&](Vec v){chain.clear();for(int w=255;w>=0;--w)while(v[w]){int p=w*64+63-__builtin_clzll(v[w]);if(!E.used[p])return v;chain.push_back(p);for(int k=0;k<=w;k++)v[k]^=E.basis[p][k];}return v;};
 for(int i=0;i<720;i++)if(i!=a&&!parity(X[i]&Z[b]))for(int j=0;j<720;j++)if(j!=b&&!parity(X[a]&Z[j])&&parity(X[i]&Z[j])){
  ++edges;Vec rem=reduce(atom(X[i],Z[j]));if(!zero(rem)){int p=-1;for(int w=255;w>=0;--w)if(rem[w]){p=64*w+63-__builtin_clzll(rem[w]);break;}Vec l{};l[E.rank/64]|=uint64_t(1)<<(E.rank%64);for(int q:chain)for(int k=0;k<256;++k)l[k]^=labels[q][k];E.used[p]=true;E.basis[p]=rem;labels[p]=l;originals.push_back({i,j});E.rank++;}
 }
 Vec target=atom(X[a],Z[b]);for(int i=0;i<128;i++)target[(129*i)/64]^=uint64_t(1)<<(129*i%64);Vec rem=reduce(target);bool inside=zero(rem);Vec coeff{};std::vector<std::pair<int,int>> terms;Vec L{};
 if(inside){for(int q:chain)for(int k=0;k<256;k++)coeff[k]^=labels[q][k];for(int i=0;i<E.rank;i++)if(coeff[i/64]>>(i%64)&1)terms.push_back(originals[i]);}
 else{int free=-1;for(int w=255;w>=0;--w)if(rem[w]){free=w*64+63-__builtin_clzll(rem[w]);break;}L[free/64]|=uint64_t(1)<<(free%64);for(int p=0;p<16384;p++)if(E.used[p]){int value=0;for(int k=0;k<=p/64;k++)value^=__builtin_parityll(E.basis[p][k]&L[k]);if(value)L[p/64]^=uint64_t(1)<<(p%64);}}
 struct rusage ru;getrusage(RUSAGE_SELF,&ru);double elapsed=std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count();std::ofstream out(argv[5]);out<<"{\n\"status\":\"DISCOVERY_REQUIRES_PHYSICAL_REPLAY\",\"anchor\":["<<a<<","<<b<<"],\"free_edges\":"<<edges<<",\"atom_span_rank\":"<<E.rank<<",\"target_in_span\":"<<(inside?"true":"false")<<",\"span_combination\":[";for(size_t k=0;k<terms.size();k++){if(k)out<<",";out<<"["<<terms[k].first<<","<<terms[k].second<<"]";}out<<"],\"separator_rows_hex\":[";if(!inside)for(int i=0;i<128;i++){if(i)out<<",";out<<"\""<<hex128(U128(L[2*i])|(U128(L[2*i+1])<<64))<<"\"";}out<<"],\"elapsed_seconds\":"<<elapsed<<",\"peak_rss_platform_units\":"<<ru.ru_maxrss<<",\"scope\":\"Positive span combination need not be a matching. Negative membership requires physical separator replay before a full anchored obstruction.\"}\n";
 std::cout<<"ANCHOR "<<a<<" "<<b<<" edges "<<edges<<" span rank "<<E.rank<<" target_in_span "<<inside<<" combination "<<terms.size()<<" seconds "<<elapsed<<std::endl;
}
