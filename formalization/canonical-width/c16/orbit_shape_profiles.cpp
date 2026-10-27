// Exact zero/private-owner profiles for canonical phase subsets and circulant
// patterns. Relative shifts of a pattern merely relabel opposite vertices.
#include <fstream>
#include <iostream>
#include <vector>
int main(int argc,char**argv){if(argc<4)return 1;std::ifstream fi(argv[1]),mi(argv[2]);std::ofstream out(argv[3]);std::vector<unsigned>masks;unsigned v;while(mi>>v){if(v>=65536)return 1;masks.push_back(v);}out<<"[";bool comma=false;unsigned f;
 while(fi>>f){if(f>=65536)return 1;unsigned columns[16]{};for(int j=0;j<16;++j)for(int i=0;i<16;++i)if(f>>((j-i+16)%16)&1)columns[j]|=1u<<i;
  std::vector<int>zeros,owners;for(unsigned I:masks){int zero=0;unsigned own=0;for(int j=0;j<16;++j){unsigned hit=I&columns[j];if(!hit)++zero;else if(!(hit&(hit-1)))own|=hit;}zeros.push_back(zero);owners.push_back(__builtin_popcount(own));}
  if(comma)out<<",";comma=true;out<<"{\"pattern\":"<<f<<",\"zero\":[";for(int i=0;i<(int)zeros.size();++i)out<<(i?",":"")<<zeros[i];out<<"],\"owners\":[";for(int i=0;i<(int)owners.size();++i)out<<(i?",":"")<<owners[i];out<<"]}";
 }out<<"]\n";}
