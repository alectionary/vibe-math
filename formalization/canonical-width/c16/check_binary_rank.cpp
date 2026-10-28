// Independent low-pivot binary rank consumer of little-endian fixed-width rows.
// The producer uses high pivots and logical x*z^T. Its caller regenerates
// physical canonical coordinates, transposes all atoms, and supplies this stream.
#include <array>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <vector>
int main(int argc,char **argv) {
  if(argc!=3)return 2;
  int expected=std::stoi(argv[2]);
  uint16_t endian=1;if(*(uint8_t*)&endian!=1)return 3;
  using Row=std::array<uint64_t,256>;
  std::vector<Row> piv(16384);
  std::array<bool,16384> present{};
  std::ifstream f(argv[1],std::ios::binary);
  if(!f)return 4;
  int count=0,rank=0;
  Row a;
  while(f.read((char*)a.data(),sizeof(a))) {
    ++count;
    for(int w=0;w<256;++w)while(a[w]) {
      int p=64*w+__builtin_ctzll(a[w]);
      if(!present[p]) {piv[p]=a;present[p]=true;++rank;goto next;}
      for(int j=w;j<256;++j)a[j]^=piv[p][j];
    }
    next:;
  }
  if(f.gcount()!=0)return 5;
  std::cout<<"{\"status\":\""<<(rank==expected&&count==expected?"PASS":"FAIL")<<"\",\"rows\":"<<count<<",\"rank\":"<<rank<<",\"columns\":16384,\"method\":\"least-pivot elimination on transposed regenerated physical atoms\"}\n";
  return rank==expected&&count==expected?0:6;
}
