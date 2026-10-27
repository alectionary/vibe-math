#include <iostream>
#include <fstream>
#include <vector>
#include <queue>
#include <tuple>
using Item=std::tuple<double,int,int,int,int,int,int>;
int main(int argc,char**argv){std::ifstream in(argv[1]);int N,P;in>>N>>P;std::vector<double>p(N),C(P*N*N);for(auto&v:p)in>>v;for(auto&v:C)in>>v;auto c=[&](int h,int i,int j){return C[(h*N+i)*N+j];};std::priority_queue<Item,std::vector<Item>,std::greater<Item>>heap;int cap=argc>3?std::stoi(argv[3]):10000;double maximum=0;long count=0;
 auto save=[&](double v,int type,int i,int j,int k,int h,int l){maximum=std::max(maximum,v);if(v<=1e-5)return;++count;Item x={v,type,i,j,k,h,l};if((int)heap.size()<cap)heap.push(x);else if(v>std::get<0>(heap.top())){heap.pop();heap.push(x);}};
 for(int i=0;i<N;++i)for(int j=0;j<N;++j)for(int h=0;h<P;++h){double a=c(h,i,j);for(int k=0;k<N;++k)for(int l=0;l<P;++l){double b=c(l,i,k),d=c((l-h+P)%P,j,k);save(a+b-d-p[i],0,i,j,k,h,l);save(p[i]+p[j]+p[k]-a-b-d-1,1,i,j,k,h,l);}}
 std::ofstream out(argv[2]);out<<"{\"maximum_violation\":"<<maximum<<",\"violated_ordered_tests\":"<<count<<",\"cuts\":[";bool comma=false;while(!heap.empty()){auto[v,type,i,j,k,h,l]=heap.top();heap.pop();if(comma)out<<",";comma=true;out<<"{\"kind\":"<<type<<",\"i\":"<<i<<",\"j\":"<<j<<",\"k\":"<<k<<",\"h\":"<<h<<",\"l\":"<<l<<",\"violation\":"<<v<<"}";}out<<"]}\n";std::cout<<"maximum "<<maximum<<" violated "<<count<<"\n";}
