function printHeadHotendOffset(hotend_type=0) = [17, hotend_type == 0 ? 18 : 14, -2];
function printheadWiringOffset() = printHeadHotendOffset() + [37, 0, -10];
function printheadBowdenOffset() = printHeadHotendOffset() + [17, 0, 2];
