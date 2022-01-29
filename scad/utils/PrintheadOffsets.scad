function printheadHotendOffset(hotendDescriptor="E3DV6") = [17, hotendDescriptor == "E3DV6" ? 18 : 14, -2];
function printheadWiringOffset(hotendDescriptor="E3DV6") = printheadHotendOffset() + [35, 0, -10];
function printheadBowdenOffset(hotendDescriptor="E3DV6") = printheadHotendOffset() + [17, 0, 2];
