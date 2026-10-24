// Exhaustive independent definition-based checker, deliberately no diamond logic.
#include <cstdint>
#include <fstream>
#include <iostream>
#include <vector>
struct Mask { uint64_t lo, hi; };
Mask operator&(Mask a,Mask b){return {a.lo&b.lo,a.hi&b.hi};}
Mask operator^(Mask a,Mask b){return {a.lo^b.lo,a.hi^b.hi};}
Mask operator|(Mask a,Mask b){return {a.lo|b.lo,a.hi|b.hi};}
int pop(Mask a){return __builtin_popcountll(a.lo)+__builtin_popcountll(a.hi);}
bool any(Mask a){return a.lo||a.hi;}
int main(int argc,char**argv){
 for(int f=1;f<argc;++f){
  std::ifstream in(argv[f]);int n=0;
  if(!(in>>n)||n<4){std::cerr<<"invalid input "<<argv[f]<<"\n";return 2;}
  std::vector<Mask>N(n);
  for(auto &x:N)if(!(in>>x.lo>>x.hi)){std::cerr<<"truncated input\n";return 2;}
  uint64_t examined=0,n42=0,n40=0;
  for(int a=0;a<n;++a)for(int b=a+1;b<n;++b)
   for(int c=b+1;c<n;++c)for(int d=c+1;d<n;++d){
    ++examined;
    int odd=pop(N[a]^N[b]^N[c]^N[d]);
    if(odd!=0&&odd!=2)continue;
    // Elementarity is checked directly: no check may touch three selected variables.
    if(any((N[a]&N[b]&N[c])|(N[a]&N[b]&N[d])|
           (N[a]&N[c]&N[d])|(N[b]&N[c]&N[d])))continue;
    Mask even=(N[a]&N[b])|(N[a]&N[c])|(N[a]&N[d])|
              (N[b]&N[c])|(N[b]&N[d])|(N[c]&N[d]);
    if(pop(N[a]&even)<2||pop(N[b]&even)<2||
       pop(N[c]&even)<2||pop(N[d]&even)<2)continue;
    if(odd==2)++n42;else ++n40;
   }
  std::cout<<argv[f]<<" n="<<n<<" examined="<<examined
           <<" N42="<<n42<<" N40="<<n40<<"\n";
 }
 return 0;
}
