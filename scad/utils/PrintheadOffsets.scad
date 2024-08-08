function printheadHotendOffset(hotendDescriptor="E3DV6") = 
    hotendDescriptor == "E3DV6" ? [17, 18, 2] :
    hotendDescriptor == "E3DRevo" ? [2, 28, -1.2] : // revoVoronSizeZ() (48.8) - 50 
    hotendDescriptor == "E3DRevoCompact" ? [2, 33, -1.2] : // experimental compact E3D Revo X_Carriage 
    hotendDescriptor == "E3DRevo40" ? [2, 38, -1.2] : // E3D Revo with 40mm blower 
    hotendDescriptor == "DropEffectXG" ? [0, 29.4, -1.5] : // dropEffectXGSizeZ() (48.5) - 50
    [0, 0, 0];
function printheadBowdenOffset(hotendDescriptor="E3DV6") = 
    hotendDescriptor == "E3DV6" ? printheadHotendOffset(hotendDescriptor) + [-15, 15, 2] :
    hotendDescriptor == "E3DRevo" ? printheadHotendOffset(hotendDescriptor) + [0, 0, 10] :
    hotendDescriptor == "E3DRevoCompact" ? printheadHotendOffset(hotendDescriptor) + [0, 0, 10] :
    hotendDescriptor == "E3DRevo40" ? printheadHotendOffset(hotendDescriptor) + [0, 0, 10] :
    hotendDescriptor == "DropEffectXG" ? printheadHotendOffset(hotendDescriptor) + [0, 0, 10] :
    [0, 0, 0];
function printheadWiringOffset(hotendDescriptor="E3DV6") =
    hotendDescriptor == "E3DV6" ? printheadHotendOffset(hotendDescriptor) + [3, 15, -7] :
    hotendDescriptor == "E3DRevo" ? printheadHotendOffset(hotendDescriptor) + [-9.5, -9.5, 12] :
    hotendDescriptor == "E3DRevoCompact" ? printheadHotendOffset(hotendDescriptor) + [-9.5, -15, 12] :
    hotendDescriptor == "E3DRevo40" ? printheadHotendOffset(hotendDescriptor) + [-9.5, -9.5, 12] :
    hotendDescriptor == "DropEffectXG" ? printheadHotendOffset(hotendDescriptor) + [-7.5, -11, 12] :
    [0, 0, 0];
