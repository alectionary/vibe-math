import CubicIncidence
namespace Pesah

def sites (n : Nat) : List (Site n) :=
  (List.finRange (n+1)).flatMap fun x =>
    (List.finRange (n+1)).flatMap fun y =>
      (List.finRange (n+1)).map fun z => (x,y,z)
def edges (n : Nat) : List (Fin 3 × Site n) :=
  (List.finRange 3).flatMap fun a => (sites n).map fun v => (a,v)
def edgeDelta (key : Fin 3 × Site n) : Edges n := fun a v => decide ((a,v)=key)
def bit (b : Bool) : String := if b then "1" else "0"
def row (check : Edges n → Bool) : String :=
  String.join ((edges n).map fun key => bit (check (edgeDelta key)))
def main : IO Unit := do
  for n in [1,3,5] do
    IO.println s!"L {n+1}"
    for v in sites n do
      IO.println ("V " ++ row (fun e => vertexCheck e v))
    for normal in [0,1,2] do
      for v in sites n do
        IO.println ("F " ++ row (fun e => if normal=0 then faceYZ e v else if normal=1 then faceXZ e v else faceXY e v))
end Pesah
def main := Pesah.main
