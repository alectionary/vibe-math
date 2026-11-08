/- Frozen original target types from master 36c7dc91. Compile this SAME file against both builds. -/

import CertGPTPool

import CertGPTRun

import Aut

import Pools

import Code

import CertGPTNoSwap

open Matrix C16Frames.Pools C16Frames.Phys

namespace C16Frames.CertGPT

example : swapPoolsOK = true := swap_pools_ok

end C16Frames.CertGPT

namespace C16Frames.CertGPT

example : swapCertificateOK = true := swap_check_ok

end C16Frames.CertGPT

namespace C16Frames.Aut

example : ∀ i j : Fin 720,
    adj (Fin.castAdd 720 i) (Fin.natAdd 720 j) = decide (PoolBridge.G i j = 1) := adj_spec

example : ∀ u w, adj (rot1 u) (rot1 w) = adj u w := rot1_aut

example : ∀ u w, adj (swp u) (swp w) = adj u w := swp_aut

example : ∀ b k u, gmap b k (ginv b k u) = u := gmap_ginv

example : ∀ b k u, ginv b k (gmap b k u) = u := ginv_gmap

example : ∀ (b : Bool) (k : Fin 16) (u : V),
    gmap b k u = rot1^[k.1] (if b then swp u else u) := gmap_eq

example : ∀ b k b' k', gmap b k 0 = gmap b' k' 0 → b = b' ∧ k = k' := gmap_distinct

example : ∀ u : V, col cK u = col cK (0 : V) → ∃ i : Bool × Fin 16, gmap i.1 i.2 0 = u := class_v0

example : ∀ v : V, col dM v = v.1 := dM_id

example (φ : Equiv.Perm V) (hφ : ∀ u w, adj (φ u) (φ w) = adj u w) :
    ∃ b : Bool, ∃ k : Fin 16, ∀ u, φ u = gmap b k u := aut_classification φ hφ

end C16Frames.Aut

namespace C16Frames.PoolBridge

example : xArr.size = 720 := xArr_size

example : zArr.size = 720 := zArr_size

example : ∀ i : Fin 720, ∀ c : Fin 128, X (rotIdx 1 i) (rotCoord 1 c) = X i c := X_rot

example : ∀ j : Fin 720, ∀ c : Fin 128, Z (rotIdx 1 j) (rotCoord 1 c) = Z j c := Z_rot

example : ∀ i j : Fin 720, G i j = G j i := G_symm

example : ∀ i j : Fin 720, G (rotIdx 1 i) (rotIdx 1 j) = G i j := G_rot

example : Fin 720 ≃ Fin 720 := tau8

example : ∀ i : Fin 720, tau8 (tau8 i) = i := tau8_invol

example : Fin 720 ≃ Fin 720 := rotEquiv

end C16Frames.PoolBridge

namespace C16Frames.Code

example : hx.length = 480 := hx_length

example : hz.length = 480 := hz_length

example : hx.all (fun v => popc v ≤ 9) && hz.all (fun v => popc v ≤ 9) := checks_weight_le_9

example : hx.all (fun x => hz.all fun z => !par x z) := checks_commute

example : canX.length = 128 ∧ canZ.length = 128 := canon_length

example : canX.all (fun v => hz.all fun z => !par v z) &&
    canZ.all (fun v => hx.all fun x => !par x v) := canon_logical

example : ∀ c d : Fin 128, par (canX.getD c 0) (canZ.getD d 0) = (c == d) := canon_gram

example : (canX ++ canZ).all (fun v => popc v ≤ 18) &&
    (canX ++ canZ).any (fun v => popc v == 18) := canon_width

example : xPhys.length = 720 ∧ zPhys.length = 720 := pools_length

example : xPhys.all (fun v => popc v == 16) && zPhys.all (fun v => popc v == 16) := pools_weight_16

example : xPhys.all (fun v => hz.all fun z => !par v z) &&
    zPhys.all (fun v => hx.all fun x => !par x v) := pools_logical

example : xPhys.Nodup ∧ zPhys.Nodup := pools_distinct

example : xPhys.map coordX = xArr.toList ∧ zPhys.map coordZ = zArr.toList := coords_match

example : xArr.all (· != 0) && zArr.all (· != 0) := coords_nonzero

example : ∀ i j : Fin 720,
    (if par (xPhys.getD i 0) (zPhys.getD j 0) then (1 : ZMod 2) else 0) = PoolBridge.G i j := physical_pairing_eq_G

end C16Frames.Code

namespace C16Frames.CertGPT

example :
    ¬ ∃ F : Finset (Fin 720 × Fin 720),
      IsPairFrame (arrayG C16Frames.Pools.xArr C16Frames.Pools.zArr) F ∧
      F.card = 128 ∧ F.image Prod.swap = F := no_swap_frame

end C16Frames.CertGPT
