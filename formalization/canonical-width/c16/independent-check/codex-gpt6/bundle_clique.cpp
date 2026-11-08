#include <algorithm>
#include <bit>
#include <chrono>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <numeric>
#include <stdexcept>
#include <string>
#include <vector>
using Bits=std::vector<uint64_t>;
struct Search {
 int n,w,target,current_weight=0; std::vector<int> weights; std::vector<Bits> adj; std::vector<std::pair<int,int>> edges;
 std::vector<int> current,answer; uint64_t nodes=0; int root_colors=0; bool timed=false;
 std::chrono::steady_clock::time_point deadline;
 bool any(const Bits& b){for(auto v:b)if(v)return true;return false;}
 int first(const Bits& b){for(int i=0;i<w;i++)if(b[i])return i*64+std::countr_zero(b[i]);return -1;}
 void clear(Bits& b,int v){b[v/64]&=~(uint64_t(1)<<(v%64));}
 bool expired(){if(std::chrono::steady_clock::now()>=deadline){timed=true;return true;}return false;}
 void color(Bits remaining,std::vector<int>& order,std::vector<int>& bound){
  int c=0,total_weight=0;
  while(any(remaining)){
   ++c; int color_weight=0; Bits available=remaining;
   while(any(available)){
    int v=first(available);order.push_back(v);color_weight=std::max(color_weight,weights[v]);bound.push_back(total_weight+color_weight);clear(remaining,v);clear(available,v);
    for(int q=0;q<w;q++)available[q]&=~adj[v][q];
   }
   total_weight+=color_weight;
  }
 }
 bool expand(Bits candidates){
  ++nodes;if(expired())return false;
  std::vector<int> order,bound;color(candidates,order,bound);
  if(current.empty()&&!bound.empty())root_colors=bound.back();
  for(int p=int(order.size())-1;p>=0;--p){
   if(current_weight+bound[p]<target)return false;
   if(expired())return false;
   int v=order[p];current.push_back(v);current_weight+=weights[v];
   if(current_weight>=target){answer=current;return true;}
   Bits next(w);for(int q=0;q<w;q++)next[q]=candidates[q]&adj[v][q];
   if(any(next)&&expand(std::move(next)))return true;
   current.pop_back();current_weight-=weights[v];if(timed)return false;clear(candidates,v);
  }
  return false;
 }
};
int main(int argc,char**argv){
 try{
  if(argc!=4)throw std::runtime_error("usage: bundle_clique SYMMETRIC_MATRIX TARGET_WEIGHT SECONDS");
  auto start=std::chrono::steady_clock::now();double seconds=std::stod(argv[3]);
  std::ifstream in(argv[1]);int m;if(!(in>>m)||m<1)throw std::runtime_error("bad matrix size");
  std::vector<std::string> h(m);for(auto&row:h){in>>row;if(int(row.size())!=m||row.find_first_not_of("01")!=std::string::npos)throw std::runtime_error("bad matrix row");}
  Search s;s.target=std::stoi(argv[2]);s.deadline=start+std::chrono::duration_cast<std::chrono::steady_clock::duration>(std::chrono::duration<double>(seconds));
  for(int a=0;a<m;a++)for(int b=0;b<m;b++)if(h[a][b]!=h[b][a])throw std::runtime_error("matrix must be symmetric");
  for(int a=0;a<m;a++){if(h[a][a]=='1')s.edges.emplace_back(a,a);else for(int b=0;b<a;b++)if(h[b][b]=='0'&&h[a][b]=='1')s.edges.emplace_back(a,b);}
  s.n=s.edges.size();s.w=(s.n+63)/64;
  std::vector<int> degree(s.n);
  for(int v=0;v<s.n;v++){auto[a,b]=s.edges[v];for(int u=0;u<v;u++){auto[c,d]=s.edges[u];if(h[a][c]=='0'&&h[a][d]=='0'&&h[b][c]=='0'&&h[b][d]=='0'){degree[v]++;degree[u]++;}}}
  std::vector<int> permutation(s.n);std::iota(permutation.begin(),permutation.end(),0);
  std::stable_sort(permutation.begin(),permutation.end(),[&](int a,int b){return degree[a]>degree[b];});
  auto old=s.edges;for(int v=0;v<s.n;v++)s.edges[v]=old[permutation[v]];
  for(auto[a,b]:s.edges)s.weights.push_back(a==b?1:2);
  s.adj.assign(s.n,Bits(s.w));
  for(int v=0;v<s.n;v++){auto[a,b]=s.edges[v];for(int u=0;u<v;u++){auto[c,d]=s.edges[u];if(h[a][c]=='0'&&h[a][d]=='0'&&h[b][c]=='0'&&h[b][d]=='0'){s.adj[v][u/64]|=uint64_t(1)<<(u%64);s.adj[u][v/64]|=uint64_t(1)<<(v%64);}}}
  Bits all(s.w,~uint64_t(0));if(s.n%64)all.back()=(uint64_t(1)<<(s.n%64))-1;
  bool found=s.expand(std::move(all));
  double elapsed=std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count();
  std::cout<<"{\"status\":\""<<(s.timed?"INCOMPLETE":"COMPLETE")<<"\",\"found\":"<<(found?"true":"false")<<",\"nodes\":"<<s.nodes<<",\"vertices\":"<<s.n<<",\"root_color_weight_bound\":"<<s.root_colors<<",\"seconds\":"<<elapsed<<",\"bundles\":[";
  for(size_t i=0;i<s.answer.size();i++){if(i)std::cout<<",";auto[a,b]=s.edges[s.answer[i]];std::cout<<"["<<a<<","<<b<<"]";}
  std::cout<<"]}\n";
 }catch(const std::exception&e){std::cerr<<e.what()<<"\n";return 1;}
}
