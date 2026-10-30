"""Compare independent graph/decoder implementations with historical source."""
import argparse,ast,hashlib,json,pathlib,sys,types,warnings
import numpy as np
from engine import lattice,make_decoders

def historical(path):
    import qecsim.model
    np.product=np.prod  # Removed NumPy alias used by 2021 source; no algorithm change.
    for name,directory in [('bn3d',path/'bn3d'),('bn3d.tc3d',path/'bn3d/tc3d')]:
        package=types.ModuleType(name);package.__path__=[str(directory)];sys.modules[name]=package
    from bn3d.tc3d._toric_code_3d import ToricCode3D
    source=path/'bn3d/bp_os_decoder.py'
    tree=ast.parse(source.read_text());tree.body=[node for node in tree.body if isinstance(node,(ast.Import,ast.ImportFrom,ast.FunctionDef))]
    namespace={};exec(compile(tree,str(source),'exec'),namespace)
    return ToricCode3D,namespace

def main():
    p=argparse.ArgumentParser();p.add_argument('source');p.add_argument('output');args=p.parse_args()
    C,reference=historical(pathlib.Path(args.source));rng=np.random.default_rng(73104);records=[]
    warnings.filterwarnings('ignore',category=RuntimeWarning)
    for L in (2,3,4):
        g=lattice(L);c=C(L);n=3*L**3
        assert np.array_equal(g[0],c.Hx);assert np.array_equal(g[1],c.Hz)
        assert np.array_equal(g[2],c.logical_xs[:,:n]);assert np.array_equal(g[3],c.logical_zs[:,n:])
        assert not np.any(g[0]@g[1].T%2)
        for deformation in (False,True):
            decoders=make_decoders(g,.08,deformation)
            differing=0;max_probability_difference=0.
            for _ in range(20):
                err=(rng.random(n)<.08).astype(np.uint8)
                for decoder in decoders:
                    syndrome=decoder.sparse@err%2
                    correction,_=decoder.decode(syndrome)
                    old=reference['bp_osd_decoder'](decoder.H.astype(int),syndrome.astype(int),decoder.p,max_bp_iter=10).astype(np.uint8)
                    differing+=int(not np.array_equal(old,correction))
            records.append(dict(L=L,deformed=deformation,syndromes=40,correction_mismatches=differing,graph_equal=True))
    pathlib.Path(args.output).write_text(json.dumps({'records':records,'shared':'Same source definitions, same error vectors and NumPy; graph generation, sparse message layout, and integer OSD elimination independently implemented. Historical source imports qecsim 1.0b9. Not an independent end-to-end simulation.','passed':all(x['correction_mismatches']==0 for x in records)},indent=2)+'\n')
    print(records)
if __name__=='__main__':main()
