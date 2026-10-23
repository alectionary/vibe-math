// Read-only first-output observer and terminal scoring bridge.
#include <cassert>
Tanner* reference_graph=nullptr;
std::vector<int> reference_target;
int first_weight=0;
void record_first(const std::string&x,int iteration){
 if(iteration!=1)return;
 auto got=reference_graph->syndrome(x);first_weight=0;
 for(size_t c=0;c<got.size();++c)first_weight+=got[c]!=reference_target[c];
}
int main(){
 std::ios::sync_with_stdio(false);std::cin.tie(nullptr);
 int n,m,mref,trials;if(!(std::cin>>n>>m>>mref>>trials))return 1;
 assert(n==252&&mref==126&&(m==125||m==126));Tanner h(n,m),ref(n,mref);
 for(Tanner*g:{&h,&ref})for(int c=0;c<g->m;++c){int d;std::cin>>d;for(int j=0;j<d;++j){int v;std::cin>>v;g->edge(c,v);}}
 reference_graph=&ref;
 for(int t=0;t<trials;++t){
  int index;std::string error;std::cin>>index>>error;
  reference_target=ref.syndrome(error);first_weight=0;
  auto r=decode(h,h.syndrome(error),.04,100,.8);
  std::cout<<index<<' '<<r.iterations<<' '<<r.matched<<' '<<r.estimate<<' '<<first_weight<<'\n';
 }
 return std::cin.fail()?2:0;
}
