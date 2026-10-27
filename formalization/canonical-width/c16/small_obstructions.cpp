// Enumerate necessary two/three-X exclusions modulo simultaneous translation.
// Every exclusion carries an independently checked GF(2) witness; this is not
// by itself a global nonexistence certificate.
#define main legacy_seed4_main
#include "seed4_fifteen.cpp"
#undef main
#include <chrono>
static std::string hex128(U v){char b[35];std::snprintf(b,sizeof(b),"0x%016llx%016llx",(unsigned long long)(v>>64),(unsigned long long)v);return b;}
int main(int argc,char**argv){
 if(argc<4)return 1;auto X=load(argv[1]),Z=load(argv[2]);if(X.size()!=720||Z.size()!=720)return 1;
 std::ofstream out(argv[3]);std::vector<Bits> zero(720),badpair(720);uint64_t tested=0,bad=0,circuits=0,skipped=0;
 auto start=std::chrono::steady_clock::now();double limit=argc>4?std::stod(argv[4]):600;bool capped=false;
 auto emit=[&](std::vector<int> ids,const GE&g){
  GE tp;for(int i:ids)tp.insert(X[i]);U witness=0;
  for(int free=0;free<128&&!witness;++free)if(!g.p[free]){
   U w=U(1)<<free;for(int p=127;p>=0;--p)if(g.p[p]&&dot(g.p[p],w))w^=U(1)<<p;
   U r=w;while(r){int p=ctz128(r);if(!tp.p[p])break;r^=tp.p[p];}if(r)witness=w;
  }
  if(!witness)std::exit(4);out<<"{\"kind\":\"z_zero\",\"indices\":[";
  for(int k=0;k<(int)ids.size();++k)out<<(k?",":"")<<ids[k];out<<"],\"annihilator\":\""<<hex128(witness)<<"\",\"clause\":[";
  for(int k=0;k<(int)ids.size();++k)out<<(k?",":"")<<-ids[k]-1;out<<"],\"cyclic\":true}\n";++bad;
 };
 for(int i=0;i<720;++i)for(int j=0;j<720;++j)if(!dot(X[i],Z[j]))zero[i].set(j);
 for(int a=0;a<45;++a)for(int b=a;b<45;++b)for(int h=(a==b?1:0);h<(a==b?9:16);++h){
  int i=16*a,j=16*b+h;Bits zz=zero[i];zz.keep(zero[j]);GE g;zz.each([&](int k){g.insert(Z[k]);});
  if(g.n<126){emit({i,j},g);for(int t=0;t<16;++t){int u=16*a+t,v=16*b+(h+t)%16;badpair[u].set(v);badpair[v].set(u);}}
 }
 for(int i=0;i<720&&!capped;i+=16)for(int j=i+1;j<720&&!capped;++j)for(int k=j+1;k<720;++k){
  std::array<int,3> ids{i,j,k};bool canonical=true;
  for(int v:ids)if(v/16==i/16 && v%16){std::array<int,3> shifted;int t=16-v%16;for(int q=0;q<3;++q)shifted[q]=(ids[q]/16)*16+(ids[q]%16+t)%16;std::sort(shifted.begin(),shifted.end());if(shifted<ids){canonical=false;break;}}
  if(!canonical)continue;
  if((++tested&65535)==0){double s=std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count();std::cerr<<"tested "<<tested<<" bad "<<bad<<" seconds "<<s<<"\n";if(s>=limit){capped=true;break;}}
  if(badpair[i].test(j)||badpair[i].test(k)||badpair[j].test(k)){++skipped;continue;}
  if((X[i]^X[j]^X[k])==0){out<<"{\"kind\":\"x_circuit\",\"indices\":["<<i<<","<<j<<","<<k<<"],\"clause\":["<<-i-1<<","<<-j-1<<","<<-k-1<<"],\"cyclic\":true}\n";++circuits;continue;}
  Bits zz=zero[i];zz.keep(zero[j]);zz.keep(zero[k]);GE g;
  for(int w=0;w<Bits::NW&&g.n<125;++w){uint64_t bits=zz.w[w];while(bits&&g.n<125){int z=64*w+__builtin_ctzll(bits);bits&=bits-1;g.insert(Z[z]);}}
  if(g.n<125)emit({i,j,k},g);
 }
 std::cout<<(capped?"INCOMPLETE":"COMPLETE")<<" triple_orbits "<<tested<<" rank_exclusions_including_pair "<<bad<<" circuits "<<circuits<<" skipped_bad_pairs "<<skipped<<"\n";
 return capped?2:0;
}
