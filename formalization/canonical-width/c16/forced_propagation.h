// Necessary full-frame propagation, with prescribed X basis members.
// Keep forced pairs in the active pools: both full pools always need rank D.
// For any mandatory independent set M, the opposite zero pool must span
// ann(M), and each of that pool's coloops is also mandatory.
struct ForcedPropagation {
 const std::vector<U>& X;const std::vector<U>& Z;int D;
 std::vector<Bits> xa,za;
 ForcedPropagation(const std::vector<U>&x,const std::vector<U>&z,int d):X(x),Z(z),D(d),xa(x.size()),za(z.size()){
  for(int i=0;i<(int)X.size();++i)for(int j=0;j<(int)Z.size();++j)if(dot(X[i],Z[j])){xa[i].set(j);za[j].set(i);}
 }
 struct Result{bool possible=true;Bits x,z,mx,mz;int rounds=0;std::string reason;};
 static void join(Bits&a,const Bits&b){for(int w=0;w<Bits::NW;++w)a.w[w]|=b.w[w];}
 static int overlap(const Bits&a,const Bits&b){int n=0;for(int w=0;w<Bits::NW;++w)n+=pop2(a.w[w]&b.w[w]);return n;}
 static bool subset(const Bits&a,const Bits&b){for(int w=0;w<Bits::NW;++w)if(a.w[w]&~b.w[w])return false;return true;}
 Result run(Bits requiredX,Bits requiredZ={})const{
  Result r;r.x.fill(X.size());r.z.fill(Z.size());r.mx=requiredX;r.mz=requiredZ;
  auto reject=[&](const char*why){r.possible=false;r.reason=why;};
  while(r.possible){
   ++r.rounds;int before=r.x.count()+r.z.count()-r.mx.count()-r.mz.count();
   if(!subset(r.mx,r.x)||!subset(r.mz,r.z)){reject("mandatory_removed");break;}
   auto ix=ColoopQuotient::info(X,r.x),iz=ColoopQuotient::info(Z,r.z);
   if(ix.rank!=D||iz.rank!=D){reject("full_pool_rank");break;}
   join(r.mx,ix.mandatory);join(r.mz,iz.mandatory);
   auto tx=ColoopQuotient::info(X,r.mx),tz=ColoopQuotient::info(Z,r.mz);
   if(tx.rank!=r.mx.count()||tz.rank!=r.mz.count()){reject("mandatory_dependent");break;}
   Bits zeroZ,zeroX;
   r.z.each([&](int j){if(!overlap(za[j],r.mx))zeroZ.set(j);});
   r.x.each([&](int i){if(!overlap(xa[i],r.mz))zeroX.set(i);});
   auto zx=ColoopQuotient::info(X,zeroX),zz=ColoopQuotient::info(Z,zeroZ);
   if(zx.rank!=D-r.mz.count()||zz.rank!=D-r.mx.count()){reject("zero_pool_rank");break;}
   join(r.mx,zx.mandatory);join(r.mz,zz.mandatory);
   std::vector<int> pairX(X.size(),-1),pairZ(Z.size(),-1);
   r.mx.each([&](int i){Bits hits=xa[i];hits.keep(r.mz);if(hits.count()>1)reject("mandatory_multiple_partners");
    hits.each([&](int j){if(pairZ[j]>=0&&pairZ[j]!=i)reject("mandatory_multiple_partners");pairX[i]=j;pairZ[j]=i;});});
   if(!r.possible)break;
   Bits xx=r.x,zzactive=r.z;
   r.x.each([&](int i){if(overlap(xa[i],r.mz)>1){xx.reset(i);return;}
    Bits hits=xa[i];hits.keep(r.mz);hits.each([&](int j){if(pairZ[j]>=0&&pairZ[j]!=i)xx.reset(i);});});
   r.z.each([&](int j){if(overlap(za[j],r.mx)>1){zzactive.reset(j);return;}
    Bits hits=za[j];hits.keep(r.mx);hits.each([&](int i){if(pairX[i]>=0&&pairX[i]!=j)zzactive.reset(j);});});
   r.x=xx;r.z=zzactive;
   int after=r.x.count()+r.z.count()-r.mx.count()-r.mz.count();
   if(after==before)break;
   if(after>before){reject("internal_nonmonotone");break;}
  }
  return r;
 }
};
