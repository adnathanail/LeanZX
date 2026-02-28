import ZxLean.ZXDiagram

def ZXDiagram.spiderFusion (d : ZXDiagram) (a b : Nat) : Option ZXDiagram := do
  -- Get node info
  let nodeA ← d.nodes[a]?
  let nodeB ← d.nodes[b]?
  let colorA ← Node.color? nodeA
  let colorB ← Node.color? nodeB
  let phaseA ← Node.phase? nodeA
  let phaseB ← Node.phase? nodeB
  -- Check we have two connected spiders of the same colours
  guard (colorA == colorB)
  guard (d.connected a b)
  -- new merged spider
  let merged := Node.spider colorA (phaseA + phaseB)
  -- rewire: edges from b's neighbors (except a) now point to a
  let bNeighbors := d.neighbors b |>.filter (· != a)
  let newEdges := bNeighbors.map fun n => Edge.mk a n
  -- remove all edges touching b, update node at a
  let d := d.removeEdgesOf b
  let d := { d with nodes := d.nodes.set! a merged }
  let d := { d with edges := d.edges ++ newEdges }
  return d
