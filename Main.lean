import ZxLean

def threeSpiders : ZXDiagram :=
  .ofArrays #[.input 0, .spider .Z ⟨1, 2⟩, .spider .Z ⟨1, 1⟩, .spider .Z ⟨3, 4⟩, .output 0]
            #[⟨0, 1⟩, ⟨1, 2⟩, ⟨2, 3⟩, ⟨3, 4⟩]

#html threeSpiders.toHtml
#html (threeSpiders.spiderFusion 2 3).get!.toHtml

def zCnotZ : ZXDiagram :=
  .ofArrays #[
      .input 0, .spider .Z ⟨1, 1⟩, .spider .Z ⟨0, 1⟩, .spider .Z ⟨1, 1⟩, .output 0,
      .input 1, .spider .X ⟨0, 1⟩, .output 1
    ]
    #[⟨0, 1⟩, ⟨1, 2⟩, ⟨2, 3⟩, ⟨3, 4⟩, ⟨2, 6⟩, ⟨5, 6⟩, ⟨6, 7⟩]

def zCnotZFusedA := (zCnotZ.spiderFusion 1 2).get!
-- With stable IDs, after fusing 1+2, node 3 stays as 3 (not reindexed to 2)
def zCnotZFusedB := (zCnotZFusedA.spiderFusion 1 3).get!

#html zCnotZ.toHtml
#html zCnotZFusedA.toHtml
#html zCnotZFusedB.toHtml

def useless_identity : ZXDiagram :=
  .ofArrays #[.input 0, .spider .Z ⟨1, 1⟩, .spider .Z ⟨0, 1⟩, .output 0]
            #[⟨0, 1⟩, ⟨1, 2⟩, ⟨2, 3⟩]

def id_removed := (useless_identity.identityRemoval 1).get!

#html useless_identity.toHtml
#html id_removed.toHtml

def main : IO Unit :=
  IO.println "Open Main.lean in VS Code to see the ZX diagram in the InfoView."
