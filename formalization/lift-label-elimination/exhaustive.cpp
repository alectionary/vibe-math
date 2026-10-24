// Independent exhaustive gauge histograms, including a composite modulus.
#include <array>
#include <cassert>
#include <cstdint>
#include <iostream>
#include <vector>
int main(){
 int N,b;
 while(std::cin>>N>>b){
  assert(N>=1 && N<=4 && b>=1 && b<=5);
  std::vector<std::array<int,11>> rows(3*b);
  for(auto &r:rows)for(auto &x:r)std::cin>>x;
  uint64_t total=1;for(int i=0;i<11;++i)total*=N;
  std::array<uint64_t,6> histogram{};std::array<int,11> z{};
  for(uint64_t code=0;code<total;++code){
   uint64_t value=code;for(int i=0;i<11;++i){z[i]=value%N;value/=N;}
   int balanced=0;
   for(int i=0;i<b;++i){bool good=true;for(int j=0;j<3;++j){int s=0;for(int k=0;k<11;++k)s+=rows[3*i+j][k]*z[k];good&=(s%N==0);}balanced+=good;}
   histogram[balanced]++;
  }
  std::cout<<"{\"N\":"<<N<<",\"base_pasches\":"<<b<<",\"gauge_assignments\":"<<total<<",\"histogram\":[";
  for(int i=0;i<6;++i){if(i)std::cout<<",";std::cout<<histogram[i];}std::cout<<"]}\n";
 }
}
