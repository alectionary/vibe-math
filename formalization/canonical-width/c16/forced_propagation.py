"""Independent Python replay of mandatory-pool propagation (exact F_2)."""
from rank_oracle import basis,coloop_indices


def propagate(X,Z,requiredX,requiredZ=(),dimension=128):
    ax=[{j for j,z in enumerate(Z) if (x&z).bit_count()%2} for x in X]
    az=[{i for i,x in enumerate(X) if (x&z).bit_count()%2} for z in Z]
    return propagate_prepared(X,Z,ax,az,requiredX,requiredZ,dimension)


def propagate_prepared(X,Z,ax,az,requiredX,requiredZ=(),dimension=128):
    A=set(range(len(X)));B=set(range(len(Z)));MX=set(requiredX);MZ=set(requiredZ);rounds=0
    while True:
        rounds+=1;before=len(A)+len(B)-len(MX)-len(MZ)
        def result(possible,reason):return {'possible':possible,'reason':reason,'rounds':rounds,'X':sorted(A),'Z':sorted(B),'mandatory_X':sorted(MX),'mandatory_Z':sorted(MZ)}
        if not MX<=A or not MZ<=B:return result(False,'mandatory_removed')
        if len(basis(X[i] for i in A))!=dimension or len(basis(Z[j] for j in B))!=dimension:return result(False,'full_pool_rank')
        MX.update(coloop_indices(X,sorted(A)));MZ.update(coloop_indices(Z,sorted(B)))
        if len(basis(X[i] for i in MX))!=len(MX) or len(basis(Z[j] for j in MZ))!=len(MZ):return result(False,'mandatory_dependent')
        ZX=[i for i in sorted(A) if not ax[i]&MZ];ZZ=[j for j in sorted(B) if not az[j]&MX]
        if len(basis(X[i] for i in ZX))!=dimension-len(MZ) or len(basis(Z[j] for j in ZZ))!=dimension-len(MX):return result(False,'zero_pool_rank')
        MX.update(coloop_indices(X,ZX));MZ.update(coloop_indices(Z,ZZ))
        px={};pz={}
        for i in sorted(MX):
            hits=ax[i]&MZ
            if len(hits)>1:return result(False,'mandatory_multiple_partners')
            for j in hits:
                if j in pz and pz[j]!=i:return result(False,'mandatory_multiple_partners')
                px[i]=j;pz[j]=i
        A={i for i in A if len(ax[i]&MZ)<=1 and all(j not in pz or pz[j]==i for j in ax[i]&MZ)}
        B={j for j in B if len(az[j]&MX)<=1 and all(i not in px or px[i]==j for i in az[j]&MX)}
        after=len(A)+len(B)-len(MX)-len(MZ);assert after<=before
        if after==before:return result(True,'fixed_point')
