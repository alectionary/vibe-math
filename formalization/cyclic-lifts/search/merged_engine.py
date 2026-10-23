"""Instrument the original decoder by adding decision capture only."""
from pathlib import Path
import subprocess
HERE=Path(__file__).resolve().parent


def compile_engine(destination):
    source=(HERE/'minsum.cpp').read_text()
    zero='if (h.syndrome(estimate)==s) return {estimate,0,true};'
    step='if (h.syndrome(estimate)==s) return {estimate,it,true};'
    assert source.count(zero)==source.count(step)==1
    instrumented=source.replace(zero,'record_decision(estimate);\n  '+zero)
    instrumented=instrumented.replace(step,'record_decision(estimate);\n    '+step)
    prelude='#include <vector>\n#include <string>\nstd::vector<std::string>* saved_history=nullptr;\nvoid record_decision(const std::string &s){if(saved_history)saved_history->push_back(s);}\n#define main archived_single_decoder_main\n'
    path=Path(destination).with_suffix('.cpp')
    path.write_text(prelude+instrumented+'\n#undef main\n'+(HERE/'merged_pair.cpp').read_text())
    subprocess.run(['c++','-std=c++17','-O3',str(path),'-o',str(destination)],check=True)


def run_engine(binary,original,merged,pair,gained,trials,full=False):
    n=252
    data=[f'{n} {len(original)} {len(merged)} {len(trials)} 100 0.8 {int(full)} {pair[0]} {pair[1]} {len(gained)}']
    for rows in [original,merged]:data.extend(str(len(row))+' '+' '.join(map(str,row)) for row in rows)
    data.extend(' '.join(map(str,s)) for s in gained)
    data.extend(f'{p:.17g} {error}' for p,error in trials)
    process=subprocess.run([str(binary)],input='\n'.join(data)+'\n',text=True,capture_output=True,check=True)
    out=[]
    for line in process.stdout.splitlines():
        a=line.split();assert len(a)==13
        for estimate in [a[2],a[5]]:assert len(estimate)==n and set(estimate)<={'0','1'}
        out.append(dict(original=(int(a[0]),bool(int(a[1])),a[2]),merged=(int(a[3]),bool(int(a[4])),a[5]),
                        first=int(a[6]),different=int(a[7]),changed=int(a[8]),inside=int(a[9]),
                        contains=bool(int(a[10])),source_syndrome=[int(a[11]),int(a[12])]))
    assert len(out)==len(trials)
    histories={'original':[],'merged':[]}
    if full:
        assert len(trials)==1
        for line in process.stderr.splitlines():
            label,step,estimate=line.split();key={'O':'original','M':'merged'}[label]
            assert int(step)==len(histories[key]);histories[key].append(estimate)
    else:assert not process.stderr
    return out,histories
