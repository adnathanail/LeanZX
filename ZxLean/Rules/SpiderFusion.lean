import ZxLean.Axioms
import ZxLean.Tactics

open Lean Elab Tactic Meta

def ZXDiagram.spiderFusion (d : ZXDiagram) (a b : NodeId) : Option ZXDiagram := do
  -- Get node info
  let nodeA ← d.getNode? a
  let nodeB ← d.getNode? b
  let colorA ← Node.color? nodeA
  let colorB ← Node.color? nodeB
  let phaseA ← Node.phase? nodeA
  let phaseB ← Node.phase? nodeB
  -- Check we have two connected spiders of the same colours
  guard (colorA == colorB)
  guard (d.connected a b)
  -- New merged spider
  let merged := Node.spider colorA (phaseA + phaseB)
  -- Rewire edges from b's neighbors (except a) to now point to a
  let bNeighbors := d.neighbors b |>.filter (· != a)
  let newEdges := bNeighbors.map fun n => Edge.mk a n
  -- Remove all edges touching b, update node at a, then remove node b
  let d := d.removeEdgesOf b
  let d := d.setNode a merged
  let d := { d with edges := d.edges ++ newEdges }
  let d := d.removeNode b
  return d.normalize

namespace ZxLean

axiom ZXDiagram.spiderFusion_sound (d : ZXDiagram) (a b : NodeId) (d' : ZXDiagram) :
  d.spiderFusion a b = some d' → d ≈z d'

/-- Fuse two connected spiders of the same color. Shows the resulting diagram. -/
syntax "zx_spider_fusion" num num : tactic

elab_rules : tactic
  | `(tactic| zx_spider_fusion $a $b) =>
    applyRewrite a "Spider fusion"
      ``ZXDiagram.spiderFusion ``ZXDiagram.spiderFusion_sound
      #[mkNatLit a.getNat, mkNatLit b.getNat]

end ZxLean
