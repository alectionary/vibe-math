import CubicDistance
namespace Pesah.Potential

def inputPotential (L seed x y z : Nat) : Bool :=
  decide (((x%L)*17+(y%L)*11+(z%L)*7+(x%L)*(y%L)*3+seed*13) % 5 = 0)
def exampleField (L seed : Nat) (a b c : Bool) : Cochain :=
  let u := inputPotential L seed
  ⟨(fun x y z => (u (x+1) y z ^^ u x y z) ^^ seam L a x),
   (fun x y z => (u x (y+1) z ^^ u x y z) ^^ seam L b y),
   (fun x y z => (u x y (z+1) ^^ u x y z) ^^ seam L c z)⟩
def bit (b : Bool) : String := if b then "1" else "0"
def main : IO Unit := do
  for L in [2,3,4,5,6] do
    for seed in [0,1] do
      for a in [false,true] do
        for b in [false,true] do
          for c in [false,true] do
            let e := exampleField L seed a b c
            let h := Holonomy L e
            IO.println s!"C {L} {seed} {bit a}{bit b}{bit c} {bit h.1}{bit h.2.1}{bit h.2.2} {edgeWeight e L}"
            for x in List.range (L+1) do
              for y in List.range (L+1) do
                IO.println (String.join ((List.range (L+1)).map fun z => bit (potential e.x e.y e.z x y z)))
end Pesah.Potential
def main := Pesah.Potential.main
