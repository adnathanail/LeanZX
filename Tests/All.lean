import Tests.SpiderFusion
import Tests.SpiderUnfusion
import Tests.IdentityRemoval
import Tests.PiCopy
import Tests.HadamardHadamard
import Tests.ColourChange
import Tests.Normalization

open LSpec

#lspec spiderFusionTests ++ spiderUnfusionTests ++ identityRemovalTests ++ piCopyTests ++ hadamardHadamardTests ++ colourChangeTests ++ normalizationTests
