include <../config/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>

include <../vitamins/bolts.scad>
include <../utils/HolePositions.scad>
include <../utils/cutouts.scad>
include <../config/Parameters_Main.scad>

module sideFaceJoiner() {
    difference() {
        offset = 20;
        translate([eY + eSizeY, offset, _sidePlateThickness])
            rounded_cube_xy([eSizeY, eZ - 94 - offset, eSizeXBase + 1 - _sidePlateThickness], _fillet);
        backSideJoinerHolePositions(_sidePlateThickness)
            boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
        translate([eY + 2*eSizeY, 0, 0])
            rotate([0, -90, 0]) {
                backFaceCFSideHolePositions()
                    boltHoleM3Tap(eSizeY - _backPlateCFThickness, horizontal=true, rotate=-90, chamfer_both_ends=false);
                backFaceLeftAndRightSideHolePositions()
                    boltHoleM3Tap(eSizeY - _backPlateCFThickness, horizontal=true, rotate=-90, chamfer_both_ends=false);
            }
        for (y = motorUprightZipTiePositions())
            translate([eY + eSizeY-eps, y, eSizeXBase + 1])
                zipTieCutout();
    }
}

module Back_Face_Left_Joiner_stl() {
    stl("Back_Face_Left_Joiner")
        color(pp2_colour)
            sideFaceJoiner();
}

module Back_Face_Right_Joiner_stl() {
    stl("Back_Face_Right_Joiner")
        color(pp2_colour)
            mirror([0, 1, 0])
                sideFaceJoiner();
}
