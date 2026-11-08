import Std
namespace C16Frames.PackedPrototype
/-- Balanced chunks with cached sizes; lookup recurses structurally on the tree. -/
inductive Chunks where
  | leaf (count bits : Nat)
  | node (leftCount count : Nat) (left right : Chunks)

def size : Chunks → Nat
  | .leaf n _ => n
  | .node _ n _ _ => n

def getD (width : Nat) : Chunks → Nat → Nat
  | .leaf n bits, i => if i < n then (bits >>> (width * i)) % 2^width else 0
  | .node nl _ l r, i => if i < nl then getD width l i else getD width r (i-nl)

def read (width : Nat) (t : Chunks) : Nat → Nat → List Nat
  | 0, _ => []
  | n+1, i => getD width t i :: read width t n (i+1)
end C16Frames.PackedPrototype
