"""Generate explicit finite certificates; Lean checks identities and every codeword."""
import json, argparse
import research as r

def xor(xs,zero='false'):
 out=zero
 for x in reversed(list(xs)):out=f'({x} ^^ {out})'
 return out
def dotproof(mask,n=44):
 expr=xor(f'({str(bool(mask>>i&1)).lower()} && x.getLsbD {i})' for i in range(n))
 return f'  change {expr} = _\n  simp only [Bool.false_and, Bool.true_and, Bool.false_xor, Bool.xor_false, Bool.xor_assoc]\n'

ap=argparse.ArgumentParser()
ap.add_argument('--input',default='counterexample.json')
ap.add_argument('--output',default='Source11')
ap.add_argument('--namespace',default='Source11')
ap.add_argument('--enum-import',default='ClassicalEnum11')
ap.add_argument('--certificate-namespace',default='ClassicalCertificate11')
args=ap.parse_args()
c=json.loads((r.ROOT/args.input).read_text());E=c['E'];L=11;H=r.classical(E,L);bs=c['classical_basis']
red=H[:];T=[1<<i for i in range(33)];pivs=[];p=0
for j in range(44):
 k=next((i for i in range(p,33) if red[i]>>j&1),None)
 if k is None:continue
 red[k],red[p]=red[p],red[k];T[k],T[p]=T[p],T[k]
 for i in range(33):
  if i!=p and red[i]>>j&1:red[i]^=red[p];T[i]^=T[p]
 pivs.append(j);p+=1
free=[i for i in range(44) if i not in pivs]
maskset=set([1<<i for i in range(44)]+[red[i]^(1<<j) for i,j in enumerate(pivs)])
s='import ClassicalEnum11\nimport Mathlib.Tactic.IntervalCases\nimport Mathlib.Tactic.FinCases\nset_option maxHeartbeats 0\nset_option maxRecDepth 100000\nnamespace Source11\nopen BinaryWords ClassicalCertificate11\n'
s+='def exponents : List (List Nat) := '+str(E)+'\n'
s+='def exponent (i j : Nat) : Nat := (exponents.getD i []).getD j 0\n'
s+='def bits {n : Nat} (is : List Nat) : BitVec n := is.foldr (fun i x => BitVec.ofNat n (2^i) ^^^ x) 0\n'
s+='def classicalRow (c : Fin 33) : BitVec 44 := bits ((List.range 4).map (fun j => 11*j+(c.val%11+11-exponent (c.val/11) j)%11))\n'
s+='def ClassicalKernel (x : BitVec 44) : Prop := ∀ i, dot (classicalRow i) x = false\n'
for mask in sorted(maskset):
 s+=f'theorem mask_{mask} (x : BitVec 44) : dot {mask}#44 x = '+xor(f'x.getLsbD {i}' for i in r.bit_indices(mask))+' := by\n'+dotproof(mask)
for i in range(44):
 expr=xor(f'c.getLsbD {j}' for j,b in enumerate(bs) if b>>i&1)
 s+=f'theorem encode_bit_{i} (c : BitVec 13) : (encode c).getLsbD {i} = {expr} := by\n'
 s+='  simp only [encode, BitVec.getLsbD_xor, getLsbD_bool_ite]\n'
 terms=[f'(c.getLsbD {j} && {str(bool(b>>i&1)).lower()})' for j,b in enumerate(bs)]
 s+='  change ('+' ^^ '.join(terms)+') = _\n'
 s+='  simp only [Bool.and_false, Bool.and_true, Bool.false_xor, Bool.xor_false, Bool.xor_assoc]\n'
s+='def freeInput (x : BitVec 44) : BitVec 13 := BitVec.ofBoolListLE ['+', '.join(f'x.getLsbD {i}' for i in free)+']\n'
s+='theorem kernel_reconstruct (x : BitVec 44) (h : ClassicalKernel x) : x = encode (freeInput x) := by\n'
for i,j in enumerate(pivs):
 fm=red[i]^(1<<j);ids=list(r.bit_indices(T[i]))
 expr=xor(f'x.getLsbD {k}' for k in r.bit_indices(fm))
 s+=f'  have h{j} : x.getLsbD {j} = {expr} := by\n'
 s+=f'    have he : rowSum classicalRow ({ids} : List (Fin 33)) = {1<<j}#44 ^^^ {fm}#44 := by decide +kernel\n'
 s+=f'    have hh := equation_of_row_relation classicalRow x {1<<j}#44 {fm}#44 h {ids} he\n'
 s+=f'    simpa only [mask_{1<<j}, mask_{fm}, Bool.xor_false] using hh\n'
s+='  apply BitVec.eq_of_getLsbD_eq\n  intro i hi\n  interval_cases i\n'
for i in range(44):
 s+=f'  · rw [encode_bit_{i}]\n    simp only [freeInput, BitVec.getLsbD_ofBoolListLE, List.getD_cons_zero, List.getD_cons_succ]\n'
 s+='    '+(f'simpa only [Bool.xor_false] using h{i}' if i in pivs else 'simp only [Bool.xor_false]')+'\n'
s+='\n#print axioms kernel_reconstruct\nend Source11\n'
s=s.replace('ClassicalEnum11',args.enum_import).replace('ClassicalCertificate11',args.certificate_namespace).replace('Source11',args.namespace)
(r.ROOT/(args.output+'.lean')).write_text(s)
