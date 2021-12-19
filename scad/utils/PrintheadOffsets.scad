function printHeadHotendOffset(hotendDescriptor="E3DV6") = [17, hotendDescriptor == "E3DV6" ? 18 : 14, -2];
function printheadWiringOffset(hotendDescriptor="E3DV6") = printHeadHotendOffset() + [37, 0, -10];
function printheadBowdenOffset(hotendDescriptor="E3DV6") = printHeadHotendOffset() + [17, 0, 2];
