import ZxLean.ZXDiagram

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
  return d

def ZXDiagram.identityRemoval (d: ZXDiagram) (a : NodeId) : Option ZXDiagram := do
  -- Check the node being removed has no phase
  let node ← d.getNode? a
  let phase ← Node.phase? node
  guard (phase == ⟨0, 1⟩)
  -- Check the node being removed only has 2 neighbors
  let neighbors := d.neighbors a
  guard (neighbors.size == 2)
  -- Remove the node
  let d := d.removeEdgesOf a
  let d := d.removeNode a
  let d := { d with edges := d.edges ++ #[⟨neighbors[0]!, neighbors[1]!⟩] }
  return d
