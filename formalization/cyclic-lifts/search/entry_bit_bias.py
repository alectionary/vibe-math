"""Exact physical-bit convolution for first-decision bit-error bias.

No new random errors. All 24 source vertices are checked in the original
physical coordinates. Full syndrome-weight expectation remains separate.
"""
from pathlib import Path
from fractions import Fraction
import itertools,json,time
import benchmark_decoding as b
from develop_loop_mechanisms import codes
HERE=Path(__file__).resolve().parent

def run():
 start=time.monotonic();records=[];p=Fraction(1,25)
 for name,code in codes().items():
  rows=code['original'];a,z=code['pair'];details=[]
  for own,opposite in [(a,z),(z,a)]:
   for v in rows[own]:
    common=[j for j,row in enumerate(rows) if v in row and j!=own];assert len(common)==2
    masks=[1<<v,b.rowmask(rows[own]),b.rowmask(rows[opposite])]+[b.rowmask(rows[j]) for j in common]
    rem=masks[1]^masks[0];assert bin(rem).count('1')==5
    assert all(not(rem&m) for m in masks[2:])
    probabilities={0:Fraction(1)}
    for physical in range(252):
     contribution=sum(((m>>physical)&1)<<j for j,m in enumerate(masks))
     if not contribution:continue
     out={}
     for word,mass in probabilities.items():
      out[word]=out.get(word,0)+(1-p)*mass
      out[word^contribution]=out.get(word^contribution,0)+p*mass
     probabilities=out
    assert sum(probabilities.values())==1
    counts={-1:Fraction(0),0:Fraction(0),1:Fraction(0)}
    for word,mass in probabilities.items():
     e,sa,sb,s1,s2=[(word>>j)&1 for j in range(5)]
     old=sa&s1&s2;new=(sa^sb)&s1&s2
     delta=(new^e)-(old^e);counts[delta]+=mass
    gap=counts[1]-counts[-1]
    gate=Fraction(253967631598958030208,23283064365386962890625)
    assert gap==gate*Fraction(23,25)**5
    assert counts[1]+counts[-1]==gate
    details.append(dict(vertex=v,own_check=own,opposite_check=opposite,common_checks=common,
       exact_gap=[gap.numerator,gap.denominator],expected_gap=float(gap),
       harmful_probability=float(counts[1]),improving_probability=float(counts[-1]),
       harmful_fraction_given_changed=float(counts[1]/gate),
       exact_probability_by_error_change={str(k):[x.numerator,x.denominator] for k,x in counts.items()}))
  total=sum(Fraction(*d['exact_gap']) for d in details)
  records.append(dict(design=name,vertices=details,exact_expected_total_bit_error_gap=[total.numerator,total.denominator],expected_total_bit_error_gap=float(total)))
  print(name,'exact initial expected additional wrong bits',float(total),flush=True)
 out=dict(status='exact_first_bit_error_bias_by_independent_physical_convolution',new_noise_patterns=0,
    vertices_checked=sum(len(r['vertices']) for r in records),records=records,
    interpretation='First-update bit errors, not quantum FER, syndrome acceptance or eventual failure. Lean signed moments are checked separately; the actual decision-to-moment mapping is computational and algebraic.',elapsed_seconds=time.monotonic()-start)
 (HERE/'entry-bit-bias.json').write_text(json.dumps(out,indent=2)+'\n')
if __name__=='__main__':run()
