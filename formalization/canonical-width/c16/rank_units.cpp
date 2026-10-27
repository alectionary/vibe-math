// Optional native acceleration: test every one-vector extension of a selected
// X set against the necessary opposite-zero-pool rank bound. The Python caller
// independently constructs and checks each resulting algebraic certificate.
#include <cstdint>
using U=unsigned __int128;
extern "C" int c16_rank_units(const uint64_t* zlo,const uint64_t* zhi,int nz,
                             const uint64_t* masks,int nx,int words,
                             const uint64_t* chosen,int dimension,int* output){
 int count=0;
 for(int i=0;i<nx;++i){
  bool selected=(chosen[i/64]>>(i%64))&1;if(selected)continue;
  U piv[128]{};int rank=0;
  for(int j=0;j<nz&&rank>=0&&rank<dimension-1;++j){
   const uint64_t* a=masks+j*words;bool zero=true;
   for(int k=0;k<words;++k)if(a[k]&chosen[k]){zero=false;break;}
   if(!zero || ((a[i/64]>>(i%64))&1))continue;
   U v=(U(zhi[j])<<64)|zlo[j];
   while(v){uint64_t lo=v;int p=lo?__builtin_ctzll(lo):64+__builtin_ctzll(uint64_t(v>>64));
    if(piv[p])v^=piv[p];else{piv[p]=v;++rank;break;}}
  }
  if(rank<dimension-1)output[count++]=i;
 }
 return count;
}
