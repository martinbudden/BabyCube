include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/sheets.scad>

include <LeftAndRightFaceAssemblies.scad>
include <XY_MotorMountCF.scad>

include <../Parameters_CoreXY.scad>


module Left_Face_Lower_Joiner_Back_stl() {
    NEMA_width = NEMA_width(xyMotorType());

    stl("Left_Face_Lower_Joiner_Back")
        difference() {
            color(pp1_colour)
                frameLower(NEMA_width, left=true, offset=_sidePlateThickness, length=120);
            lowerSideJoinerHolePositions(_sidePlateThickness, left=true)
                boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
            lowerChordHolePositions()
                rotate([90, 0, 180])
                    boltHoleM3Tap(eSizeZ - 2);
            faceConnectorHolePositions()
                rotate([90, 0, 180])
                    boltHoleM3Tap(backBoltLength(), horizontal=true);
        }
}

module Front_Face_Joiner_stl() {
    stl("Front_Face_Joiner")
        difference() {
            offset = 10;
            translate([_sidePlateThickness, offset, _sidePlateThickness])
                color(pp2_colour)
                    rounded_cube_xy([eSizeY, eZ - 70 - offset, eSizeXBase - _sidePlateThickness], _fillet);
            frontSideJoinerHolePositions(_sidePlateThickness)
                boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
            rotate([0, -90, 0])
                frontFaceSideHolePositions(-_frontPlateCFThickness)
                    vflip()
                        boltHoleM3Tap(eSizeY - _frontPlateCFThickness, horizontal=true, rotate=-90, chamfer_both_ends=false);
        }
}

module backFaceJoiner() {
    difference() {
        offset = 20;
        translate([eY + eSizeY, offset, _sidePlateThickness])
            rounded_cube_xy([eSizeY, eZ - 90 - offset, eSizeXBase + 1 - _sidePlateThickness], _fillet);
        backSideJoinerHolePositions(_sidePlateThickness)
            boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
        translate([eY + 2*eSizeY, 0, 0])
            rotate([0, -90, 0]) {
                backFaceCFSideHolePositions(0)
                    boltHoleM3Tap(eSizeY - _backPlateCFThickness, horizontal=true, rotate=-90, chamfer_both_ends=false);
                backFaceAllHolePositions(0)
                    boltHoleM3Tap(eSizeY - _backPlateCFThickness, horizontal=true, rotate=-90, chamfer_both_ends=false);
            }
        for (y = motorUprightZipTiePositions())
            translate([eY + eSizeY-eps, y, eSizeXBase + 1])
                zipTieCutout();
    }
}

module Left_Face_Back_Joiner_stl() {
    stl("Left_Face_Back_Joiner")
        color(pp2_colour)
            backFaceJoiner();
}

module Right_Face_Back_Joiner_stl() {
    stl("Right_Face_Back_Joiner")
        color(pp2_colour)
            mirror([0, 1, 0])
                backFaceJoiner();
}

module Left_Face_Lower_Joiner_Front_stl() {
    stl("Left_Face_Lower_Joiner_Front")
        difference() {
            color(pp1_colour)
                translate([_sidePlateThickness, 0, _sidePlateThickness]) {
                    rounded_cube_xy([eSizeY, eZ - 70, eSizeXBase - _sidePlateThickness], _fillet);
                    rounded_cube_xy([60, eSizeZ, eSizeXBase - _sidePlateThickness], _fillet);
                    translate([eSizeY, eSizeZ, 0])
                        fillet(5, eSizeXBase - _sidePlateThickness);
                }
            frontSideJoinerHolePositions(_sidePlateThickness)
                boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
            rotate([0, -90, 0])
                frontFaceSideHolePositions()
                    vflip()
                        boltHoleM3Tap(eSizeY - _sidePlateThickness);
        }
}

module Left_Face_Upper_Joiner_stl() {
    stl("Left_Face_Upper_Joiner")
        difference() {
            color(pp2_colour)
                topBoltHolder();
            upperSideJoinerHolePositions(_sidePlateThickness)
                boltHoleM3Tap(topBoltHolderSize().z);
        }
}

module Right_Face_Lower_Joiner_Back_stl() {
    NEMA_width = NEMA_width(xyMotorType());

    stl("Right_Face_Lower_Joiner_Back")
        mirror([0, 1, 0])
            difference() {
                color(pp1_colour)
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
        mirror([0, 1, 0])
            difference() {
                color(pp1_colour)
                    translate([_sidePlateThickness, 0, _sidePlateThickness]) {
                        rounded_cube_xy([eSizeY, eZ - 70, eSizeXBase - _sidePlateThickness], _fillet);
                        rounded_cube_xy([35, eSizeZ, eSizeXBase - _sidePlateThickness], _fillet);
                        translate([eSizeY, eSizeZ, 0])
                            fillet(2, eSizeXBase - _sidePlateThickness);
                    }
                frontSideJoinerHolePositions(_sidePlateThickness)
                    boltHoleM3Tap(eSizeXBase - _sidePlateThickness + 2);
                lowerSideJoinerHolePositions(_sidePlateThickness, left=false)
                    boltHoleM3Tap(eSizeXBase - _sidePlateThickness);
                rotate([0, -90, 0])
                    frontFaceSideHolePositions()
                        vflip()
                            boltHoleM3Tap(eSizeY - _sidePlateThickness);
            }
}

module Right_Face_Upper_Joiner_stl() {
    stl("Right_Face_Upper_Joiner")
        mirror([0, 1, 0])
            difference() {
                color(pp2_colour)
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
        leftFaceCF(NEMA_width(NEMA14_36));
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
        rightFaceCF(NEMA_width(NEMA14_36));
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
            if (_useFrontSwitch)
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
            if (_psuDescriptor == "ASUS_FSKE_120W") {
                translate([eSizeY + 35, eSizeZ])
                    rounded_square([eY - 75, 30], 5, center=false);
            } else {
                translate([eSizeY + 35, eSizeZ])
                    rounded_square([40, 15], 5, center=false);
                cutoutSize = [48, 30];
                translate([iecPosition().y, iecPosition().z]) {
                    rounded_square(cutoutSize, 5, center=true);
                    for(y = [-iec_pitch(iecType())/2, iec_pitch(iecType())/2])
                        translate([0, y])
                            circle(r=M3_clearance_radius);
                }
            }
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

//! 1. Bolt the **Front_Face_Joiner**, the **Left_Face_Back_Joiner**, and the **Left_Face_Upper_Joiner** to the
//!**Left_Face**
//! 2. Bolt the **XY_Idler_Bracket_Left_assembly** and the **XY_Motor_Mount_Left_CF_assembly** to the **Left_Face**
//
module Left_Face_CF_assembly() pose(a=[55, 0, 25 + 50 - 20])
assembly("Left_Face_CF", big=true) {

    translate([-eps, 0, 0])
        rotate([90, 0, 90]) {
            Left_Face_CF();
            explode(20, show_line=false) {
                stl_colour(pp2_colour)
                    Front_Face_Joiner_stl();
                stl_colour(pp2_colour)
                    Left_Face_Back_Joiner_stl();
                    //Left_Face_Lower_Joiner_Front_stl();
                    //Left_Face_Lower_Joiner_Back_stl();
                stl_colour(pp2_colour)
                    Left_Face_Upper_Joiner_stl();
            }
            *lowerSideJoinerHolePositions(left=true)
                vflip()
                    explode(10, true)
                        boltM3Buttonhead(screw_shorter_than(topBoltHolderSize().z + _sidePlateThickness));
            upperSideJoinerHolePositions()
                vflip()
                    explode(10, true)
                        boltM3Buttonhead(8);
            backSideJoinerHolePositions()
                vflip()
                    explode(10, true)
                        boltM3Buttonhead(10);
            frontSideJoinerHolePositions()
                vflip()
                    explode(10, true)
                        boltM3Buttonhead(10);
            xyMotorMountHolePositions(_xyNEMA_width, left=true)
                vflip()
                    explode(10, true)
                        boltM3Buttonhead(10);
            xyIdlerBracketHolePositions(_xyNEMA_width)
                vflip()
                    explode(10, true)
                        boltM3Buttonhead(10);
        }
    explode([20, 0, 0], show_line=false) {
        XY_Motor_Mount_Left_CF_assembly();
        XY_Idler_Bracket_Left_assembly();
    }
    leftFaceHardware(xyMotorType(), cnc=true);
    *if (_useFrontSwitch) {
        explode([25, 0, 0])
            Switch_Shroud_assembly();
        Switch_Shroud_bolts(counterSunk=false);
    }
}

module rightFaceIEC() {
    translate(iecPosition())
        rotate([0, 90, 0]) {
            iec(iecType());
            translate([0, -12, 2 + eps])
                rotate(90)
                    not_on_bom() no_explode()
                        rocker(small_rocker, "red");
        }
}

module rightFaceIEC_hardware() {
    translate(iecPosition() + [3, 0, 0])
        rotate([0, 90, 0]) {
            iec_screw_positions(iecType())
                boltM3Countersunk(12);
        }
}

//! 1. Bolt the **Front_Face_Joiner**, the **Right_Face_Back_Joiner**, and the **Right_Face_Upper_Joiner** to the
//!**Right_Face**
//! 2. Bolt the **XY_Idler_Bracket_Right_assembly** and the **XY_Motor_Mount_Right_CF_assembly** to the **Right_Face**
//! 3. Bolt the extruder, cork damper and stepper motor to the **Right_Face**.
//
module Right_Face_CF_assembly() pose(a=[55, 0, 25 + 50 - 20])
assembly("Right_Face_CF", big=true) {

    translate([eX + 2*eSizeX + eps, 0, 0]) {
        rotate([90, 0, 90]) {
            Right_Face_CF();
            explode(-20, show_line=false) {
                translate([0, 0, -eSizeXBase - _sidePlateThickness])
                    stl_colour(pp2_colour)
                        Front_Face_Joiner_stl();
                rotate([180, 0, 0]) {
                    stl_colour(pp2_colour)
                        Right_Face_Upper_Joiner_stl();
                    stl_colour(pp2_colour)
                        Right_Face_Back_Joiner_stl();
                }
            }
            *lowerSideJoinerHolePositions(left=false)
                explode(10, true)
                    boltM3Buttonhead(screw_shorter_than(topBoltHolderSize().z + _sidePlateThickness));
            upperSideJoinerHolePositions()
                explode(10, true)
                    boltM3Buttonhead(8);
            backSideJoinerHolePositions()
                explode(10, true)
                    boltM3Buttonhead(10);
            frontSideJoinerHolePositions()
                explode(10, true)
                    boltM3Buttonhead(10);
            xyMotorMountHolePositions(_xyNEMA_width, left=false)
                explode(10, true)
                    boltM3Buttonhead(10);
            xyIdlerBracketHolePositions(_xyNEMA_width)
                explode(10, true)
                    boltM3Buttonhead(10);
        }
    }
    explode([-20, 0, 0], show_line=false) {
        XY_Motor_Mount_Right_CF_assembly();
        XY_Idler_Bracket_Right_assembly();
    }
    rightFaceHardware(xyMotorType(), cnc=true);
    rightFaceAssembly(_xyNEMA_width, zipTies=false);
}
