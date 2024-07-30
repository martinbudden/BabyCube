include <../config/global_defs.scad>
include <NopSCADlib/utils/core/core.scad>

include <../vitamins/bolts.scad>
include <../utils/HolePositions.scad>
include <../config/Parameters_Main.scad>


module Top_Face_Back_Joiner_stl() {
    size = [50, eSizeY, eSizeZ];
    stl("Top_Face_Back_Joiner");
    color(pp3_colour)
        difference() {
            translate([(eX + 2*eSizeX - size.x) / 2, eY + 2*eSizeY - size.y, eZ - size.z - _topPlateThickness])
                rounded_cube_xy(size, _fillet);
            rotate([90, 0, 0])
                backFaceCFTopHolePositions(-eY - 2*eSizeY)
                    boltHoleM3Tap(size.y, horizontal=true);
            topFaceBackHolePositions(eZ - _topPlateThickness)
                vflip()
                    boltHoleM3Tap(9);
        }
}

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
    offset = 80;
    size = topBoltHolderSize(reversedBelts=_useReversedBelts, cnc=true) - [80, 0, 0];
    difference() {
        translate([offset, eZ - _topPlateThickness - size.y, _sidePlateThickness])
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

