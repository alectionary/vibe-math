// Degree-two binary polynomial-calculus pilot. The ideal includes Boolean
// squares and incompatible-edge products. Only linear and selected-variable
// multiples of mandatory source parity equations are added to their row span.
// A contradiction is emitted as source row codes, for independent replay.
#include <algorithm>
#include <chrono>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <numeric>
#include <random>
#include <sstream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <sys/resource.h>
using U=uint64_t;using Row=std::vector<U>;
struct Edge{int x,z,group;std::vector<int> bits;};
std::vector<int> hex_bits(const std::string&s){std::vector<int>v;int k=0;for(auto it=s.rbegin();it!=s.rend();++it){char c=*it;int x=c<='9'?c-'0':c-'a'+10;for(int b=0;b<4;b++)if(x>>b&1)v.push_back(k+b);k+=4;}return v;}
double rss_mb(){struct rusage ru;getrusage(RUSAGE_SELF,&ru);
#ifdef __APPLE__
 return ru.ru_maxrss/1048576.0;
#else
 return ru.ru_maxrss/1024.0;
#endif
}
int main(int argc,char**argv){
 if(argc<7){std::cerr<<"model output seconds max-memory-MiB max-multipliers seed\n";return 2;}
 auto start=std::chrono::steady_clock::now();auto seconds=[&](){return std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count();};double wall=std::stod(argv[3]),mem=std::stod(argv[4]);int limit=std::stoi(argv[5]),seed=std::stoi(argv[6]);bool signature_amo=argc>7&&std::stoi(argv[7]);std::ifstream in(argv[1]);int n,r;std::string s;in>>n>>r>>s;auto tb=hex_bits(s);std::vector<bool>target(r);for(int k:tb){if(k>=r)return 3;target[k]=true;}
 std::vector<std::vector<bool>> A(720,std::vector<bool>(720));for(int i=0;i<720;i++){in>>s;for(int j:hex_bits(s))A[i][j]=true;}
 std::vector<Edge>E(n);std::vector<std::vector<int>>eq(r);std::unordered_map<std::string,int>groups;for(int i=0;i<n;i++){in>>E[i].x>>E[i].z>>s;if(!groups.count(s))groups[s]=groups.size();E[i].group=groups[s];E[i].bits=hex_bits(s);for(int k:E[i].bits){if(k>=r)return 4;eq[k].push_back(i);}}
 auto compatible=[&](int i,int j){return i!=j&&(!signature_amo||E[i].group!=E[j].group)&&E[i].x!=E[j].x&&E[i].z!=E[j].z&&!A[E[i].x][E[j].z]&&!A[E[j].x][E[i].z];};
 auto monomial=[&](int i,int j)->U{if(i==j)return i+1;int a=std::min(i,j),b=std::max(i,j);return (U(b+1)<<32)|U(a+1);};
 std::vector<int>order(n);std::iota(order.begin(),order.end(),0);if(seed>=0)std::shuffle(order.begin(),order.end(),std::mt19937(seed));if(limit<0||limit>n)limit=n;
 std::unordered_map<U,int>pivots;std::vector<Row>basis;std::vector<std::vector<int>>traces;std::vector<int>codes;long long reductions=0,totalterms=0,inputrows=0;size_t maxrow=0;std::string outcome="COMPLETE_NO_CONTRADICTION";int contradiction=-1;Row scratch;std::vector<std::vector<int>>linear_cuts;std::vector<int>linear_cut_basis;
 auto stopped=[&](){if(seconds()>wall){outcome="TIME_LIMIT";return true;}if(rss_mb()>mem){outcome="MEMORY_LIMIT";return true;}return false;};
 auto add=[&](Row v,int code){
  ++inputrows;int id=(int)basis.size();std::vector<int>used;std::sort(v.begin(),v.end());maxrow=std::max(maxrow,v.size());
  while(!v.empty()){
   auto it=pivots.find(v.back());if(it==pivots.end())break;int q=it->second;used.push_back(q);scratch.clear();scratch.reserve(v.size()+basis[q].size());std::set_symmetric_difference(v.begin(),v.end(),basis[q].begin(),basis[q].end(),std::back_inserter(scratch));v.swap(scratch);++reductions;maxrow=std::max(maxrow,v.size());if((reductions&2047)==0&&stopped())return false;
  }
  if(v.empty())return true;
  U p=v.back();pivots[p]=id;codes.push_back(code);traces.push_back(std::move(used));totalterms+=v.size();basis.push_back(std::move(v));if(p==0){contradiction=id;outcome="CONTRADICTION";return false;}if(p<=U(n)&&code>=r){linear_cut_basis.push_back(id);}
  return !stopped();
 };
 bool go=true;for(int k=0;k<r&&go;k++){Row v;if(target[k])v.push_back(0);for(int j:eq[k])v.push_back(j+1);go=add(std::move(v),k);}
 int done=0;
 for(int q=0;q<limit&&go;q++){
  int i=order[q];for(int k=0;k<r&&go;k++){Row v;if(target[k])v.push_back(i+1);for(int j:eq[k]){if(j==i){auto it=std::find(v.begin(),v.end(),U(i+1));if(it==v.end())v.push_back(i+1);else v.erase(it);}else if(compatible(i,j))v.push_back(monomial(i,j));}go=add(std::move(v),r+i*r+k);}
  if(go)done++;if(q%32==0)std::cout<<"multipliers "<<q+1<<" basis "<<basis.size()<<" terms "<<totalterms<<" reductions "<<reductions<<" rssMiB "<<rss_mb()<<" seconds "<<seconds()<<std::endl;
 }
 auto explanation=[&](int row){std::vector<bool>active(basis.size()),source(basis.size());active[row]=true;std::vector<int>selected;for(int j=row;j>=0;j--)if(active[j]){selected.push_back(codes[j]);for(int q:traces[j])active[q]=!active[q];}std::sort(selected.begin(),selected.end());return selected;};
 std::vector<int>proof;if(contradiction>=0)proof=explanation(contradiction);
 std::unordered_set<U>ones;
 if(contradiction<0){std::vector<U>ps;for(auto &kv:pivots)ps.push_back(kv.first);std::sort(ps.begin(),ps.end());for(U p:ps){bool v=false;for(U term:basis[pivots[p]])if(term!=p){if(term==0||ones.count(term))v=!v;}if(v)ones.insert(p);}}
 std::vector<U>oneids(ones.begin(),ones.end());std::sort(oneids.begin(),oneids.end());
 std::ofstream out(argv[2]);out<<"{\"status\":\""<<outcome<<"\",\"free_edges\":"<<n<<",\"one_per_signature\":"<<(signature_amo?"true":"false")<<",\"equations\":"<<r<<",\"multiplier_limit\":"<<limit<<",\"complete_multipliers\":"<<done<<",\"seed\":"<<seed<<",\"input_rows\":"<<inputrows<<",\"basis_rows\":"<<basis.size()<<",\"stored_terms\":"<<totalterms<<",\"max_intermediate_row_terms\":"<<maxrow<<",\"row_xors\":"<<reductions<<",\"peak_rss_MiB\":"<<rss_mb()<<",\"elapsed_seconds\":"<<seconds()<<",\"contradiction_row_codes\":[";for(size_t i=0;i<proof.size();i++){if(i)out<<",";out<<proof[i];}out<<"],\"formal_moment_ones\":[";for(size_t i=0;i<oneids.size();i++){if(i)out<<",";out<<oneids[i];}out<<"],\"complete_multiplier_indices\":[";for(int i=0;i<done;i++){if(i)out<<",";out<<order[i];}out<<"],\"linear_cuts\":[";for(size_t k=0;k<linear_cut_basis.size()&&k<128;k++){if(k)out<<",";int j=linear_cut_basis[k];auto why=explanation(j);out<<"{\"polynomial_monomial_ids\":[";for(size_t i=0;i<basis[j].size();i++){if(i)out<<",";out<<basis[j][i];}out<<"],\"row_codes\":[";for(size_t i=0;i<why.size();i++){if(i)out<<",";out<<why[i];}out<<"]}";}out<<"],\"linear_cuts_found\":"<<linear_cut_basis.size()<<",\"scope\":\"Degree-two row-span test in Boolean/compatibility quotient; limited multiplier set unless complete_multipliers equals free_edges. No full-frame or unconditional-source exclusion without independent physical replay.\"}\n";
 std::cout<<outcome<<" basis "<<basis.size()<<" linear cuts "<<linear_cut_basis.size()<<" seconds "<<seconds()<<" rssMiB "<<rss_mb()<<std::endl;
}
