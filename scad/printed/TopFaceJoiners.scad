include <../config/global_defs.scad>
include <NopSCADlib/utils/core/core.scad>

include <../vitamins/bolts.scad>
include <../utils/HolePositions.scad>
include <../config/Parameters_Main.scad>


module Top_Face_Front_Joiner_stl() {
    size = [eX - 120, eSizeY, eSizeZ];
    stl("Top_Face_Front_Joiner");
    color(pp3_colour)
        difference() {
            translate([(eX + 2*eSizeX - size.x) / 2, _frontPlateCFThickness, eZ - size.z - _topPlateThickness])
                rounded_cube_xy(size, _fillet);
            rotate([90, 0, 0])
                frontFaceUpperHolePositions(-_frontPlateCFThickness)
                    vflip()
                        boltHoleM3Tap(size.y, horizontal=true, rotate=180);
            topFaceFrontHolePositions(eZ - _topPlateThickness, cf=true)
                vflip()
                    boltHoleM3Tap(9);
        }
}

module topFaceSideJoiner() {
    topBoltHolderSize = topBoltHolderSize(reversedBelts=true);
    size = [60, topBoltHolderSize.y, topBoltHolderSize.z];
    difference() {
        translate([(eY + 2*eSizeY -size.x)/2, eZ - _topPlateThickness - size.y, _sidePlateThickness])
            rounded_cube_xy(size, _fillet);
        /*cutoutSize = [11, 1, size.z + 2*eps];
        translate([_frontPlateCFThickness, eZ - _topPlateThickness - size.y, _sidePlateThickness - eps]) {
            cube(cutoutSize);
            translate([0, cutoutSize.y, 0])
                fillet(1, size.z + 2*eps);
            translate([cutoutSize.x, 0, 0])
                fillet(1, size.z + 2*eps);
        }*/
        translate([0, eZ - _topPlateThickness, eX + 2*eSizeX])
            rotate([90, 90, 0])
                topFaceSideHolePositions()
                    boltHoleM3Tap(8, horizontal=true, rotate=90, chamfer_both_ends=false);
    }
}

module Top_Face_Left_Joiner_stl() {
    stl("Top_Face_Left_Joiner")
        difference() {
            color(pp3_colour)
                topFaceSideJoiner();
            upperSideJoinerHolePositions(_sidePlateThickness, reversedBelts=_useReversedBelts)
                boltHoleM3Tap(topBoltHolderSize().z);
        }
}

module Top_Face_Right_Joiner_stl() {
    stl("Top_Face_Right_Joiner")
        mirror([0, 1, 0])
            difference() {
                color(pp3_colour)
                    topFaceSideJoiner();
                upperSideJoinerHolePositions(_sidePlateThickness, reversedBelts=_useReversedBelts)
                    boltHoleM3Tap(topBoltHolderSize().z);
            }
}

