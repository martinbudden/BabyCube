include <../global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/fillet.scad>

include <../vitamins/bolts.scad>

include <../config/Parameters_Main.scad>


module footLShapedHoles() {
    translate([_cornerHoleInset, _baseBoltHoleInset.y, 0])
        children();
    translate([_baseBoltHoleInset.x, _cornerHoleInset, 0])
        children();
}

footWidth = 12;
function footLShapedSize(footHeight) = [_cornerHoleInset + footWidth/2, footWidth, footHeight];

module footLShaped(footHeight, boreDepth) {
    size = footLShapedSize(footHeight);
    fillet = 1;

    difference() {
        color(pp2_colour)
            union() {
                rounded_cube_xy(size, fillet);
                translate([size.y, 0, 0])
                    rotate(90)
                        rounded_cube_xy(size, fillet);
                translate([size.y, size.y, 0])
                    fillet(fillet, footHeight);
            }
        footLShapedHoles()
            boltHoleM3CounterboreButtonhead(footHeight, boreDepth=boreDepth);
    }
}

module Foot_LShaped_8mm_stl() {

    stl("Foot_LShaped_8mm")
        color(pp2_colour)
            vflip()
                footLShaped(footHeight=8, boreDepth=4);
}

module Foot_LShaped_8mm_hardware() {
    boreDepth = 4;
    rotate(-90)
        footLShapedHoles()
            translate_z(-boreDepth)
                boltM3Buttonhead(12);
}
