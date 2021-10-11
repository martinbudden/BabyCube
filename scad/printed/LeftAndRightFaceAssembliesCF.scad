include <../global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/rockers.scad>
include <NopSCADlib/vitamins/sheets.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

include <../utils/cutouts.scad>
include <../utils/HolePositions.scad>
use <../utils/motorTypes.scad>

include <../vitamins/bolts.scad>
include <../vitamins/cables.scad>
use <../vitamins/extruder.scad>

use <LeftAndRightFaces.scad>
use <LeftAndRightFaceAssemblies.scad>
use <SwitchShroud.scad>
use <XY_IdlerBracket.scad>
use <XY_MotorMount.scad>

use <../Parameters_CoreXY.scad>
include <../Parameters_Main.scad>


module Left_Face_Lower_Joiner_Back_stl() {
    NEMA_width = NEMA_width(xyMotorType());

    stl("Left_Face_Lower_Joiner_Back")
        color(pp1_colour)
            difference() {
                frameLower(NEMA_width, left=true, offset=_sidePlateThickness, length=120);
                lowerSideJoinerHolePositions(_sidePlateThickness, left=true)
                    boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
                lowerChordHolePositions()
                    rotate([90, 0, 180])
                        boltHoleM3Tap(eSizeZ - 2);
            }
}

module Left_Face_Lower_Joiner_Front_stl() {
    stl("Left_Face_Lower_Joiner_Front")
        color(pp1_colour) {
            difference() {
                translate([_sidePlateThickness, 0, _sidePlateThickness]) {
                    rounded_cube_xy([eSizeY, eZ - 70, eSizeXBase - _sidePlateThickness], _fillet);
                    rounded_cube_xy([60, eSizeZ, eSizeXBase - _sidePlateThickness], _fillet);
                    translate([eSizeY, eSizeZ, 0])
                        fillet(5, eSizeXBase - _sidePlateThickness);
                }
                frontSideJoinerHolePositions(_sidePlateThickness)
                    boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
                rotate([0, -90, 0])
                    frontFaceHolePositions()
                        vflip()
                            boltHoleM3Tap(eSizeY - _sidePlateThickness);
            }
        }
}

module Left_Face_Upper_Joiner_stl() {
    stl("Left_Face_Upper_Joiner")
        color(pp1_colour)
            difference() {
                topBoltHolder();
                upperSideJoinerHolePositions(_sidePlateThickness)
                    boltHoleM3Tap(topBoltHolderSize().z);
            }
}

module Right_Face_Lower_Joiner_Back_stl() {
    NEMA_width = NEMA_width(xyMotorType());

    stl("Right_Face_Lower_Joiner_Back")
        color(pp1_colour)
            mirror([0, 1, 0])
                difference() {
                    frameLower(NEMA_width, left=false, offset=_sidePlateThickness, length=120);
                    lowerSideJoinerHolePositions(_sidePlateThickness, left=false)
                        boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
                    lowerChordHolePositions()
                        rotate([90, 0, 180])
                            boltHoleM3Tap(eSizeZ - 2);
                }
}

module Right_Face_Lower_Joiner_Front_stl() {
    stl("Right_Face_Lower_Joiner_Front")
        color(pp1_colour)
            mirror([0, 1, 0])
                difference() {
                    translate([_sidePlateThickness, 0, _sidePlateThickness]) {
                        rounded_cube_xy([eSizeY, eZ - 70, eSizeXBase - _sidePlateThickness], _fillet);
                        rounded_cube_xy([35, eSizeZ, eSizeXBase - _sidePlateThickness], _fillet);
                        translate([eSizeY, eSizeZ, 0])
                            fillet(5, eSizeXBase - _sidePlateThickness);
                    }
                    frontSideJoinerHolePositions(_sidePlateThickness)
                        boltHoleM3Tap(eSizeXBase - _sidePlateThickness + 2);
                    lowerSideJoinerHolePositions(_sidePlateThickness, left=false)
                        boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
                    rotate([0, -90, 0])
                        frontFaceHolePositions()
                            vflip()
                                boltHoleM3Tap(eSizeY - _sidePlateThickness);
                }
}

module Right_Face_Upper_Joiner_stl() {
    stl("Right_Face_Upper_Joiner")
        color(pp1_colour)
            mirror([0, 1, 0])
                difference() {
                    topBoltHolder();
                    upperSideJoinerHolePositions(_sidePlateThickness)
                        boltHoleM3Tap(topBoltHolderSize().z);
                }
}

module topBoltHolder() {
    offset = 70;
    size = topBoltHolderSize() - [offset, 0, 0];
    difference() {
        translate([_frontPlateCFThickness + offset, eZ - _topPlateThickness - size.y, _sidePlateThickness])
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
                    boltHoleM3Tap(8, horizontal = true, rotate = 90, chamfer_both_ends = false);
    }
}

module Left_Face_CF_dxf() {
    dxf("Left_Face_CF")
        leftFaceCF(NEMA_width(NEMA14));
}

CF3Red = CF3;//[ "CF3",       "Sheet carbon fiber",      3, [1, 0, 0],                false,  5,  5,  [0.5, 0, 0] ];

module Left_Face_CF() {
    size = [eY + 2*eSizeY + _backPlateCFThickness, eZ];

    translate([size.x/2, size.y/2, 0])
        render_2D_sheet(CF3Red, w=size.x, d=size.y)
            Left_Face_CF_dxf();
}

module Right_Face_CF_dxf() {
    dxf("Right_Face_CF")
        rightFaceCF(NEMA_width(NEMA14));
}

module Right_Face_CF() {
    size = [eY + 2*eSizeY + _backPlateCFThickness, eZ];

    translate([size.x/2, size.y/2, -_sidePlateThickness])
        render_2D_sheet(CF3Red, w=size.x, d=size.y)
            Right_Face_CF_dxf();
}

module leftFaceCF(NEMA_width) {
    size = [eY + 2*eSizeY + _backPlateCFThickness, eZ];

    difference() {
        sheet_2D(CF3, size.x, size.y);
        translate([-size.x/2, -size.y/2]) {
            sideFaceMotorCutout(left=true, NEMA_width=NEMA_width, cnc=true);
            sideFaceTopDogbones(cnc=true);
            translate([_backPlateCFThickness, 0])
                sideFaceBackDogBones(cnc=true);
            translate([-eY - 2*eSizeY, 0])
                sideFaceBackDogBones(cnc=true);
            switchShroudHolePositions()
                circle(r=M3_clearance_radius);
            lowerSideJoinerHolePositions(left=true)
                circle(r=M3_clearance_radius);
            upperSideJoinerHolePositions()
                circle(r=M3_clearance_radius);
            backSideJoinerHolePositions()
                circle(r=M3_clearance_radius);
            frontSideJoinerHolePositions()
                circle(r=M3_clearance_radius);
            xyMotorMountHolePositions(NEMA_width, left=true)
                circle(r=M3_clearance_radius);
            xyIdlerBracketHolePositions(NEMA_width)
                circle(r=M3_clearance_radius);
        }
    }
}

module rightFaceCF(NEMA_width) {
    size = [eY + 2*eSizeY + _backPlateCFThickness, eZ];

    difference() {
        sheet_2D(CF3, size.x, size.y);
        translate([-size.x/2, -size.y/2]) {
            translate([eSizeY + 20, eSizeZ])
                rounded_square([eY - 20 - 40, 30], 5, center=false);
            sideFaceMotorCutout(left=false, NEMA_width=NEMA_width, cnc=true);
            sideFaceTopDogbones(cnc=true);
            translate([_backPlateCFThickness, 0])
                sideFaceBackDogBones(cnc=true);
            translate([-eY - 2*eSizeY, 0])
                sideFaceBackDogBones(cnc=true);
            translate([extruderPosition(NEMA_width).y, extruderPosition(NEMA_width).z]) {
                circle(r=NEMA_boss_radius(extruderMotorType()) + 0.25);
                // extruder motor bolt holes
                NEMA_screw_positions(extruderMotorType())
                    circle(r=M3_clearance_radius);
            }
            spoolHolderCutout(NEMA_width, cnc=true);
            lowerSideJoinerHolePositions(left=false)
                circle(r=M3_clearance_radius);
            upperSideJoinerHolePositions()
                circle(r=M3_clearance_radius);
            backSideJoinerHolePositions()
                circle(r=M3_clearance_radius);
            frontSideJoinerHolePositions()
                circle(r=M3_clearance_radius);
            xyMotorMountHolePositions(NEMA_width, left=false)
                circle(r=M3_clearance_radius);
            xyIdlerBracketHolePositions(NEMA_width)
                circle(r=M3_clearance_radius);
        }
    }
}


module Left_Face_CF_assembly() pose(a=[55, 0, 25 + 50])
assembly("Left_Face_CF", big=true) {

    translate([-eps, 0, 0])
        rotate([90, 0, 90]) {
            Left_Face_CF();
            explode(20)
                stl_colour(pp1_colour) {
                    Left_Face_Lower_Joiner_Front_stl();
                    Left_Face_Lower_Joiner_Back_stl();
                    Left_Face_Upper_Joiner_stl();
                }
            lowerSideJoinerHolePositions(left=true)
                vflip()
                    boltM3Buttonhead(screw_shorter_than(topBoltHolderSize().z + _sidePlateThickness));
            upperSideJoinerHolePositions()
                vflip()
                    boltM3Buttonhead(8);
            backSideJoinerHolePositions()
                vflip()
                    boltM3Buttonhead(10);
            frontSideJoinerHolePositions()
                vflip()
                    boltM3Buttonhead(10);
            xyMotorMountHolePositions(_xyNEMA_width, left=true)
                vflip()
                    boltM3Buttonhead(10);
            xyIdlerBracketHolePositions(_xyNEMA_width)
                vflip()
                    boltM3Buttonhead(12);
        }
    explode([20, 0, 0]) {
        XY_Motor_Mount_Left_assembly();
        XY_Idler_Bracket_Left_assembly();
    }
    leftFaceHardware(xyMotorType(), cnc=true);
    explode([25, 0, 0])
        Switch_Shroud_assembly();
    Switch_Shroud_bolts(counterSunk=false);
}

module Right_Face_CF_assembly() pose(a=[55, 0, 25 + 50])
assembly("Right_Face_CF", big=true) {

    translate([eX + 2 * eSizeX + eps, 0, 0]) {
        rotate([90, 0, 90]) {
            Right_Face_CF();
            lowerSideJoinerHolePositions(left=false)
                boltM3Buttonhead(screw_shorter_than(topBoltHolderSize().z + _sidePlateThickness));
            upperSideJoinerHolePositions()
                boltM3Buttonhead(8);
            backSideJoinerHolePositions()
                boltM3Buttonhead(10);
            frontSideJoinerHolePositions()
                boltM3Buttonhead(8);
            xyMotorMountHolePositions(_xyNEMA_width, left=false)
                boltM3Buttonhead(10);
            xyIdlerBracketHolePositions(_xyNEMA_width)
                boltM3Buttonhead(12);
        }
        explode([-20, 0, 0])
            rotate([-90, 0, 90])
                stl_colour(pp1_colour) {
                    Right_Face_Lower_Joiner_Front_stl();
                    Right_Face_Lower_Joiner_Back_stl();
                    Right_Face_Upper_Joiner_stl();
                }
    }
    explode([-20, 0, 0]) {
        XY_Motor_Mount_Right_assembly();
        XY_Idler_Bracket_Right_assembly();
    }
    rightFaceHardware(xyMotorType(), cnc=true);
    rightFaceAssembly(_xyNEMA_width);
}
