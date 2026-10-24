#define main unused_original_main
#include "direct.cpp"
#undef main
int main(int argc,char**argv){
 if(argc!=2)return 2;std::ifstream in(argv[1]);int n;uint64_t expected;
 uint64_t cases=0,examined=0,total=0;
 while(in>>n>>expected){
  std::vector<Mask>N(n);for(auto &x:N)if(!(in>>x.lo>>x.hi))return 3;
  uint64_t count=0;
  for(int a=0;a<n;++a)for(int b=a+1;b<n;++b)
   for(int c=b+1;c<n;++c)for(int d=c+1;d<n;++d){
    ++examined;
    if(pop(N[a]^N[b]^N[c]^N[d])!=2)continue;
    if(any((N[a]&N[b]&N[c])|(N[a]&N[b]&N[d])|
           (N[a]&N[c]&N[d])|(N[b]&N[c]&N[d])))continue;
    Mask even=(N[a]&N[b])|(N[a]&N[c])|(N[a]&N[d])|
              (N[b]&N[c])|(N[b]&N[d])|(N[c]&N[d]);
    if(pop(N[a]&even)<2||pop(N[b]&even)<2||
       pop(N[c]&even)<2||pop(N[d]&even)<2)continue;
    ++count;
   }
  if(count!=expected){std::cerr<<"Mismatch case "<<cases<<" actual "<<count<<" expected "<<expected<<"\n";return 1;}
  ++cases;total+=count;
 }
 std::cout<<"cases="<<cases<<" subsets="<<examined<<" total_counts="<<total<<" all_match=true\n";
}
