function printHeadHotendOffset(hotend_type=0) = [17, hotend_type == 0 ? 18 : 14, -2];
function printheadWiringOffset() = printHeadHotendOffset() + [printHeadHotendOffset().x+20, 0, -10];
function printheadBowdenOffset() = printHeadHotendOffset() + [printHeadHotendOffset().x, 0, 2];
