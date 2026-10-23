// Temporary read-only source hooks supply Snapshot and active_states.
int main() {
  std::ios::sync_with_stdio(false);std::cin.tie(nullptr);
  int n,m,count;double p;if(!(std::cin>>n>>m>>p>>count))return 1;
  std::vector<int>requested(count);for(int&i:requested)std::cin>>i;
  Tanner h(n,m);
  for(int c=0;c<m;++c){int d;std::cin>>d;for(int i=0;i<d;++i){int v;std::cin>>v;h.edge(c,v);}}
  std::string error;std::cin>>error;std::vector<Snapshot>history;
  active_states=&history;auto result=decode(h,h.syndrome(error),p,100,.8);active_states=nullptr;
  auto array=[](const std::vector<int64_t>&x){std::cout<<'[';for(size_t i=0;i<x.size();++i){if(i)std::cout<<',';std::cout<<x[i];}std::cout<<']';};
  std::cout<<"{\"terminal\":["<<result.iterations<<','<<result.matched<<",\""<<result.estimate<<"\"],\"states\":[";
  for(size_t j=0;j<requested.size();++j){if(j)std::cout<<',';int step=requested[j];if(step<1||step>(int)history.size())return 2;
    const auto&s=history[step-1];std::cout<<"{\"iteration\":"<<step<<",\"q\":";array(s.q);std::cout<<",\"r\":";array(s.r);
    std::cout<<",\"estimate\":\""<<s.estimate<<"\"}";}
  std::cout<<"]}\n";return 0;
}
