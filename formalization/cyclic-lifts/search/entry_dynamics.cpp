// Read-only diagnostics. The frozen decoder is included by entry_dynamics.py.
#include <cassert>
int64_t local_check(bool s,const std::vector<int64_t>&q,const std::vector<int>&es,int excluded){
 int sign=s?-1:1;int64_t mag=1000*scale;
 for(int e:es)if(e!=excluded){if(q[e]<0)sign=-sign;mag=std::min(mag,std::abs(q[e]));}
 return clip(sign*((800*mag+500)/1000));
}
int weight(const Tanner&h,const std::vector<int>&s,const std::string&x){auto a=h.syndrome(x);int w=0;for(int c=0;c<h.m;++c)w+=a[c]!=s[c];return w;}
int main(){
 std::ios::sync_with_stdio(false);std::cin.tie(nullptr);
 int n,mo,mm,trials,limit,ia,ib;double alpha;
 if(!(std::cin>>n>>mo>>mm>>trials>>limit>>alpha>>ia>>ib))return 1;
 assert(n==252&&mo==126&&mm==125&&limit==100&&alpha==.8&&ia<ib);
 Tanner a(n,mo),z(n,mm);
 for(Tanner*h:{&a,&z})for(int c=0;c<h->m;++c){int d;std::cin>>d;for(int j=0;j<d;++j){int v;std::cin>>v;h->edge(c,v);}}
 std::vector<int> map(a.variable.size(),-1),source,edgecheck(a.variable.size());
 for(int c=0;c<mo;++c)for(int e:a.ce[c]){
  int nc=c==ib?ia:c>ib?c-1:c;
  for(int f:z.ce[nc])if(a.variable[e]==z.variable[f])map[e]=f;
  edgecheck[e]=c;assert(map[e]>=0);if(c==ia||c==ib)source.push_back(e);
 }
 assert(source.size()==12);
 for(int t=0;t<trials;++t){
  int index;double p;std::string error;std::cin>>index>>p>>error;assert(p==.04);
  std::vector<Snapshot>ta,tz;auto s=a.syndrome(error);
  active_states=&ta;auto oa=decode(a,s,p,limit,alpha);
  active_states=&tz;auto oz=decode(z,z.syndrome(error),p,limit,alpha);active_states=nullptr;
  assert(oa.matched!=oz.matched);
  std::cout<<"{\"index\":"<<index<<",\"original\":["<<oa.iterations<<','<<oa.matched<<",\""<<oa.estimate<<"\"],\"merged\":["<<oz.iterations<<','<<oz.matched<<",\""<<oz.estimate<<"\"],\"steps\":[";
  int sumo=0,summ=0,sums=0;
  int steps=std::min(25,std::min(oa.iterations,oz.iterations));
  std::vector<std::vector<int>>osyn,msyn;
  for(int k=0;k<steps;++k){osyn.push_back(a.syndrome(ta[k].estimate));msyn.push_back(a.syndrome(tz[k].estimate));}
  for(int k=0;k<steps;++k){
   const auto &o=ta[k],&m=tz[k];std::vector<int64_t>qm(map.size());for(size_t e=0;e<map.size();++e)qm[e]=m.q[map[e]];
   std::string split=m.estimate;int changed=0;int64_t forcing=0,propagated=0;
   for(int e:source){
    int c=std::find(a.ce[ia].begin(),a.ce[ia].end(),e)!=a.ce[ia].end()?ia:ib;
    int v=a.variable[e];auto r=local_check(s[c],qm,a.ce[c],e);int64_t post=3332431;
    for(int f:a.ve[v])post+=f==e?r:m.r[map[f]];
    split[v]=post<0?'1':'0';changed+=split[v]!=m.estimate[v];
   }
   auto so=a.syndrome(o.estimate),sm=a.syndrome(m.estimate);int wo=weight(a,s,o.estimate),wm=weight(a,s,m.estimate),ws=weight(a,s,split);
   sumo+=wo;summ+=wm;sums+=ws;
   int disagree=0,splitdisagree=0,flipo=0,flipm=0,marginlo=0,marginlm=0;
   for(int v=0;v<n;++v){
    disagree+=o.estimate[v]!=m.estimate[v];splitdisagree+=o.estimate[v]!=split[v];
    if(k){flipo+=o.estimate[v]!=ta[k-1].estimate[v];flipm+=m.estimate[v]!=tz[k-1].estimate[v];}
    int64_t op=3332431,mp=3332431;for(int e:a.ve[v]){op+=o.r[e];mp+=m.r[map[e]];}
    marginlo+=std::abs(op)<3332431/4;marginlm+=std::abs(mp)<3332431/4;
   }
   for(size_t e=0;e<map.size();++e){
    int c=edgecheck[e];
    // Exact original update on merged input, including common edges.
    auto r=local_check(s[c],qm,a.ce[c],int(e));
    forcing+=std::abs(m.r[map[e]]-r);propagated+=std::abs(r-o.r[e]);
   }
   int pinnedo=0,pinnedm=0;
   for(int c=0;c<mo;++c){
    bool all_o=true,all_m=true;for(int j=std::max(0,k-4);j<=k;++j){all_o&=osyn[j][c]!=s[c];all_m&=msyn[j][c]!=s[c];}
    pinnedo+=all_o;pinnedm+=all_m;
   }
   assert((wm-wo)==(wm-ws)+(ws-wo));
   if(k)std::cout<<',';
   std::cout<<'['<<wo<<','<<wm<<','<<ws<<','<<sumo<<','<<summ<<','<<sums<<','<<changed<<','<<disagree<<','<<splitdisagree<<','<<flipo<<','<<flipm<<','<<pinnedo<<','<<pinnedm<<','<<marginlo<<','<<marginlm<<','<<forcing<<','<<propagated<<']';
  }
  std::cout<<"]}\n";
 }
 return std::cin.fail()?2:0;
}
