"""Reproduce the earliest soft divergence in retained error 2435; no new noise."""
from pathlib import Path
import json,re,sys
from develop_loop_mechanisms import codes
from merged_reference_states import states,graph
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]

def compute():
 source=(ROOT/'formalization/dyadic-rank/CyclicDecoderTubeData/MinimumHoldout.lean').read_text()
 support=list(map(int,re.search(r'def errorSupport : List Nat := \[([^]]+)\]',source).group(1).split(',')))
 error=''.join('1' if v in support else '0' for v in range(252));code=codes()['minimum_4']
 history={k:states(code[k],error)[0] for k in ['original','merged']};graphs={k:graph(code[k]) for k in history};a,z=code['pair']
 mapping=[graphs['merged']['lookup'][a if c==z else c-1 if c>z else c,v] for c,v in graphs['original']['edge']]
 edge=graphs['original']['lookup'][42,196]
 firsthard=next(t+1 for t in range(min(map(len,history.values()))) if history['original'][t]['estimate']!=history['merged'][t]['estimate'])
 result=dict(design='minimum_4',retained_error_index=2435,error_support=support,source_syndrome=[0,0],foreign_physical_vertex=196,foreign_original_edge=edge,foreign_q_after_first=history['original'][1]['q'][edge],witness_original_edge=714,witness_merged_edge=253,affected_source_check=119,witness_vertex=35,old_second_message=history['original'][1]['r'][714],merged_second_message=history['merged'][1]['r'][253],first_hard_divergence=firsthard,updates=[])
 for t in range(firsthard):
  rd=[i for i,j in enumerate(mapping) if history['original'][t]['r'][i]!=history['merged'][t]['r'][j]]
  result['updates'].append(dict(iteration=t+1,incoming_q_differences=sum(history['original'][t]['q'][i]!=history['merged'][t]['q'][j] for i,j in enumerate(mapping)),check_message_difference_edges=rd,hard_word_differences=sum(x!=y for x,y in zip(history['original'][t]['estimate'],history['merged'][t]['estimate']))))
 return result

def run():
 result=compute();path=HERE/'entry-delayed-entry.json'
 if '--verify' in sys.argv:assert result==json.loads(path.read_text());print('Retained delayed-entry data reproduce exactly; no new noise',flush=True)
 else:path.write_text(json.dumps(result,indent=2)+'\n')
if __name__=='__main__':run()
