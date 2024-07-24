function printheadHotendOffset(hotendDescriptor="E3DV6") = 
    hotendDescriptor == "E3DV6" ? [17, 18, 2] :
    [0, 0, 0];
function printheadBowdenOffset(hotendDescriptor="E3DV6") = 
    hotendDescriptor == "E3DV6" ? printheadHotendOffset(hotendDescriptor) + [17, 0, 2] :
    [0, 0, 0];
function printheadWiringOffset(hotendDescriptor="E3DV6") =
    hotendDescriptor == "E3DV6" ? printheadHotendOffset(hotendDescriptor) + [35, 0, -10] :
    [0, 0, 0];
