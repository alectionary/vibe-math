// Exhaustive absorbing-support count for irregular parity-check matrices.
// Input: n m, then check rows. Output: all absorbing supports of size four.
#include <cstdint>
#include <iostream>
#include <vector>
using U = unsigned __int128;
int pc(U x) {return __builtin_popcountll(uint64_t(x))+__builtin_popcountll(uint64_t(x>>64));}
int main() {
  int n,m; if(!(std::cin>>n>>m)||n<4||m>128||m<1) return 1;
  std::vector<U> col(n,0); std::vector<int> degree(n,0);
  for(int c=0;c<m;++c) {
    int d; std::cin>>d;
    for(int j=0;j<d;++j) {int v;std::cin>>v;if(v<0||v>=n||(col[v]&(U(1)<<c)))return 2;col[v]|=U(1)<<c;}
  }
  for(int v=0;v<n;++v) degree[v]=pc(col[v]);
  std::cout<<"[";bool first=true;
  for(int a=0;a<n;++a) for(int b=a+1;b<n;++b) {
    U ab=col[a]^col[b];
    for(int c=b+1;c<n;++c) {
      U abc=ab^col[c];
      for(int d=c+1;d<n;++d) {
        U odd=abc^col[d];
        if(2*pc(odd&col[a])>=degree[a]||2*pc(odd&col[b])>=degree[b]||
           2*pc(odd&col[c])>=degree[c]||2*pc(odd&col[d])>=degree[d])continue;
        if(!first)std::cout<<",";first=false;
        std::cout<<"["<<a<<","<<b<<","<<c<<","<<d<<"]";
      }
    }
  }
  std::cout<<"]\n";
}
