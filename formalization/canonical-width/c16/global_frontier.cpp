// A capped exhaustive search exports every unvisited partition as a task.
#define main legacy_seed4_main
#include "seed4_fifteen.cpp"
#undef main
#include "quotient_fast.h"
#include "quotient_prepared.h"
#include <chrono>
#include "quotient_frontier.h"
#include <sstream>
static std::string bitshex(const Bits&b){std::string out;char buf[17];for(int w=Bits::NW-1;w>=0;--w){std::snprintf(buf,sizeof(buf),"%016llx",(unsigned long long)b.w[w]);out+=buf;}return out;}
static Bits parsebits(const std::string&s){Bits b;if(s.size()>Bits::NW*16)std::exit(5);for(int k=0;k<(int)s.size();++k){char c=s[s.size()-1-k];int d=c<='9'?c-'0':c-'a'+10;if(d<0||d>15)std::exit(5);b.w[k/16]|=uint64_t(d)<<(4*(k%16));}return b;}
int main(int argc,char**argv){
 if(argc<7)return 1;auto X=load(argv[1]),Z=load(argv[2]);std::string prefix=argv[3];uint64_t cap=std::stoull(argv[4]);int bound=std::stoi(argv[5]);double seconds=std::stod(argv[6]);Bits a,b;a.fill(X.size());b.fill(Z.size());std::vector<std::pair<int,int>>past;
 if(argc>7){std::ifstream in(argv[7]);std::string tag,ax,bz;int n,remaining,recorded_bound;in>>tag>>remaining>>recorded_bound>>ax>>bz>>n;if(!in||tag!="TASK"||remaining!=128-n||recorded_bound!=bound)return 5;a=parsebits(ax);b=parsebits(bz);for(int k=0;k<n;++k){int i,j;in>>i>>j;if(i<0||i>=(int)X.size()||j<0||j>=(int)Z.size())return 5;past.push_back({i,j});}if(!in)return 5;}
 for(int i=0;i<(int)past.size();++i)for(int j=0;j<(int)past.size();++j)if(dot(X[past[i].first],Z[past[j].second])!=(i==j))return 5;
 bool valid=true;a.each([&](int i){if(i>=(int)X.size()){valid=false;return;}for(auto[u,v]:past)if(dot(X[i],Z[v]))valid=false;});b.each([&](int j){if(j>=(int)Z.size()){valid=false;return;}for(auto[u,v]:past)if(dot(X[u],Z[j]))valid=false;});if(!valid)return 5;
 FrontierQuotient q(X,Z);q.max_seed4=bound;q.max_seconds=seconds;uint64_t nodes=0;bool capped=false;std::vector<std::pair<int,int>>solution;auto start=std::chrono::steady_clock::now();bool found=q.complete(a,b,128-past.size(),cap,nodes,capped,&solution);double elapsed=std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count();
 std::ofstream tasks(prefix+".tasks");
 for(auto&t:q.frontier){std::vector<std::pair<int,int>>all=past;all.insert(all.end(),t.fixed.begin(),t.fixed.end());int mono=0;for(auto[i,j]:t.fixed)if(__builtin_popcountll(uint64_t(X[i]))+__builtin_popcountll(uint64_t(X[i]>>64))==1 && uint16_t(X[i]>>64))++mono;
  tasks<<"TASK "<<128-all.size()<<" "<<bound-mono<<" "<<bitshex(t.a)<<" "<<bitshex(t.b)<<" "<<all.size();for(auto[i,j]:all)tasks<<" "<<i<<" "<<j;tasks<<"\n";
 }
 if(found){past.insert(past.end(),solution.begin(),solution.end());if(past.size()!=128)return 5;for(int i=0;i<128;++i)for(int j=0;j<128;++j)if(dot(X[past[i].first],Z[past[j].second])!=(i==j))return 5;}
 std::ofstream out(prefix+".json");out<<"{\"status\":\""<<(found?"SAT":capped?"FRONTIER":"UNSAT")<<"\",\"nodes\":"<<nodes<<",\"seconds\":"<<elapsed<<",\"frontier_tasks\":"<<q.frontier.size()<<",\"time_capped\":"<<(q.time_capped?"true":"false")<<",\"max_depth\":"<<q.max_depth<<",\"remaining_seed4_cap\":"<<bound<<",\"pool_pairs\":[";if(found)for(int k=0;k<128;++k)out<<(k?",":"")<<"["<<past[k].first<<","<<past[k].second<<"]";out<<"]}\n";
 std::cout<<(found?"SAT":capped?"FRONTIER":"UNSAT")<<" nodes "<<nodes<<" tasks "<<q.frontier.size()<<" seconds "<<elapsed<<"\n";return found?0:capped?2:3;
}
