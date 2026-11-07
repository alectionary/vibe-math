import CertGPTData
open C16Frames.CertGPT

def main (args : List String) : IO UInt32 := do
  let [path, kind] := args | do
    IO.eprintln "usage: CertGPTTest INPUT swap|quarter"; return 2
  let text ← IO.FS.readFile path
  let words := text.splitOn " " |>.filter (fun s => !s.trimAscii.toString.isEmpty)
  let some nums := words.mapM (fun s => s.trimAscii.toString.toNat?) | do
    IO.eprintln "REJECT non-natural token"; return 1
  let some (d, tokens) := decode nums.toArray | do
    IO.eprintln "REJECT input structure"; return 1
  if !validateItems d kind then
    IO.eprintln "REJECT regenerated orbit mismatch"; return 1
  IO.println s!"items verified: {d.items.size}"
  let r := checkTokens d tokens
  IO.println s!"{repr r}"
  let kernel := checkViaKernel d tokens
  IO.println s!"generic kernel accepted: {kernel}"
  if r.status == "ACCEPT" && !kernel then return 1
  return if r.status == "ACCEPT" || r.status == "FRAME" then 0 else 1
