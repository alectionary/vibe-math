// Read-only diagnostics appended to the unchanged decoder; no early exit.
#include <cassert>
#include <map>
#include <set>
using Interval=std::pair<int64_t,int64_t>;
struct BoxEval{std::vector<Interval> next;std::string bits;int odd=-1;std::vector<int> odd_checks;};
Interval check_interval(bool syn,const std::vector<int>&edges,const std::vector<Interval>&box,int excluded){
 bool parity=syn,ambiguous=false;int64_t low=1000*scale,high=1000*scale;
 for(int f:edges){if(f==excluded)continue;auto [l,u]=box[f];
  assert(l<=u);int64_t alo=l<=0&&u>=0?0:std::min(std::abs(l),std::abs(u));
  int64_t ahi=std::max(std::abs(l),std::abs(u));low=std::min(low,alo);high=std::min(high,ahi);
  if(u<0)parity=!parity;else if(l<0)ambiguous=true;
 }
 low=std::min(50*scale,(800*low+500)/1000);high=std::min(50*scale,(800*high+500)/1000);
 if(ambiguous)return {-high,high};
 return parity?Interval{-high,-low}:Interval{low,high};
}
BoxEval evaluate(const Tanner&h,const std::vector<int>&s,const std::vector<Interval>&box){
 std::vector<Interval>r(box.size());
 for(int c=0;c<h.m;++c)for(int e:h.ce[c]){
  r[e]=check_interval(s[c],h.ce[c],box,e);
 }
 BoxEval out;out.bits=std::string(h.n,'?');out.next.resize(box.size());
 constexpr int64_t prior=3332431;
 for(int v=0;v<h.n;++v){int64_t lo=prior,hi=prior;for(int e:h.ve[v]){lo+=r[e].first;hi+=r[e].second;}
  if(hi<0)out.bits[v]='1';else if(lo>=0)out.bits[v]='0';
  for(int e:h.ve[v])out.next[e]={clip(lo-r[e].first),clip(hi-r[e].second)};
 }
 for(int c=0;c<h.m;++c){bool all=true;int parity=0;for(int e:h.ce[c]){char bit=out.bits[h.variable[e]];if(bit=='?'){all=false;break;}parity^=bit=='1';}
  if(all&&parity!=s[c]){if(out.odd<0)out.odd=c;out.odd_checks.push_back(c);}}
 return out;
}
uint64_t hashq(const std::vector<int64_t>&q){uint64_t h=1469598103934665603ULL;for(auto x:q){h^=uint64_t(x);h*=1099511628211ULL;}return h;}
void vec(const std::vector<int64_t>&xs){std::cout<<'[';for(size_t i=0;i<xs.size();++i){if(i)std::cout<<',';std::cout<<xs[i];}std::cout<<']';}
int main(){
 std::ios::sync_with_stdio(false);std::cin.tie(nullptr);int n,m,trials,detail,profile;std::cin>>n>>m>>trials>>detail>>profile;assert(n==252);
 Tanner h(n,m);for(int c=0;c<m;++c){int d;std::cin>>d;for(int j=0;j<d;++j){int v;std::cin>>v;h.edge(c,v);}}
 for(int t=0;t<trials;++t){int index;std::string error;std::cin>>index>>error;auto s=h.syndrome(error);
  std::vector<std::vector<int64_t>>qs;std::vector<std::string>xs;active_q=&qs;active_x=&xs;
  Result res=decode(h,s,.04,100,.8);active_q=nullptr;active_x=nullptr;
  assert(qs.size()==size_t(res.iterations)&&xs.size()==qs.size());
  int start=0,period=0,repeat=0;
  std::map<uint64_t,std::vector<int>>seen;
  for(int k=0;k<int(qs.size());++k){uint64_t hash=hashq(qs[k]);
   for(int j:seen[hash])if(qs[j]==qs[k]){start=j+1;period=k-j;repeat=k+1;break;}
   if(period)break;seen[hash].push_back(k);
  }
  if(period)assert(!res.matched);
  int box_passes=0,box_check=-1;std::vector<Interval>box;std::string box_bits;
  if(!res.matched&&!qs.empty()){
   box.resize(qs[0].size());int begin=std::max(0,int(qs.size())-8);
   for(size_t e=0;e<box.size();++e){int64_t lo=qs[begin][e],hi=lo;for(int k=begin+1;k<int(qs.size());++k){lo=std::min(lo,qs[k][e]);hi=std::max(hi,qs[k][e]);}box[e]={lo,hi};}
   for(int pass=1;pass<=32;++pass){auto ev=evaluate(h,s,box);bool invariant=true;
    for(size_t e=0;e<box.size();++e)if(ev.next[e].first<box[e].first||ev.next[e].second>box[e].second){invariant=false;break;}
    if(invariant){box_passes=pass;box_check=ev.odd;box_bits=ev.bits;break;}
    for(size_t e=0;e<box.size();++e){box[e].first=std::min(box[e].first,ev.next[e].first);box[e].second=std::max(box[e].second,ev.next[e].second);}
   }
  }
  std::vector<int> robust,pinned;
  std::vector<std::pair<int,int64_t>>specs;
  if(profile)for(int entry:{25,50,75})for(int64_t radius:{1LL,1024LL,65536LL})specs.push_back({entry,radius});
  else specs.push_back({75,1});
  for(auto [entry,radius]:specs){
   int certificate=-1;std::set<int> persistent;for(int c=0;c<h.m;++c)persistent.insert(c);
   if(qs.size()>=size_t(entry)){
    std::vector<Interval>bounds;for(auto q:qs[entry-1])bounds.push_back({clip(q-radius),clip(q+radius)});
    certificate=100;
    for(int iteration=entry;iteration<=100;++iteration){auto ev=evaluate(h,s,bounds);if(ev.odd<0){certificate=iteration-1;persistent.clear();break;}
     std::set<int> found(ev.odd_checks.begin(),ev.odd_checks.end());for(auto it=persistent.begin();it!=persistent.end();){if(!found.count(*it))it=persistent.erase(it);else ++it;}
     bounds=std::move(ev.next);}
   }
   robust.push_back(certificate);pinned.push_back(certificate==100&&!persistent.empty()?*persistent.begin():-1);
  }
  int hard_period=0;for(int p=1;p<=8&&2*p<=int(xs.size());++p){bool equal=true;for(int j=0;j<2*p;++j)equal&=xs[xs.size()-1-j]==xs[xs.size()-1-j%p];if(equal){hard_period=p;break;}}
  std::cout<<"{\"index\":"<<index<<",\"iterations\":"<<res.iterations<<",\"matched\":"<<res.matched<<",\"estimate\":\""<<res.estimate<<"\",\"cycle_start\":"<<start<<",\"cycle_period\":"<<period<<",\"cycle_repeat\":"<<repeat<<",\"box_passes\":"<<box_passes<<",\"box_check\":"<<box_check<<",\"hard_tail_period\":"<<hard_period;
  std::cout<<",\"robust_tail_last\":[";for(size_t i=0;i<robust.size();++i){if(i)std::cout<<',';std::cout<<robust[i];}std::cout<<"],\"pinned_checks\":[";for(size_t i=0;i<pinned.size();++i){if(i)std::cout<<',';std::cout<<pinned[i];}std::cout<<']';
  if(detail&&qs.size()>=75){std::cout<<",\"q75\":";vec(qs[74]);std::cout<<",\"tail_decisions\":[";for(size_t k=74;k<xs.size();++k){if(k!=74)std::cout<<',';std::cout<<'\"'<<xs[k]<<'\"';}std::cout<<']';}
  if(detail){std::cout<<",\"error\":\""<<error<<"\",\"target\":[";for(int c=0;c<m;++c){if(c)std::cout<<',';std::cout<<s[c];}std::cout<<']';
   if(period){std::cout<<",\"cycle_states\":[";for(int k=start-1;k<repeat;++k){if(k!=start-1)std::cout<<',';vec(qs[k]);}std::cout<<"],\"cycle_decisions\":[";for(int k=start-1;k<repeat;++k){if(k!=start-1)std::cout<<',';std::cout<<'\"'<<xs[k]<<'\"';}std::cout<<']';}
   if(box_check>=0){std::cout<<",\"box\":[";for(size_t e=0;e<box.size();++e){if(e)std::cout<<',';std::cout<<'['<<box[e].first<<','<<box[e].second<<']';}std::cout<<"],\"box_bits\":\""<<box_bits<<'\"';}
  }
  std::cout<<"}\n";
 }
 return std::cin.fail()?2:0;
}
