// Observer for the frozen decoder. Original implementation is included unchanged.
#define main frozen_decoder_main
#include "../../cyclic-lifts/search/minsum.cpp"
#undef main
#include <map>
#include <sstream>
#include <stdexcept>

template<class T> void consistent(const std::vector<T>& values,const std::vector<int>& colors) {
  std::map<int,T> seen;
  for(size_t i=0;i<values.size();++i) {
    auto entry=seen.emplace(colors[i],values[i]);
    if(!entry.second && entry.first->second!=values[i]) throw std::runtime_error("partition violated");
  }
}
std::string wordhex(const std::string& word) {
  uint64_t mask=0;for(size_t v=0;v<word.size();++v)if(word[v]=='1')mask|=1ULL<<v;
  std::ostringstream s;s<<"0x"<<std::hex<<mask;return s.str();
}
template<class T> void arrayjson(const std::vector<T>& values) {
  std::cout<<'[';for(size_t i=0;i<values.size();++i){if(i)std::cout<<',';std::cout<<values[i];}std::cout<<']';
}
int main() {
  int n,m,trials,limit;double alpha;
  if(!(std::cin>>n>>m>>trials>>limit>>alpha))return 1;
  Tanner h(n,m);
  for(int c=0;c<m;++c){int k;std::cin>>k;while(k--){int v;std::cin>>v;h.edge(c,v);}}
  for(int trial=0;trial<trials;++trial) {
    double p;std::string error;int keep;std::cin>>p>>error>>keep;
    std::vector<int> qc(h.variable.size()),rc(qc.size()),pc(n);
    for(auto& x:qc)std::cin>>x;for(auto& x:rc)std::cin>>x;for(auto& x:pc)std::cin>>x;
    const auto target=h.syndrome(error);
    const int64_t prior=std::llround(std::log((1-p)/p)*scale),normalization=std::llround(alpha*1000);
    std::vector<int64_t> q(qc.size(),clip(prior)),r(qc.size()),post(n);
    std::map<std::vector<int64_t>,int> seen;seen[q]=0;
    int repeat_start=-1,period=0,iterations=0;bool matched=false;
    std::vector<std::string> decisions;std::vector<std::vector<int64_t>> qlog,rlog,plog;
    std::string estimate(n,'0');
    std::cout<<"{\"prior\":"<<prior;
    if(keep){std::cout<<",\"initial_q\":";arrayjson(q);}
    for(int it=1;it<=limit;++it) {
      consistent(q,qc);
      for(int c=0;c<m;++c)for(int edge:h.ce[c]) {
        int sign=target[c]?-1:1;int64_t magnitude=1000*scale;
        for(int other:h.ce[c])if(other!=edge){if(q[other]<0)sign=-sign;magnitude=std::min(magnitude,std::abs(q[other]));}
        r[edge]=clip(sign*((normalization*magnitude+500)/1000));
      }
      consistent(r,rc);
      for(int v=0;v<n;++v){post[v]=prior;for(int edge:h.ve[v])post[v]+=r[edge];estimate[v]=post[v]<0?'1':'0';}
      consistent(post,pc);
      for(size_t edge=0;edge<q.size();++edge)q[edge]=clip(post[h.variable[edge]]-r[edge]);
      consistent(q,qc);
      if(keep){qlog.push_back(q);rlog.push_back(r);plog.push_back(post);}
      decisions.push_back(wordhex(estimate));iterations=it;matched=h.syndrome(estimate)==target;
      auto pos=seen.find(q);
      if(pos!=seen.end()&&period==0){repeat_start=pos->second;period=it-pos->second;}else if(pos==seen.end())seen[q]=it;
      if(matched)break;
    }
    const auto frozen=decode(h,target,p,limit,alpha);
    if(frozen.estimate!=estimate||frozen.matched!=matched||frozen.iterations!=iterations)throw std::runtime_error("frozen decoder mismatch");
    std::cout<<",\"iterations\":"<<iterations<<",\"matched\":"<<(matched?"true":"false")<<",\"estimate_hex\":\""<<wordhex(estimate)<<"\",\"repeat_start\":"<<repeat_start<<",\"period\":"<<period<<",\"decisions_hex\":[";
    for(size_t i=0;i<decisions.size();++i){if(i)std::cout<<',';std::cout<<'"'<<decisions[i]<<'"';}std::cout<<']';
    if(keep){for(int which=0;which<3;++which){std::cout<<(which==0?",\"q_after\":[":which==1?",\"check_messages\":[":",\"posteriors\":[");auto& data=which==0?qlog:which==1?rlog:plog;for(size_t i=0;i<data.size();++i){if(i)std::cout<<',';arrayjson(data[i]);}std::cout<<']';}}
    std::cout<<"}\n";
  }
  return std::cin.fail()?2:0;
}
