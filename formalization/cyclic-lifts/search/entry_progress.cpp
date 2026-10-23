// Analytical first-round gate (Lean-checked scalar threshold), no later updates.
#include <cassert>
std::string first_gate(const Tanner&h,const std::vector<int>&s){
 std::string x(h.n,'0');
 for(int v=0;v<h.n;++v){assert(h.ve[v].size()==3);bool negative=true;for(int e:h.ve[v]){
  int c=0;while(std::find(h.ce[c].begin(),h.ce[c].end(),e)==h.ce[c].end())++c;
  negative&=s[c];
 }x[v]=negative?'1':'0';}
 return x;
}
int main(){
 std::ios::sync_with_stdio(false);std::cin.tie(nullptr);
 int n,mo,mm,trials,a,b;if(!(std::cin>>n>>mo>>mm>>trials>>a>>b))return 1;
 Tanner o(n,mo),m(n,mm);for(Tanner*h:{&o,&m})for(int c=0;c<h->m;++c){int d;std::cin>>d;for(int j=0;j<d;++j){int v;std::cin>>v;h->edge(c,v);}}
 // Incidence-to-check lookup avoids searching the rows in the hot loop.
 std::vector<int>oc(o.variable.size()),mc(m.variable.size());for(int c=0;c<mo;++c)for(int e:o.ce[c])oc[e]=c;for(int c=0;c<mm;++c)for(int e:m.ce[c])mc[e]=c;
 for(int t=0;t<trials;++t){int index;std::string error;std::cin>>index>>error;auto so=o.syndrome(error),sm=m.syndrome(error);std::string xo(n,'0'),xm(n,'0');
  for(int v=0;v<n;++v){bool bo=true,bm=true;assert(o.ve[v].size()==3&&m.ve[v].size()==3);for(int e:o.ve[v])bo&=so[oc[e]];for(int e:m.ve[v])bm&=sm[mc[e]];xo[v]=bo?'1':'0';xm[v]=bm?'1':'0';}
  auto wo=o.syndrome(xo),wm=o.syndrome(xm);int x=0,z=0,initial=0,changed=0;for(int c=0;c<mo;++c){x+=wo[c]!=so[c];z+=wm[c]!=so[c];initial+=so[c];}
  for(int v=0;v<n;++v)changed+=xo[v]!=xm[v];
  std::cout<<index<<' '<<std::count(error.begin(),error.end(),'1')<<' '<<initial<<' '<<x<<' '<<z<<' '<<so[a]<<' '<<so[b]<<' '<<changed<<'\n';
 }
 return std::cin.fail()?2:0;
}
