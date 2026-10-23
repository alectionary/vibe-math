// Appended after the frozen minsum.cpp with only decision-recording hooks.
int main() {
  std::ios::sync_with_stdio(false);std::cin.tie(nullptr);
  int n,mo,mm,trials,limit,full,ia,ib,ng;double alpha;
  if(!(std::cin>>n>>mo>>mm>>trials>>limit>>alpha>>full>>ia>>ib>>ng))return 1;
  if(n!=252||mo!=126||mm!=125||limit!=100||ia<0||ib>=mo)return 2;
  Tanner original(n,mo),merged(n,mm);
  for(Tanner *h:{&original,&merged})for(int c=0;c<h->m;++c) {
    int d;std::cin>>d;if(d<2)return 3;
    for(int j=0;j<d;++j){int v;std::cin>>v;if(v<0||v>=n)return 4;h->edge(c,v);}
  }
  std::vector<std::vector<int>> gained(ng,std::vector<int>(4));
  for(auto &s:gained)for(int &v:s)std::cin>>v;
  std::vector<bool> affected(n,false);
  for(int c:{ia,ib})for(int e:original.ce[c])affected[original.variable[e]]=true;
  for(int t=0;t<trials;++t) {
    double p;std::string error;std::cin>>p>>error;if((int)error.size()!=n)return 5;
    auto syndrome=original.syndrome(error);
    std::vector<std::string> a,z;
    saved_history=&a;auto x=decode(original,syndrome,p,limit,alpha);
    saved_history=&z;auto y=decode(merged,merged.syndrome(error),p,limit,alpha);
    saved_history=nullptr;
    if(a.size()!=size_t(x.iterations+1)||z.size()!=size_t(y.iterations+1))return 6;
    int first=-1,different=0,changed=0,inside=0;
    for(size_t it=0;it<std::min(a.size(),z.size());++it)if(a[it]!=z[it]) {
      ++different;
      if(first<0){first=it;for(int v=0;v<n;++v)if(a[it][v]!=z[it][v]){++changed;inside+=affected[v];}}
    }
    if(first<0&&a.size()!=z.size())return 7;
    if(first==1&&changed!=inside)return 8;
    bool contains=false;
    for(const auto &s:gained)if(error[s[0]]=='1'&&error[s[1]]=='1'&&error[s[2]]=='1'&&error[s[3]]=='1'){contains=true;break;}
    std::cout<<x.iterations<<' '<<x.matched<<' '<<x.estimate<<' '
             <<y.iterations<<' '<<y.matched<<' '<<y.estimate<<' '
             <<first<<' '<<different<<' '<<changed<<' '<<inside<<' '<<contains<<' '
             <<syndrome[ia]<<' '<<syndrome[ib]<<'\n';
    if(full) {
      for(size_t it=0;it<a.size();++it)std::cerr<<"O "<<it<<' '<<a[it]<<'\n';
      for(size_t it=0;it<z.size();++it)std::cerr<<"M "<<it<<' '<<z[it]<<'\n';
    }
  }
  return std::cin.fail()?9:0;
}
