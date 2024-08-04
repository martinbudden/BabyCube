function printheadHotendOffset(hotendDescriptor="E3DV6") = 
    hotendDescriptor == "E3DV6" ? [17, 18, 2] :
    hotendDescriptor == "E3DRevo" ? [-2, 28, -1.2] : // revoVoronSizeZ() (48.8) - 50 
    hotendDescriptor == "DropEffectXG" ? [0, 29.4, -1.5] : // dropEffectXGSizeZ() (48.5) - 50
    [0, 0, 0];
function printheadBowdenOffset(hotendDescriptor="E3DV6") = 
    hotendDescriptor == "E3DV6" ? printheadHotendOffset(hotendDescriptor) + [17, 0, 2] :
    hotendDescriptor == "E3DRevo" ? printheadHotendOffset(hotendDescriptor) + [29.5, -15, 8] :
    hotendDescriptor == "DropEffectXG" ? printheadHotendOffset(hotendDescriptor) + [31, -15, 8] :
    [0, 0, 0];
function printheadWiringOffset(hotendDescriptor="E3DV6") =
    hotendDescriptor == "E3DV6" ? printheadHotendOffset(hotendDescriptor) + [35, 0, -10] :
    hotendDescriptor == "E3DRevo" ? [11, 3, 0] :
    hotendDescriptor == "DropEffectXG" ? [24, 2, 10] :
    [0, 0, 0];
