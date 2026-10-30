// Independently implemented GF(2) elimination; input columns already reliability sorted.
#include <cstdint>
#include <vector>
#include <algorithm>
extern "C" int solve_osd(std::uint64_t* a,int m,int n,std::uint64_t* answer){
 const int words=(n+1+63)/64;int rank=0;std::vector<int> pivots;
 for(int col=0;col<n && rank<m;++col){
  int w=col/64;std::uint64_t bit=std::uint64_t(1)<<(col%64);int found=rank;
  while(found<m && !(a[found*words+w]&bit))++found;
  if(found==m)continue;
  for(int j=0;j<words;++j)std::swap(a[rank*words+j],a[found*words+j]);
  for(int r=rank+1;r<m;++r)if(a[r*words+w]&bit)
   for(int j=w;j<words;++j)a[r*words+j]^=a[rank*words+j];
  pivots.push_back(col);++rank;
 }
 for(int r=rank;r<m;++r)if((a[r*words+n/64]>>(n%64))&1)return -1;
 std::fill(answer,answer+words,0);
 for(int r=rank-1;r>=0;--r){
  int v=(a[r*words+n/64]>>(n%64))&1;
  for(int j=0;j<words;++j)v^=__builtin_parityll(a[r*words+j]&answer[j]);
  if(v)answer[pivots[r]/64]|=std::uint64_t(1)<<(pivots[r]%64);
 }
 return rank;
}
