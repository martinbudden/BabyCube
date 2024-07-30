include <../global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/fillet.scad>

include <../vitamins/bolts.scad>
include <../utils/HolePositions.scad>
include <../Parameters_Main.scad>


module Base_Front_Joiner_stl() {
    size = [eX, eSizeY, eSizeZ];
    stl("Base_Front_Joiner")
        difference() {
            translate([eSizeX, _frontPlateCFThickness, 0])
                color(pp2_colour)
                    rounded_cube_xy(size, _fillet);
            baseFrontHolePositions(cf=true)
                boltHoleM3Tap(size.z);
            baseAllCornerHolePositions()
                boltHoleM3Tap(size.z);
            rotate([90, 0, 0])
                frontFaceLowerHolePositions(-size.y - _frontPlateCFThickness)
                    boltHoleM3Tap(size.y, horizontal=true);
        }
}

baseCoverHeight = 43;
backBoltLength = 9;

module baseSideJoiner(offset=0, baseCoverOffset, left) {
    difference() {
        // bottom chord
        union() {
            fillet = 1.5;
            translate([offset, 0, offset]) {
                rounded_cube_xy([eY + 2*eSizeY - offset, eSizeZ, eSizeXBase - offset], fillet);
                rounded_cube_xy([eSizeY, 55, eSizeXBase - offset], fillet);
                rounded_cube_xy([2*eSizeY, baseCoverOffset, eSizeXBase - offset], fillet);
                translate([2*eSizeY, eSizeZ, 0])
                    fillet(fillet, eSizeXBase - offset);
            }
            translate([eY + eSizeY, 0, offset]) {
                rounded_cube_xy([eSizeY, 20, 35 - offset], fillet); // 38 to match frontConnector size
                translate([0, eSizeZ, 0])
                    rotate(90)
                        fillet(5, eSizeXBase - offset);
            }
        }
        translate([offset + 3*eSizeY/2, baseCoverOffset, (eSizeXBase + offset)/2])
            rotate([90, 0, 0])
                boltHoleM3Tap(10);
        translate([eY + 2*eSizeY, backFaceHolePositions()[0], _backFaceHoleInset])
            rotate([90, 0, -90])
                boltHoleM3Tap(backBoltLength, horizontal=true, chamfer_both_ends=false);
        translate([eY + 2*eSizeY, backFaceBracketLowerOffset().y, backFaceBracketLowerOffset().x])
            rotate([90, 0, -90])
                boltHoleM3Tap(10, horizontal=true, chamfer_both_ends=false);
        lowerChordHolePositions()
            rotate([90, 0, 180])
                boltHoleM3Tap(eSizeZ - 2, horizontal=true, chamfer_both_ends=false);
    }
}

module Base_Left_Joiner_stl() {
    stl("Base_Left_Joiner")
        difference() {
            color(pp1_colour)
                baseSideJoiner(offset=_sidePlateThickness, baseCoverOffset=baseCoverHeight-3, left=true);
            lowerSideJoinerHolePositions(_sidePlateThickness, left=true)
                boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
            frontSideJoinerHolePositions(_sidePlateThickness)
                boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
            rotate([0, -90, 0])
                frontFaceSideHolePositions(-_sidePlateThickness)
                    vflip()
                        boltHoleM3Tap(eSizeXBase, horizontal=true, rotate=-90);
            faceConnectorHolePositions()
                rotate([90, 0, 180])
                    boltHoleM3Tap(backBoltLength, horizontal=true);
    }
}


module Base_Right_Joiner_stl() {
    stl("Base_Right_Joiner")
        mirror([0, 1, 0])
            difference() {
                color(pp1_colour)
                    baseSideJoiner(offset=_sidePlateThickness, baseCoverOffset=baseCoverHeight-3, left=false);
                lowerSideJoinerHolePositions(_sidePlateThickness, left=false)
                    boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
                frontSideJoinerHolePositions(_sidePlateThickness)
                    boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
                rotate([0, -90, 0])
                    frontFaceSideHolePositions(-_sidePlateThickness)
                        vflip()
                            boltHoleM3Tap(eSizeXBase, horizontal=true, rotate=-90);
                faceConnectorHolePositions()
                    rotate([90, 0, 180])
                        boltHoleM3Tap(backBoltLength, horizontal=true);
            }
}

