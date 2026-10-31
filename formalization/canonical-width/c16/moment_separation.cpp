// Sparse row generation for degree-two/three Boolean moment feasibility over F2.
// Separates only violated variable/pair multiples of mandatory parity equations.
// A returned formal assignment is checked independently, including all implicit
// zero moments. It is not a distribution, a partial matching or a full frame.
#include <algorithm>
#include <chrono>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <numeric>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <sys/resource.h>
#include <csignal>
volatile std::sig_atomic_t requested_stop=0;
using U=uint64_t;using Row=std::vector<U>;using Sig=std::vector<U>;
std::vector<int> hex_bits(const std::string&s){std::vector<int>v;int k=0;for(auto it=s.rbegin();it!=s.rend();++it){char c=*it;int x=c<='9'?c-'0':c-'a'+10;for(int b=0;b<4;b++)if(x>>b&1)v.push_back(k+b);k+=4;}return v;}
double rss(){struct rusage ru;getrusage(RUSAGE_SELF,&ru);
#ifdef __APPLE__
 return ru.ru_maxrss/1048576.0;
#else
 return ru.ru_maxrss/1024.0;
#endif
}
struct Edge{int x,z,group;Sig sig;};
void add_sig(Sig&a,const Sig&b){for(size_t k=0;k<a.size();k++)a[k]^=b[k];}
bool nonzero(const Sig&a){for(U x:a)if(x)return true;return false;}
std::vector<int> decode(U m){std::vector<int>v;while(m){v.push_back(int(m&65535)-1);m>>=16;}return v;}
U encode(std::vector<int>v){std::sort(v.begin(),v.end());v.erase(std::unique(v.begin(),v.end()),v.end());U m=0;for(int i=int(v.size())-1;i>=0;i--)m=(m<<16)|U(v[i]+1);return m;}
int main(int argc,char**argv){
 if(argc<7){std::cerr<<"model output seconds memory-MiB max-degree batch-size [signature-amo]\n";return 2;}
 std::signal(SIGTERM,[](int){requested_stop=1;});std::signal(SIGINT,[](int){requested_stop=1;});auto start=std::chrono::steady_clock::now();auto seconds=[&](){return std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count();};double wall=std::stod(argv[3]),mem=std::stod(argv[4]);int degree=std::stoi(argv[5]),batch=std::stoi(argv[6]);bool amo=argc>7&&std::stoi(argv[7]);if(degree<2||degree>3)return 3;
 std::ifstream in(argv[1]);int n,r;std::string s;in>>n>>r>>s;if(n>=65535)return 4;int words=(r+63)/64;Sig target(words);for(int k:hex_bits(s))target[k/64]^=U(1)<<(k%64);
 std::vector<std::vector<bool>>A(720,std::vector<bool>(720));for(int i=0;i<720;i++){in>>s;for(int j:hex_bits(s))A[i][j]=true;}
 std::vector<Edge>E(n);std::vector<std::vector<int>>eq(r);std::unordered_map<std::string,int>groups;
 for(int i=0;i<n;i++){in>>E[i].x>>E[i].z>>s;if(!groups.count(s))groups[s]=groups.size();E[i].group=groups[s];E[i].sig=Sig(words);for(int k:hex_bits(s)){eq[k].push_back(i);E[i].sig[k/64]^=U(1)<<(k%64);}}
 auto compat=[&](int i,int j){return i!=j&&(!amo||E[i].group!=E[j].group)&&E[i].x!=E[j].x&&E[i].z!=E[j].z&&!A[E[i].x][E[j].z]&&!A[E[j].x][E[i].z];};
 std::unordered_map<U,int>pivots;std::vector<Row>basis;std::vector<std::vector<int>>traces;std::vector<U>codes;std::unordered_set<U>multipliers,ones;Row scratch;long long rowxors=0,inputrows=0,terms=0;size_t maxrow=0;int contradiction=-1,iterations=0;std::string outcome="RUNNING";std::vector<int>step_rows;std::vector<double>step_times;U storage_bytes=0,working_bytes=0;
 auto limit=[&](){if(requested_stop){outcome="EXTERNAL_STOP";return true;}if((storage_bytes+working_bytes+U(n)*words*8+67108864)/1048576.0>mem){outcome="ALLOCATION_LIMIT";return true;}if(seconds()>wall){outcome="TIME_LIMIT";return true;}if(rss()>mem){outcome="MEMORY_LIMIT";return true;}return false;};
 auto insert=[&](Row v,U code){
  inputrows++;std::sort(v.begin(),v.end());std::vector<int>used;maxrow=std::max(maxrow,v.size());
  while(!v.empty()){auto it=pivots.find(v.back());if(it==pivots.end())break;int q=it->second;used.push_back(q);scratch.clear();scratch.reserve(v.size()+basis[q].size());std::set_symmetric_difference(v.begin(),v.end(),basis[q].begin(),basis[q].end(),std::back_inserter(scratch));v.swap(scratch);working_bytes=(v.capacity()+scratch.capacity())*sizeof(U);rowxors++;maxrow=std::max(maxrow,v.size());if((rowxors&2047)==0&&limit())return false;}
  if(v.empty())return !limit();int id=basis.size();U p=v.back();pivots[p]=id;codes.push_back(code);storage_bytes+=v.capacity()*sizeof(U)+used.capacity()*sizeof(int)+128;traces.push_back(std::move(used));terms+=v.size();basis.push_back(std::move(v));if(p==0){contradiction=id;outcome="CONTRADICTION";return false;}return !limit();
 };
 auto make_row=[&](U mask,int k){
  auto indices=decode(mask);Row v;if(target[k/64]>>(k%64)&1)v.push_back(mask);
  for(int j:eq[k]){auto next=indices;bool ok=true;for(int i:indices)if(i!=j&&!compat(i,j)){ok=false;break;}if(!ok)continue;next.push_back(j);U mon=encode(next);if(mon==mask){if(!v.empty()&&v[0]==mask)v.erase(v.begin());else v.insert(v.begin(),mask);}else v.push_back(mon);}
  return v;
 };
 bool go=true;for(int k=0;k<r&&go;k++)go=insert(make_row(0,k),k);multipliers.insert(0);
 while(go){
  ones.clear();std::vector<U>ps;ps.reserve(pivots.size());for(auto &kv:pivots)ps.push_back(kv.first);std::sort(ps.begin(),ps.end());
  for(U p:ps){bool value=false;for(U term:basis[pivots[p]])if(term!=p){if(term==0||ones.count(term))value=!value;}if(value)ones.insert(p);}
  std::vector<Sig>linear(n,Sig(words));std::unordered_map<U,Sig>quadratic;
  auto accum=[&](U pair,const Sig&sig){auto it=quadratic.find(pair);if(it==quadratic.end())it=quadratic.emplace(pair,Sig(words)).first;add_sig(it->second,sig);};
  for(U m:ones){auto ids=decode(m);if(ids.size()==1){int i=ids[0];add_sig(linear[i],target);add_sig(linear[i],E[i].sig);}else if(ids.size()==2){int i=ids[0],j=ids[1];add_sig(linear[i],E[j].sig);add_sig(linear[j],E[i].sig);if(degree==3){Sig value=target;add_sig(value,E[i].sig);add_sig(value,E[j].sig);accum(m,value);}}else if(ids.size()==3){int i=ids[0],j=ids[1],k=ids[2];accum(encode({i,j}),E[k].sig);accum(encode({i,k}),E[j].sig);accum(encode({j,k}),E[i].sig);}else return 5;}
  std::vector<U>newrows;
  for(int i=0;i<n;i++)if(nonzero(linear[i])){U mask=i+1;if(multipliers.count(mask)){std::cerr<<"existing linear multiplier violated\n";return 6;}newrows.push_back(mask);}
  if(degree==3)for(auto &entry:quadratic)if(nonzero(entry.second)){if(multipliers.count(entry.first)){std::cerr<<"existing quadratic multiplier violated\n";return 7;}newrows.push_back(entry.first);}
  std::sort(newrows.begin(),newrows.end());
  if(newrows.empty()){outcome=degree==3?"COMPLETE_CUBIC_MOMENT_FEASIBLE":"COMPLETE_QUADRATIC_MOMENT_FEASIBLE";break;}
  if(limit()){go=false;break;}
  iterations++;int added=0;for(U mask:newrows){if(added>=batch)break;bool completed=true;for(int k=0;k<r;k++)if(!insert(make_row(mask,k),mask*U(r)+k)){go=false;completed=false;break;}if(completed){multipliers.insert(mask);added++;}else break;}
  step_rows.push_back(added);step_times.push_back(seconds());if(iterations%10==0||!go)std::cout<<"iteration "<<iterations<<" missing "<<newrows.size()<<" multipliers "<<multipliers.size()<<" basis "<<basis.size()<<" terms "<<terms<<" moments "<<ones.size()<<" seconds "<<seconds()<<" rssMiB "<<rss()<<std::endl;
 }
 std::vector<U>proof;
 if(contradiction>=0){std::vector<bool>active(basis.size());active[contradiction]=true;for(int j=contradiction;j>=0;j--)if(active[j]){proof.push_back(codes[j]);for(int q:traces[j])active[q]=!active[q];}std::sort(proof.begin(),proof.end());}
 std::vector<U>oneids(ones.begin(),ones.end()),multis(multipliers.begin(),multipliers.end());std::sort(oneids.begin(),oneids.end());std::sort(multis.begin(),multis.end());std::ofstream out(argv[2]);out<<"{\"status\":\""<<outcome<<"\",\"max_degree\":"<<degree<<",\"monomial_radix_bits\":16,\"one_per_signature\":"<<(amo?"true":"false")<<",\"free_edges\":"<<n<<",\"equations\":"<<r<<",\"iterations\":"<<iterations<<",\"input_rows\":"<<inputrows<<",\"basis_rows\":"<<basis.size()<<",\"stored_terms\":"<<terms<<",\"estimated_storage_bytes\":"<<storage_bytes<<",\"max_intermediate_row_terms\":"<<maxrow<<",\"row_xors\":"<<rowxors<<",\"peak_rss_MiB\":"<<rss()<<",\"elapsed_seconds\":"<<seconds()<<",\"contradiction_row_codes\":[";for(size_t k=0;k<proof.size();k++){if(k)out<<",";out<<proof[k];}out<<"],\"formal_moment_ones\":[";for(size_t k=0;k<oneids.size();k++){if(k)out<<",";out<<oneids[k];}out<<"],\"complete_multiplier_monomials\":[";for(size_t k=0;k<multis.size();k++){if(k)out<<",";out<<multis[k];}out<<"],\"scope\":\"Sparse separation of variable/pair parity products modulo Boolean and compatibility relations. COMPLETE formal moments require independent global replay; time/memory limits remain unresolved.\"}\n";std::cout<<outcome<<" seconds "<<seconds()<<" rssMiB "<<rss()<<std::endl;
}
