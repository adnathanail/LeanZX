import ZxLean.Axioms
import ZxLean.Tactics

open Lean Elab Tactic Meta

def ZXDiagram.identityRemoval (d: ZXDiagram) (a : NodeId) : Option ZXDiagram := do
  -- Check the node being removed has no phase
  let node ← d.getNode? a
  let phase ← Node.phase? node
  guard (phase == ⟨0, 1⟩)
  -- Check the node being removed only has 2 neighbors
  let neighbors := d.neighbors a
  guard (neighbors.length == 2)
  -- Remove the node
  let n0 ← neighbors[0]?
  let n1 ← neighbors[1]?
  let d := d.removeEdgesOf a
  let d := d.removeNode a
  let d := { d with edges := d.edges ++ [Edge.mk n0 n1] }
  return d.normalize

namespace ZxLean

axiom ZXDiagram.identityRemoval_sound (d : ZXDiagram) (a : NodeId) (d' : ZXDiagram) :
  d.identityRemoval a = some d' → d ≈z d'

/-- Remove an identity (phase-0, degree-2) spider. Shows the resulting diagram. -/
syntax "zx_id_removal" num : tactic

elab_rules : tactic
  | `(tactic| zx_id_removal $a) =>
    applyRewrite a "Identity removal"
      ``ZXDiagram.identityRemoval ``ZXDiagram.identityRemoval_sound
      #[mkNatLit a.getNat]

end ZxLean
