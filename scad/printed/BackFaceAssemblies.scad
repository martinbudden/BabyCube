include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/dogbones.scad>
include <NopSCADlib/vitamins/sheets.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../utils/cutouts.scad>
use <../utils/HolePositions.scad>

use <../vitamins/bolts.scad>
use <../vitamins/cables.scad>

use <BackFace.scad>
use <Printbed.scad>
use <Printbed3point.scad>
use <Z_MotorMount.scad>

use <../Parameters_CoreXY.scad>
use <../Parameters_Positions.scad>
include <../Parameters_Main.scad>


module Back_Face_stl() {
    stl("Back_Face")
        color(pp2_colour)
            backFace(zNEMA_type());
}

module Back_Face_NEMA_17_40_stl() {
    stl("Back_Face_NEMA_17_40")
        color(pp2_colour)
            backFace(NEMA17_40L());
}

module backFace(zNEMA_type) {
    difference() {
        union() {
            backFaceBare(zNEMA_type);
            backFaceUpperBrackets(_xyNEMA_width);// use_xyNEMA_width or rail offset
            backFaceLowerBrackets(zNEMA_type);
        }
        // add the bolt holes for attachment to the left and right faces
        backFaceAllHolePositions(-_backPlateThickness)
            boltPolyholeM3Countersunk(2*_backPlateThickness + 1, sink=0.25);
        backFaceBracketHolePositions(-_backPlateThickness)
            boltPolyholeM3Countersunk(2*_backPlateThickness + 1, sink=0.25);
        // add the bolt holes for attachment to the base
        /*backFaceBaseHolePositions()
            rotate([-90, 180, 0])
                boltHoleM3Tap(10, horizontal=true, chamfer_both_ends=false);*/

        if (_backFaceSideCutouts)
            backFaceSideCutouts();
        if (_backFaceTopCutouts)
            backFaceTopCutouts();
    }
}

//!1. Attach the SK brackets to the back face. Note the orientation of the bolts: the top grub screws should face inward and the bottom grub screws should face outward. This allows access after the BabyCube is fully assembled.
//!2. Place the cork damper on the stepper motor and attach the stepper motor to the back face. Note the orientation of the JST socket.
module Back_Face_Stage_1_assembly()
assembly("Back_Face_Stage_1", big=true, ngb=true) {

    translate([0, eY + 2*eSizeY + eps, 0])
        rotate([90, 0, 0]) {
            stl_colour(pp2_colour)
                Back_Face_stl();
            backFaceUpperBracketsHardware(_backPlateThickness, counterSunk=true);
            backFaceLowerBracketsHardware(zNEMA_type(), _backPlateThickness, counterSunk=true);
        }
    // create backface for NEMA_motors with integrated leadscrew, if integrated leadscrew not already specified
    if (!is_list(NEMA_shaft_length(zNEMA_type())))
        hidden()
            Back_Face_NEMA_17_40_stl();
}


//! Slide the linear rods through the SK brackets and the printbed bearings.
//! Tighten the bolts in the SK brackets, ensuring the Z_Carriage slides freely on the rods.
//
module Back_Face_assembly()
assembly("Back_Face", big=true) {
    Back_Face_Stage_1_assembly();

    zRodOffsetX = (eX + 2*eSizeX - _zRodSeparation)/2;
    translate([0, eY + 2*eSizeY, 0])
        rotate([90, 0, 0])
            explode([0, 150, 0])
                for (x = [zRodOffsetX, zRodOffsetX + _zRodSeparation])
                    translate([x, _zRodLength/2, _zRodOffsetY])
                        rotate([90, 0, 0])
                            rod(d=_zRodDiameter, l=_zRodLength);
    explode(50)
        translate_z(bedHeight()) {
            if (_printBedSize == 100)
                Print_bed_assembly();
            else
                Print_bed_3_point_printed_assembly();
        }
}

module Back_Face_CF_dxf() {
    size = [eX + 2*eSizeX, eZ];

    dxf("Back_Face_CF")
        difference() {
            sheet_2D(CF3, size.x, size.y);
            translate([-size.x/2, -size.y/2]) {
                backFaceSideCutouts(cnc=true, plateThickness=_backPlateCFThickness, dogBoneThickness=0);
                backFaceTopCutouts(cnc=true, plateThickness=_backPlateCFThickness, dogBoneThickness=0);
                // add the bolt holes for attachment to the left and right faces
                backFaceAllHolePositions()
                    circle(r=M3_clearance_radius);
                backFaceBracketHolePositions(-_backPlateThickness)
                    circle(r=M3_clearance_radius);
                backFaceUpperSKBracketHolePositions()
                    circle(r=M5_clearance_radius);
                backFaceLowerSKBracketHolePositions()
                    circle(r=M5_clearance_radius);
                railsCutout(_xyNEMA_width, yRailOffset(_xyNEMA_width), cnc=true);
                Z_MotorMountHolePositions(zNEMA_type())
                    circle(r=M3_clearance_radius);
                // cutouts for zipties
                zipTiePositions()
                    for (x = [-4, 4])
                        translate([x, 0])
                            rounded_square([2, 4], r=0.5, center=true);
            }
        }
}

CF3Blue = CF3;//[ "CF3",       "Sheet carbon fiber",      3, [0, 0, 1],                false,  5,  5,  [0, 0, 0.5] ];

module Back_Face_CF() {
    size = [eX + 2*eSizeX, eZ];

    translate([size.x/2, size.y/2, -_backPlateCFThickness])
        render_2D_sheet(CF3Blue, w=size.x, d=size.y)
            Back_Face_CF_dxf();
}

module Back_Face_CF_Stage_1_assembly()
assembly("Back_Face_CF_Stage_1", big=true) {

    translate([0, eY + 2*eSizeY, 0])
        rotate([90, 0, 0]) {
            Back_Face_CF();
            backFaceUpperBracketsHardware(_backPlateCFThickness, counterSunk=false);
            backFaceLowerBracketsHardware(zNEMA_type(), _backPlateCFThickness, counterSunk=false);
            Z_MotorMountHolePositions(zNEMA_type())
                vflip()
                    translate_z(_backPlateCFThickness)
                        boltM3Buttonhead(12);
            *backFaceBracketHolePositions(-_backPlateCFThickness)
                vflip()
                    boltM3Buttonhead(10);
            zRodOffsetX = (eX + 2*eSizeX - _zRodSeparation)/2;
            translate([zRodOffsetX + _zRodSeparation/2, 0, _zLeadScrewOffset])
                rotate([90, -90, 0])
                    stl_colour(pp1_colour)
                        Z_Motor_Mount_stl();
        }
}

module Back_Face_CF_assembly()
assembly("Back_Face_CF", big=true) {
    Back_Face_CF_Stage_1_assembly();

    zRodOffsetX = (eX + 2*eSizeX - _zRodSeparation)/2;
    translate([0, eY + 2*eSizeY, 0])
        rotate([90, 0, 0])
            explode([0, 150, 0])
                for (x = [zRodOffsetX, zRodOffsetX + _zRodSeparation])
                    translate([x, _zRodLength/2, _zRodOffsetY])
                        rotate([90, 0, 0])
                            rod(d=_zRodDiameter, l=_zRodLength);
    explode(50)
        translate_z(bedHeight()) {
            if (_printBedSize == 100)
                Print_bed_assembly();
            else
                Print_bed_3_point_printed_assembly();
        }
}
