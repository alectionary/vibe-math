#include <fstream>
#include <iostream>
#include <vector>
#include <queue>
#include <tuple>
using Item=std::tuple<double,int,int,int,int,int>;
int main(int argc,char**argv){std::ifstream in(argv[1]);int N,P,m;in>>N>>P>>m;std::vector<double>p(N),C(P*N*N);std::vector<int>patterns(m*(N-m));for(auto&v:p)in>>v;for(auto&v:C)in>>v;for(auto&v:patterns)in>>v;auto moment=[&](int i,int j,int h){return C[(h*N+i)*N+j];};auto edge=[&](int a,int ha,int b,int hb){if(a<m&&b>=m)return bool(patterns[a*(N-m)+(b-m)]>>((hb-ha+P)%P)&1);if(a>=m&&b<m)return bool(patterns[b*(N-m)+(a-m)]>>((ha-hb+P)%P)&1);return false;};std::priority_queue<Item,std::vector<Item>,std::greater<Item>>heap;int cap=argc>3?std::stoi(argv[3]):5000;double maximum=0;long count=0;
for(int i=0;i<N;++i){int jlo=i<m?m:0,jhi=i<m?N:m,klo=i<m?0:m,khi=i<m?m:N;for(int j=jlo;j<jhi;++j)for(int h=0;h<P;++h){if(!edge(i,0,j,h))continue;double a=moment(i,j,h);for(int k=klo;k<khi;++k)for(int l=0;l<P;++l){if(i==k&&l==0)continue;if(!edge(k,l,j,h))continue;double v=a+moment(i,k,l)-p[i];maximum=std::max(maximum,v);if(v<=1e-5)continue;++count;Item t={v,i,j,k,h,l};if((int)heap.size()<cap)heap.push(t);else if(v>std::get<0>(heap.top())){heap.pop();heap.push(t);}}}}
std::ofstream out(argv[2]);out<<"{\"maximum_violation\":"<<maximum<<",\"violated_tests\":"<<count<<",\"cuts\":[";bool comma=false;while(!heap.empty()){auto[v,i,j,k,h,l]=heap.top();heap.pop();if(comma)out<<",";comma=true;out<<"{\"i\":"<<i<<",\"j\":"<<j<<",\"k\":"<<k<<",\"h\":"<<h<<",\"l\":"<<l<<",\"violation\":"<<v<<"}";}out<<"]}\n";std::cout<<"max "<<maximum<<" violations "<<count<<"\n";}
