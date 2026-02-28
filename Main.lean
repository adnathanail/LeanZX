import ZxLean

/-- in -→ Z(π) -→ Z(2π) -→ out -/
def twoSpiders : ZXDiagram :=
  { nodes := #[.input 0, .spider .Z ⟨1, 1⟩, .spider .Z ⟨2, 1⟩, .output 0]
    edges := #[⟨0, 1⟩, ⟨1, 2⟩, ⟨2, 3⟩] }

/-- in -→ Z(3π) -→ out (with dead node) -/
-- TODO remove dead node
def fused : ZXDiagram :=
  { nodes := #[.input 0, .spider .Z ⟨3, 1⟩, .spider .Z ⟨2, 1⟩, .output 0]
    edges := #[⟨0, 1⟩, ⟨1, 3⟩] }

#eval twoSpiders.spiderFusion 1 2
#eval some fused
#eval twoSpiders.spiderFusion 1 2 == some fused

def main : IO Unit :=
  IO.println s!"Hello!"
