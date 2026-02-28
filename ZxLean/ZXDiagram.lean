inductive SpiderColor where
  | Z  -- green
  | X  -- red
  deriving Repr, BEq

/-- Phase as a rational multiple of π, stored as p/q.
    e.g. phase 1 2 represents π/2 -/
structure Phase where
  num : Int
  den : Nat := 1
  deriving Repr, BEq

/-- a/b + c/d = (ad + bc)/bd -/
def Phase.add (p q : Phase) : Phase :=
  { num := p.num * q.den + q.num * p.den
    den := p.den * q.den }

instance : Add Phase where
  add := Phase.add

/-- Internal spider (Z/X) or input or output -/
inductive Node where
  | spider (color : SpiderColor) (phase : Phase)
  | input  (id : Nat)
  | output (id : Nat)
  deriving Repr, BEq

/-- Get the color of a node, if it is a spider -/
def Node.color? : Node → Option SpiderColor
  | .spider c _ => some c
  | _ => none

/-- Get the phase of a node, if it is a spider -/
def Node.phase? : Node → Option Phase
  | .spider _ p => some p
  | _ => none

/-- Edge between nodes identified by index into the node array -/
structure Edge where
  src : Nat
  tgt : Nat
  deriving Repr, BEq

structure ZXDiagram where
  nodes : Array Node
  edges : Array Edge
  deriving Repr, BEq

/-- Check whether two node indices are connected by an edge -/
def ZXDiagram.connected (d : ZXDiagram) (a b : Nat) : Bool :=
  d.edges.any fun e => (e.src == a && e.tgt == b) || (e.src == b && e.tgt == a)

/-- Get all neighbor indices of a given node -/
def ZXDiagram.neighbors (d : ZXDiagram) (n : Nat) : Array Nat :=
  d.edges.foldl (init := #[]) fun acc e =>
    if e.src == n then acc.push e.tgt
    else if e.tgt == n then acc.push e.src
    else acc

/-- Remove all edges touching a given node index -/
def ZXDiagram.removeEdgesOf (d : ZXDiagram) (n : Nat) : ZXDiagram :=
  { d with edges := d.edges.filter fun e => e.src != n && e.tgt != n }

/-- Remove a node and reindex all edges accordingly -/
def ZXDiagram.removeNode (d : ZXDiagram) (n : Nat) : ZXDiagram :=
  let reindex (i : Nat) : Nat := if i > n then i - 1 else i
  { nodes := d.nodes.extract 0 n ++ d.nodes.extract (n + 1) d.nodes.size
    edges := d.edges.map fun e => ⟨reindex e.src, reindex e.tgt⟩ }
