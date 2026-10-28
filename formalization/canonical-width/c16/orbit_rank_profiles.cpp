// Complete one-orbit phase profiles for the existing opposite-basis rank test.
// Minimal bad masks have direct annihilator witnesses. Surviving masks are
// necessary-condition survivors only; no full original completion is asserted.
#define main old_linear_cover_main
#include "prune_linear_cover.cpp"
#undef main
#include <algorithm>
#include <array>
using BB=std::array<U128,128>;
int high(U128 x){return (x>>64)?64+63-__builtin_clzll(uint64_t(x>>64)):63-__builtin_clzll(uint64_t(x));}
U128 rem(U128 v,const BB&b){while(v){int p=high(v);if(!b[p])break;v^=b[p];}return v;}
bool insert(U128 v,BB&b){v=rem(v,b);if(!v)return false;b[high(v)]=v;return true;}
struct Bad {int mask;std::string kind;U128 w;int rank;};
int main(int argc,char**argv){
 if(argc<5){std::cerr<<"Xcoords Zcoords output seconds [first-orbit last-orbit]\n";return 2;}auto X=load(argv[1]),Z=load(argv[2]);if(X.size()!=720||Z.size()!=720)return 3;double budget=std::stod(argv[4]);int first=argc>5?std::stoi(argv[5]):0,last=argc>6?std::stoi(argv[6]):45;auto start=std::chrono::steady_clock::now();auto elapsed=[&](){return std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count();};std::ofstream out(argv[3]);out<<"{\"status\":\"BOUNDED_COHORT\",\"source_C16_answered\":false,\"records\":[";bool comma=false;int finished=0;
 for(int orbit=first;orbit<last;orbit++){
  if(elapsed()>budget)break;BB all{};int xr=0;for(int h=0;h<16;h++)xr+=insert(X[16*orbit+h],all);if(xr!=16)return 4;std::vector<int>profile(720);for(int j=0;j<720;j++)for(int h=0;h<16;h++)if(parity(X[16*orbit+h]&Z[j]))profile[j]|=1<<h;
  std::array<bool,65536>bad{};std::array<int,17>allowed{};std::vector<Bad>certs;int tested=0,pruned=0,maxcount=0,example=0;bool complete=true;
  for(int mask=0;mask<65536;mask++){
   if((mask&255)==0&&elapsed()>budget){complete=false;break;}bool inherited=false;for(int bits=mask;bits;bits&=bits-1){int bit=bits&-bits;if(bad[mask^bit]){inherited=true;break;}}
   if(inherited){bad[mask]=true;pruned++;continue;}tested++;int k=__builtin_popcount(unsigned(mask));BB zero{};int zr=0;unsigned privates=0;
   for(int j=0;j<720;j++){
    int pattern=profile[j]&mask;if(pattern==0){if(zr<128-k)zr+=insert(Z[j],zero);}else if((pattern&(pattern-1))==0)privates|=pattern;
   }
   if(zr<128-k){
    BB own{};for(int h=0;h<16;h++)if(mask>>h&1)insert(X[16*orbit+h],own);U128 witness=0;
    for(int free=0;free<128;free++)if(!zero[free]){U128 w=U128(1)<<free;for(int p=0;p<128;p++)if(zero[p]&&parity(zero[p]&w))w^=U128(1)<<p;if(rem(w,own)){witness=w;break;}}
    if(!witness)return 5;bad[mask]=true;certs.push_back({mask,"zero_rank",witness,zr});
   }else if((privates&unsigned(mask))!=unsigned(mask)){
    int h=__builtin_ctz(unsigned(mask)&~privates);bad[mask]=true;certs.push_back({mask,"missing_private",X[16*orbit+h],zr});
   }else{allowed[k]++;if(k>maxcount){maxcount=k;example=mask;}}
  }
  if(comma)out<<",";comma=true;out<<"{\"orbit\":"<<orbit<<",\"complete\":"<<(complete?"true":"false")<<",\"tested_masks\":"<<tested<<",\"inherited_bad_masks\":"<<pruned<<",\"maximum_surviving_count\":"<<maxcount<<",\"maximum_example_mask\":"<<example<<",\"survivors_by_weight\":[";for(int k=0;k<=16;k++){if(k)out<<",";out<<allowed[k];}out<<"],\"minimal_bad_certificates\":[";for(size_t k=0;k<certs.size();k++){if(k)out<<",";auto c=certs[k];out<<"{\"mask\":"<<c.mask<<",\"kind\":\""<<c.kind<<"\",\"annihilator_hex\":\""<<hex128(c.w)<<"\",\"zero_rank_reported\":"<<c.rank<<"}";}out<<"]}";out.flush();finished+=complete;std::cout<<"ORBIT "<<orbit<<" complete "<<complete<<" max-surviving "<<maxcount<<" minimal-bad "<<certs.size()<<" tested "<<tested<<" pruned "<<pruned<<" seconds "<<elapsed()<<std::endl;if(!complete)break;
 }
 out<<"],\"completed_orbits\":"<<finished<<",\"elapsed_seconds\":"<<elapsed()<<",\"scope\":\"Original full-basis necessary phase restrictions from zero-domain rank and private-partner coverage. Not full completions, not a new rank-oracle principle. Positive survivors not certified completable.\"}\n";
}
