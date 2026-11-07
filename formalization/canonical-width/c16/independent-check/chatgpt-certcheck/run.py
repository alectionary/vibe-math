#!/usr/bin/env python3
"""Build, authenticate all input bytes, gate real checks on known answers/mutations."""
import gzip, hashlib, json, pathlib, subprocess, sys, tempfile
HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent.parent
CERT = pathlib.Path('restricted-frames-20261031/certificates')
EXE = HERE / 'check'

def authenticate():
    manifest = json.loads((ROOT / CERT / 'MANIFEST.json').read_text())
    for name, expected in manifest.items():
        data = (ROOT / name).read_bytes()
        if len(data) != expected['bytes'] or hashlib.sha256(data).hexdigest() != expected['sha256']:
            raise RuntimeError('input authentication failed: ' + name)
    return manifest

def main():
    mode = sys.argv[1] if len(sys.argv)>1 else 'all'
    assert mode in ('tests', 'all', 'swap', 'half', 'swapT8')
    manifest = authenticate()  # Before parsing any pool/instance/certificate.
    subprocess.run(['g++','-O3','-std=c++17','-Wall','-Wextra',str(HERE/'check.cpp'),'-lz','-o',str(EXE)],check=True)
    out = HERE / ('results-'+mode+'.jsonl')
    with out.open('w') as log:
        def run(cls, inst, files, expected, planted=False, mutation=None):
            pools = [pathlib.Path('independent-check/inputs')/('planted1-'+s+'coords.txt') if planted else pathlib.Path('pools')/(s+'coords.txt') for s in ('x','z')]
            for path in [*pools, CERT/inst, *files]:
                if mutation and path in files:
                    continue  # Deliberate local adversarial input, never a real certificate.
                assert str(path) in manifest, 'unmanifested input'
                data=(ROOT/path).read_bytes()
                assert hashlib.sha256(data).hexdigest()==manifest[str(path)]['sha256']
            proc=subprocess.run([str(EXE),cls,*map(str,pools),str(CERT/inst),*map(str,files)],cwd=ROOT,text=True,stdout=subprocess.PIPE)
            record=json.loads(proc.stdout)
            if mutation:
                record['notes'] = 'Local derivative '+mutation+': '+record['notes']
                record['files'] = ['mutation:'+mutation]
            line=json.dumps(record,separators=(',',':'))
            print(line,flush=True);log.write(line+'\n');log.flush()
            assert record['result']==expected,(record,expected)
            assert proc.returncode==(1 if expected=='REJECT' else 0)
            return record
        quarter=run('quarter','test-quarter.inst',[CERT/'test-quarter.cert.gz'],'ACCEPT')
        assert quarter['nodes']==15088
        for i in range(1,4):run('quarter','test-quarter.inst',[CERT/f'test-bad-{i}.cert.gz'],'REJECT')
        run('quarter','test-planted.inst',[CERT/'test-planted.cert.gz'],'FRAME',planted=True)
        original=gzip.decompress((ROOT/CERT/'test-quarter.cert.gz').read_bytes()).decode().splitlines()
        mutations={}
        lines=original.copy();ix=next(i for i,s in enumerate(lines) if s.startswith('C '));del lines[ix];mutations['drop-child']=lines
        lines=original.copy();ix=next(i for i,s in enumerate(lines) if s.startswith('B '));a=lines[ix].split();a[1]='0';a[2]='1';lines[ix]=' '.join(a);mutations['change-entry']=lines
        lines=original.copy();ix=next(i for i,s in enumerate(lines) if s=='R');lines[ix]='E 0 0';mutations['R-to-E']=lines
        lines=original.copy();ix=next(i for i,s in enumerate(lines) if s.startswith('E '));lines[ix]='R';mutations['E-to-R']=lines
        lines=original.copy();ix=next(i for i,s in enumerate(lines) if s.startswith('C '));lines[ix]='C '+str(quarter['items']-1);mutations['change-item-id']=lines
        lines=original.copy();ix=next(i for i,s in enumerate(lines) if s.startswith('C '));lines[ix]=lines[ix].replace('C ','S ',1);mutations['unsharded-S']=lines
        lines=original.copy()+['R'];mutations['trailing-data']=lines
        with tempfile.TemporaryDirectory() as tmp:
            for name,lines in mutations.items():
                p=pathlib.Path(tmp)/(name+'.cert.gz');p.write_bytes(gzip.compress(('\n'.join(lines)+'\n').encode(),mtime=0))
                run('quarter','test-quarter.inst',[p],'REJECT',mutation=name)
        # Derive two root-sharded proofs from the authenticated valid quarter tree.
        def skip_node(pos):
            a=original[pos].split();pos+=1
            if a[0]=='B':
                for _ in range(int(a[3])):
                    child=original[pos].split();pos+=1
                    if child[0]=='C':pos=skip_node(pos)
            return pos
        assert original[1].startswith('B ')
        blocks=[];pos=2
        for _ in range(int(original[1].split()[3])):
            start=pos;child=original[pos].split();pos+=1
            if child[0]=='C':pos=skip_node(pos)
            blocks.append(original[start:pos])
        assert original[pos]=='END COMPLETE'
        def shard(s, owner):
            header=original[0].split();header[9]=str(s);header[11]='2';header[13]='0'
            lines=[' '.join(header),original[1]]
            for ix,block in enumerate(blocks):
                lines.extend(block if owner(ix) else ['S '+block[0].split()[1]])
            return lines+['END COMPLETE']
        with tempfile.TemporaryDirectory() as tmp:
            def fixture(name,lines):
                p=pathlib.Path(tmp)/(name+'.cert.gz');p.write_bytes(gzip.compress(('\n'.join(lines)+'\n').encode(),mtime=0));return p
            first=fixture('s0',shard(0,lambda i:i%2==0))
            second=fixture('s1',shard(1,lambda i:i%2==1))
            run('quarter','test-quarter.inst',[first,second],'ACCEPT',mutation='valid-two-shard-split')
            run('quarter','test-quarter.inst',[first],'REJECT',mutation='missing-shard')
            duplicate=fixture('duplicate-ownership',shard(1,lambda i:i%2==0))
            run('quarter','test-quarter.inst',[first,duplicate],'REJECT',mutation='duplicate-shard-ownership')
            same_id=fixture('same-id',shard(0,lambda i:i%2==1))
            run('quarter','test-quarter.inst',[first,same_id],'REJECT',mutation='duplicate-shard-id')
        if mode=='tests':return
        for cls,n in [('swap',1),('half',2),('swapT8',4)]:
            if mode not in ('all',cls):continue
            files=[CERT/f'{cls}.cert.gz'] if n==1 else [CERT/f'{cls}-s{s}of{n}.cert.gz' for s in range(n)]
            run(cls,cls+'.inst',files,'ACCEPT')
if __name__=='__main__':main()
