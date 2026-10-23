// Appended to read-only-instrumented original minsum.cpp. Diagnostics only.
#include <cassert>
#include <set>

struct Local {
  int variable,own;bool sa,sb,effective_other;
  std::vector<int64_t> xs,ys,other;
  int64_t old_message,new_message,old_post,new_post;
};
int64_t message(bool syndrome,const std::vector<int64_t>&xs) {
  int sign=syndrome?-1:1;int64_t mag=1000*scale;
  for(int64_t x:xs){if(x<0)sign=-sign;mag=std::min(mag,std::abs(x));}
  return clip(sign*((800*mag+500)/1000));
}
bool signs(bool s,const std::vector<int64_t>&xs){for(auto x:xs)s^=x<0;return s;}
void array(const std::vector<int64_t>&a){std::cout<<'[';for(size_t i=0;i<a.size();++i){if(i)std::cout<<',';std::cout<<a[i];}std::cout<<']';}
void local_json(const Local&w) {
  std::cout<<"{\"variable\":"<<w.variable<<",\"own_check\":"<<w.own<<",\"own_syndrome\":"<<w.sa
    <<",\"other_syndrome\":"<<w.sb<<",\"effective_other\":"<<w.effective_other<<",\"xs\":";array(w.xs);
  std::cout<<",\"ys\":";array(w.ys);std::cout<<",\"other_variable_messages\":";array(w.other);
  std::cout<<",\"split_message\":"<<w.old_message<<",\"merged_message\":"<<w.new_message
    <<",\"split_posterior\":"<<w.old_post<<",\"merged_posterior\":"<<w.new_post<<'}';
}

int main() {
  std::ios::sync_with_stdio(false);std::cin.tie(nullptr);
  int n,mo,mm,trials,limit,ia,ib;double alpha;
  if(!(std::cin>>n>>mo>>mm>>trials>>limit>>alpha>>ia>>ib))return 1;
  assert(n==252&&mo==126&&mm==125&&limit==100&&alpha==.8&&ia<ib);
  Tanner a(n,mo),z(n,mm);
  for(Tanner*h:{&a,&z})for(int c=0;c<h->m;++c){int d;std::cin>>d;for(int j=0;j<d;++j){int v;std::cin>>v;h->edge(c,v);}}
  std::vector<int> mapping(a.variable.size(),-1),inverse(z.variable.size(),-1),source_edges;
  for(int c=0;c<mo;++c)for(int e:a.ce[c]) {
    int nc=c==ib?ia:c>ib?c-1:c;
    for(int f:z.ce[nc])if(a.variable[e]==z.variable[f]){mapping[e]=f;assert(inverse[f]<0);inverse[f]=e;}
    assert(mapping[e]>=0);if(c==ia||c==ib)source_edges.push_back(e);
  }
  assert(source_edges.size()==12&&a.variable.size()==z.variable.size());
  for(int v=0;v<n;++v){std::set<int>mapped;for(int e:a.ve[v])mapped.insert(mapping[e]);assert(mapped==std::set<int>(z.ve[v].begin(),z.ve[v].end()));}
  auto locals=[&](const Snapshot&state,bool state_is_merged,const std::vector<int>&s) {
    std::vector<Local>out;
    for(int e:source_edges) {
      int c=std::find(a.ce[ia].begin(),a.ce[ia].end(),e)!=a.ce[ia].end()?ia:ib;int other=c==ia?ib:ia;
      int v=a.variable[e];Local w;w.variable=v;w.own=c;w.sa=s[c];w.sb=s[other];
      auto q=[&](int edge){return state.q[state_is_merged?mapping[edge]:edge];};
      for(int f:a.ce[c])if(f!=e)w.xs.push_back(q(f));
      for(int f:a.ce[other])w.ys.push_back(q(f));
      w.effective_other=signs(w.sb,w.ys);
      w.old_message=message(w.sa,w.xs);auto combined=w.xs;combined.insert(combined.end(),w.ys.begin(),w.ys.end());
      w.new_message=message(w.sa^w.sb,combined);
      for(int f:a.ve[v])if(f!=e)w.other.push_back(state.r[state_is_merged?mapping[f]:f]);
      w.old_post=w.new_post=std::llround(std::log(24.)*scale);
      for(auto r:w.other){w.old_post+=r;w.new_post+=r;}
      w.old_post+=w.old_message;w.new_post+=w.new_message;
      if(state_is_merged)assert(state.r[mapping[e]]==w.new_message&&((w.new_post<0)==(state.estimate[v]=='1')));
      else assert(state.r[e]==w.old_message&&((w.old_post<0)==(state.estimate[v]=='1')));
      assert(std::abs(w.new_message)<=std::abs(w.old_message));out.push_back(w);
    }
    return out;
  };
  for(int t=0;t<trials;++t) {
    int index;double p;std::string error;std::cin>>index>>p>>error;assert(p==.04&&(int)error.size()==252);
    std::vector<Snapshot>ta,tz;auto s=a.syndrome(error);
    active_states=&ta;auto oa=decode(a,s,p,limit,alpha);
    active_states=&tz;auto oz=decode(z,z.syndrome(error),p,limit,alpha);active_states=nullptr;
    assert(ta.size()==size_t(oa.iterations)&&tz.size()==size_t(oz.iterations));
    assert(oa.matched!=oz.matched); // Frozen selection contains only syndrome-status discordances.
    int first=-1,first_hard=-1,sign_count=0,atten_count=0;Local first_witness{};
    for(size_t k=0;k<std::min(ta.size(),tz.size());++k) {
      if(first_hard<0&&ta[k].estimate!=tz[k].estimate)first_hard=k+1;
      if(first>=0)continue;
      assert(ta[k].q.size()==tz[k].q.size());
      for(size_t e=0;e<mapping.size();++e)assert(ta[k].q[e]==tz[k].q[mapping[e]]);
      bool differs=false;for(size_t e=0;e<mapping.size();++e)differs|=ta[k].r[e]!=tz[k].r[mapping[e]];
      if(!differs)continue;first=k+1;auto ws=locals(ta[k],false,s);
      for(size_t e=0;e<mapping.size();++e)if(std::find(source_edges.begin(),source_edges.end(),e)==source_edges.end())assert(ta[k].r[e]==tz[k].r[mapping[e]]);
      bool saved=false;
      for(const auto&w:ws) {
        int e=-1;for(int f:a.ce[w.own])if(a.variable[f]==w.variable)e=f;
        assert(e>=0&&ta[k].r[e]==w.old_message&&tz[k].r[mapping[e]]==w.new_message);
        bool sign=(w.old_message<0&&w.new_message>0)||(w.old_message>0&&w.new_message<0);
        bool attenuation=std::abs(w.new_message)<std::abs(w.old_message);
        if(w.old_message!=w.new_message){assert(sign||attenuation);if(!saved){first_witness=w;saved=true;}}
        sign_count+=sign;atten_count+=attenuation;
      }
      assert(sign_count||atten_count);
    }
    assert(first>0&&first_hard>=first);
    int onset=sign_count?(atten_count?3:1):2;
    int old_alternative_first=0,merged_alternative_first=0;bool old_acceptance_destroyed=false,merged_acceptance_requires=false;
    int harmful_rounds=0,beneficial_rounds=0,harmful_variables=0,beneficial_variables=0;
    std::vector<Local>obstruction;std::string split_decision,merged_decision;int obstruction_step=0;bool obstruction_from_old=false;
    for(int which=0;which<2;++which) {
      auto &states=which?tz:ta;const auto &result=which?oz:oa;
      for(size_t k=0;k<states.size();++k) {
        auto ws=locals(states[k],which,s);std::string alternative=states[k].estimate;
        bool harmful=false,beneficial=false;
        for(const auto&w:ws) {
          bool actual=which?w.new_post<0:w.old_post<0;bool counterfactual=which?w.old_post<0:w.new_post<0;
          alternative[w.variable]=counterfactual?'1':'0';
          if(which&&actual!=counterfactual){bool wrong=actual!=(error[w.variable]=='1');harmful|=wrong;beneficial|=!wrong;harmful_variables+=wrong;beneficial_variables+=!wrong;}
        }
        bool accepted=a.syndrome(alternative)==s;
        if(which){harmful_rounds+=harmful;beneficial_rounds+=beneficial;if(accepted&&!merged_alternative_first)merged_alternative_first=k+1;}
        else if(accepted&&!old_alternative_first)old_alternative_first=k+1;
        if(k+1==states.size()&&result.matched&&!accepted) {
          if(which)merged_acceptance_requires=true;else old_acceptance_destroyed=true;
          obstruction=ws;obstruction_from_old=!which;obstruction_step=k+1;
          split_decision=which?alternative:states[k].estimate;merged_decision=which?states[k].estimate:alternative;
        }
      }
    }
    std::cout<<"{\"index\":"<<index<<",\"original\":["<<oa.iterations<<','<<oa.matched<<",\""<<oa.estimate<<"\"],\"merged\":["<<oz.iterations<<','<<oz.matched<<",\""<<oz.estimate<<"\"],"
      <<"\"first_message\":"<<first<<",\"first_hard\":"<<first_hard<<",\"onset\":"<<onset<<",\"sign_edges\":"<<sign_count<<",\"attenuation_edges\":"<<atten_count
      <<",\"original_acceptance_destroyed\":"<<old_acceptance_destroyed<<",\"merged_acceptance_requires_coupling\":"<<merged_acceptance_requires
      <<",\"original_path_merge_would_accept_first\":"<<old_alternative_first<<",\"merged_path_split_would_accept_first\":"<<merged_alternative_first
      <<",\"harmful_coupling_rounds\":"<<harmful_rounds<<",\"beneficial_coupling_rounds\":"<<beneficial_rounds
      <<",\"harmful_coupling_variable_events\":"<<harmful_variables<<",\"beneficial_coupling_variable_events\":"<<beneficial_variables
      <<",\"onset_witness\":";local_json(first_witness);
    std::cout<<",\"acceptance_witness\":";
    if(obstruction.empty())std::cout<<"null";
    else {
      std::cout<<"{\"from_original_state\":"<<obstruction_from_old<<",\"iteration\":"<<obstruction_step
        <<",\"split_decision\":\""<<split_decision<<"\",\"merged_decision\":\""<<merged_decision<<"\",\"locals\":[";
      for(size_t i=0;i<obstruction.size();++i){if(i)std::cout<<',';local_json(obstruction[i]);}std::cout<<"]}";
    }
    std::cout<<"}\n";
  }
  return std::cin.fail()?2:0;
}
