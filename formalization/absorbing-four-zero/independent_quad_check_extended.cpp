// Independent definition-based exhaustive check. Compile with C++17.
#include <array>
#include <cassert>
#include <cstdint>
#include <iostream>
#include <vector>
int main() {
 int n,m;
 while (std::cin >> n >> m) {
  assert((n==273 && m==91) || (n==140 && m==70));
  std::vector<std::array<int,3>> c(n);
  std::vector<__uint128_t> masks(n);
  for (int v=0;v<n;++v) {
   for (int j=0;j<3;++j) { std::cin>>c[v][j]; assert(0<=c[v][j] && c[v][j]<m); masks[v]|=(__uint128_t(1)<<c[v][j]); }
   assert(c[v][0]<c[v][1] && c[v][1]<c[v][2]);
  }
  for(int u=0;u<n;++u)for(int v=u+1;v<n;++v) {
   int shared=0;for(int x:c[u])for(int y:c[v])shared+=(x==y);assert(shared<=1);
  }
  uint64_t tested=0,zero=0,elementary=0;
  for(int a=0;a<n;++a)for(int b=a+1;b<n;++b)for(int d=b+1;d<n;++d) {
   __uint128_t s=masks[a]^masks[b]^masks[d];
   for(int e=d+1;e<n;++e) {
    ++tested;
    if((s^masks[e])!=0)continue;
    ++zero;
    std::vector<int> induced(m,0);
    for(int v:{a,b,d,e})for(int r:c[v])++induced[r];
    bool good=true;
    for(int k:induced)if(k!=0 && k!=2)good=false;
    if(good)++elementary;
   }
  }
  assert(zero==elementary);
  std::cout<<"{\"n\":"<<n<<",\"checks\":"<<m<<",\"four_subsets_tested\":"<<tested<<",\"weight_four_kernel_words\":"<<zero<<",\"elementary40_supports\":"<<elementary<<"}\n";
 }
}
