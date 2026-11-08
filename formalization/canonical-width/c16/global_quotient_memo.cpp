// Exhaustive partitioned full-pool dual-basis search, subject to a node cap.
#define main legacy_seed4_main
#include "seed4_fifteen.cpp"
#undef main
#include "quotient_fast.h"
#include "quotient_prepared.h"
#include "quotient_coloop.h"
#include <chrono>
#include <unordered_set>
#include "quotient_memo.h"
#include <chrono>
int main(int argc,char**argv){
 if(argc<5)return 1;auto X=load(argv[1]),Z=load(argv[2]);uint64_t cap=std::stoull(argv[4]);MemoQuotient search(X,Z);search.max_seed4=argc>5?std::stoi(argv[5]):16;search.max_seconds=argc>6?std::stod(argv[6]):0;Bits a,b;a.fill(X.size());b.fill(Z.size());uint64_t nodes=0;bool capped=false;std::vector<std::pair<int,int>>pairs;auto start=std::chrono::steady_clock::now();
 bool found=search.complete(a,b,128,cap,nodes,capped,&pairs);double seconds=std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count();
 if(found){if(pairs.size()!=128)return 4;for(int i=0;i<128;++i)for(int j=0;j<128;++j)if(dot(X[pairs[i].first],Z[pairs[j].second])!=(i==j))return 4;}
 std::ofstream out(argv[3]);out<<"{\"status\":\""<<(found?"SAT":capped?"NODE_LIMIT":"UNSAT")<<"\",\"node_cap\":"<<cap<<",\"nodes\":"<<nodes<<",\"seconds\":"<<seconds<<",\"max_seed4\":"<<search.max_seed4<<",\"max_depth\":"<<search.max_depth<<",\"monomial_prunes\":"<<search.monomial_prunes<<",\"time_capped\":"<<(search.time_capped?"true":"false")<<",\"pool_pairs\":[";bool comma=false;for(auto[i,j]:pairs){if(comma)out<<",";comma=true;out<<"["<<i<<","<<j<<"]";}out<<"]}\n";
 std::cout<<(found?"SAT":capped?"NODE_LIMIT":"UNSAT")<<" nodes "<<nodes<<" seconds "<<seconds<<"\n";return found?0:capped?2:3;
}
