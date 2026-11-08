// Exact mandatory-pool propagation for every seed-4 monomial subset modulo C16.
#define main legacy_seed4_main
#include "seed4_fifteen.cpp"
#undef main
#include "quotient_fast.h"
#include "quotient_prepared.h"
#include "quotient_coloop.h"
#include "forced_propagation.h"
int main(int argc,char**argv){
 if(argc<4)return 1;auto X=load(argv[1]),Z=load(argv[2]);ForcedPropagation fp(X,Z,128);std::ofstream out(argv[3]);int id[16];
 for(int p=0;p<16;++p){id[p]=-1;for(int i=0;i<(int)X.size();++i)if(X[i]==(U(1)<<(64+p)))id[p]=i;if(id[p]<0)return 1;}
 int low=argc>4?std::stoi(argv[4]):8;int total[17]{},dead[17]{};
 for(unsigned omitted=0;omitted<65535;++omitted){int kept=16-pop2(omitted);if(kept<low)continue;bool canonical=true;
  for(int h=1;h<16;++h)if((unsigned(rot(omitted,h))&65535)<omitted){canonical=false;break;}if(!canonical)continue;
  Bits req;for(int p=0;p<16;++p)if(!(omitted>>p&1))req.set(id[p]);auto r=fp.run(req);++total[kept];if(!r.possible)++dead[kept];
  out<<"{\"kept\":"<<kept<<",\"omitted\":"<<omitted<<",\"possible\":"<<(r.possible?"true":"false")<<",\"rounds\":"<<r.rounds<<",\"reason\":\""<<r.reason<<"\"}\n";
 }
 for(int k=16;k>=low;--k)std::cout<<"kept "<<k<<" classes "<<total[k]<<" excluded "<<dead[k]<<" unresolved "<<total[k]-dead[k]<<"\n";
}
