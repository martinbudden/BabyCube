include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/rockers.scad>
include <NopSCADlib/vitamins/sheets.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../utils/cutouts.scad>
use <../utils/carriageTypes.scad>
use <../utils/HolePositions.scad>
use <../utils/motorTypes.scad>

use <../vitamins/bolts.scad>
use <../vitamins/cables.scad>
use <../vitamins/extruder.scad>

use <LeftAndRightFaces.scad>
use <LeftAndRightFaceAssemblies.scad>
use <SwitchShroud.scad>
use <XY_IdlerBracket.scad>
use <XY_MotorMount.scad>

use <../Parameters_CoreXY.scad>
include <../Parameters_Main.scad>


module Left_Face_Lower_Joiner_stl() {
    NEMA_type = xyMotorType();

    stl("Left_Face_Lower_Joiner")
        color(pp1_colour)
            difference() {
                frameLower(NEMA_width(NEMA_type), left=true, offset=_sidePlateThickness);
                lowerSideJoinerHolePositions(_sidePlateThickness)
                    boltHoleM3Tap(eSizeXBase-_sidePlateThickness);
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

module Right_Face_Lower_Joiner_stl() {
    NEMA_type = xyMotorType();

    stl("Right_Face_Lower_Joiner")
        color(pp1_colour)
            rotate(180)
                mirror([0, 1, 0])
                    difference() {
                        frameLower(NEMA_width(NEMA_type), left=false, offset=_sidePlateThickness);
                        lowerSideJoinerHolePositions(_sidePlateThickness)
                            boltHoleM3Tap(eSizeXBase-_sidePlateThickness);
                    }
}

module Right_Face_Upper_Joiner_stl() {
    stl("Right_Face_Upper_Joiner")
        color(pp1_colour)
            rotate(180)
                mirror([0, 1, 0])
                    difference() {
                        topBoltHolder();
                        upperSideJoinerHolePositions(_sidePlateThickness)
                            boltHoleM3Tap(topBoltHolderSize().z);
                    }
}

module topBoltHolder() {
    size = topBoltHolderSize() - [11, 0, 0];
    difference() {
        translate([_frontPlateCFThickness + 11, eZ - _topPlateThickness - size.y, _sidePlateThickness])
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
        leftFaceCF(NEMA14T());
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
        rightFaceCF(NEMA14T());
}

module Right_Face_CF() {
    size = [eY + 2*eSizeY + _backPlateCFThickness, eZ];

    translate([size.x/2, size.y/2, -_sidePlateThickness])
        render_2D_sheet(CF3Red, w=size.x, d=size.y)
            Right_Face_CF_dxf();
}


module xyMotorMountHolePositions(NEMA_width, left) {
    xymp = xyMotorPosition(NEMA_width, left);
    translate([eY + 2*eSizeY - 4, xymp.y +3 ]) {
        children();
        translate([0, 18])
            children();
        translate([-38.6, 0])
            children();
    }
}

module leftFaceCF(NEMA_type) {
    assert(isNEMAType(NEMA_type));

    size = [eY + 2*eSizeY + _backPlateCFThickness, eZ];

    NEMA_width = NEMA_width(NEMA_type);
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
                circle(r = M3_clearance_radius);
            lowerSideJoinerHolePositions()
                circle(r = M3_clearance_radius);
            upperSideJoinerHolePositions()
                circle(r = M3_clearance_radius);
            backSideJoinerHolePositions()
                circle(r = M3_clearance_radius);
            xyMotorMountHolePositions(NEMA_width, left=true)
                circle(r = M3_clearance_radius);
        }
    }
}

module rightFaceCF(NEMA_type) {
    assert(isNEMAType(NEMA_type));

    size = [eY + 2*eSizeY + _backPlateCFThickness, eZ];

    NEMA_width = NEMA_width(NEMA_type);
    difference() {
        sheet_2D(CF3, size.x, size.y);
        translate([-size.x/2, -size.y/2]) {
            sideFaceMotorCutout(left=false, NEMA_width=NEMA_width, cnc=true);
            sideFaceTopDogbones(cnc=true);
            translate([_backPlateCFThickness, 0])
                sideFaceBackDogBones(cnc=true);
            translate([-eY - 2*eSizeY, 0])
                sideFaceBackDogBones(cnc=true);
            translate([extruderPosition(NEMA_width).y, extruderPosition(NEMA_width).z]) {
                circle(r = NEMA_boss_radius(extruderMotorType()) + 0.25);
                // extruder motor bolt holes
                NEMA_screw_positions(extruderMotorType())
                    circle(r = M3_clearance_radius);
            }
            spoolHolderCutout(NEMA_width, cnc=true);
            lowerSideJoinerHolePositions()
                circle(r = M3_clearance_radius);
            upperSideJoinerHolePositions()
                circle(r = M3_clearance_radius);
            backSideJoinerHolePositions()
                circle(r = M3_clearance_radius);
            xyMotorMountHolePositions(NEMA_width, left=false)
                circle(r = M3_clearance_radius);
        }
    }
}


module Left_Face_CF_assembly() pose(a=[55, 0, 25 + 50])
assembly("Left_Face_CF", big=true) {

    translate([-eps, 0, 0])
        rotate([90, 0, 90]) {
            Left_Face_CF();
            Left_Face_Lower_Joiner_stl();
            lowerSideJoinerHolePositions()
                vflip()
                    boltM3Buttonhead(screw_shorter_than(topBoltHolderSize().z + _sidePlateThickness));
            backSideJoinerHolePositions()
                vflip()
                    boltM3Buttonhead(10);
            xyMotorMountHolePositions(_xyNEMA_width, left=true)
                vflip()
                    boltM3Buttonhead(10);
            Left_Face_Upper_Joiner_stl();
            upperSideJoinerHolePositions()
                vflip()
                    boltM3Buttonhead(8);
        }
    XY_Motor_Mount_Left_assembly();
    XY_Idler_Bracket_Left_assembly();
    leftFaceHardware(xyMotorType(), rocker=false);
}

module Right_Face_CF_assembly() pose(a=[55, 0, 25 + 50])
assembly("Right_Face_CF", big=true) {

    translate([eX + 2 * eSizeX + eps, 0, 0]) {
        rotate([90, 0, 90]) {
            Right_Face_CF();
            lowerSideJoinerHolePositions()
                boltM3Buttonhead(screw_shorter_than(topBoltHolderSize().z + _sidePlateThickness));
            backSideJoinerHolePositions()
                boltM3Buttonhead(10);
            xyMotorMountHolePositions(_xyNEMA_width, left=false)
                boltM3Buttonhead(10);
            upperSideJoinerHolePositions()
                boltM3Buttonhead(8);
        }
        rotate([90, 0, -90]) {
            Right_Face_Lower_Joiner_stl();
            Right_Face_Upper_Joiner_stl();
        }
    }
    XY_Motor_Mount_Right_assembly();
    XY_Idler_Bracket_Right_assembly();
    rightFaceHardware(xyMotorType());
    rightFaceAssembly(_xyNEMA_width);
}
