include <../global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/dogbones.scad>
include <NopSCADlib/vitamins/rod.scad>
include <NopSCADlib/vitamins/sheets.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <NopSCADlib/vitamins/pcb.scad>

include <../vitamins/bolts.scad>

include <BackFace.scad>
use <Printbed.scad>
use <Printbed3point.scad>
include <XY_Motors.scad>
include <Z_MotorMount.scad>

include <../Parameters_CoreXY.scad>
use <../Parameters_Positions.scad>


module Back_Face_stl() {
    stl("Back_Face")
        color(pp2_colour)
            backFace(zMotorType());
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
            backFaceUpperBrackets(_xyNEMA_width, _topPlateThickness);// use_xyNEMA_width or rail offset
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
        yRailOffset = yRailOffset(_xyNEMA_width).x - (rail_width(railType(_yCarriageDescriptor)) + 3)/2;
        if (_backFaceTopCutouts)
            backFaceTopCutouts(yRailOffset=yRailOffset);
    }
}

//! Attach the SK brackets to the **Back_Face**. Note the orientation of the tightening bolts: the top tightening bolts should
//! face inward and the bottom tightening bolts should face outward. This allows access after the BabyCube is fully assembled.
module Back_Face_Stage_1_assembly()
assembly("Back_Face_Stage_1", big=true, ngb=true) {

    translate([0, eY + 2*eSizeY + eps, 0])
        rotate([90, 0, 0]) {
            stl_colour(pp2_colour)
                Back_Face_stl();
            backFaceUpperBracketsHardware(_backPlateThickness, _topPlateThickness, counterSunk=true);
            backFaceLowerBracketsHardware(_backPlateThickness , counterSunk=true);
        }
    // create back face for NEMA_motors with integrated leadscrew, if integrated leadscrew not already specified
    if (!is_list(NEMA_shaft_length(zMotorType())))
        hidden() Back_Face_NEMA_17_40_stl();
}


//!1. Slide the linear rods through the SK brackets and the printbed bearings.
//!2. Tighten the bolts in the SK brackets, ensuring the **Z_Carriage** slides freely on the rods.
//!3. Place the cork damper on the stepper motor and thread the lead screw through the leadnut and attach the stepper motor
//!   to the **Back_Face**. Note the orientation of the JST socket.
module Back_Face_assembly(bedHeight=bedHeight())
assembly("Back_Face", big=true) {
    Back_Face_Stage_1_assembly();

    zRodOffsetX = (eX + 2*eSizeX - _zRodSeparation)/2;
    translate([0, eY + 2*eSizeY, 0])
        rotate([90, 0, 0]) {
            explode([0, 160, 0])
                for (x = [zRodOffsetX, zRodOffsetX + _zRodSeparation])
                    translate([x, _zRodLength/2, _zRodOffsetY])
                        rotate([90, 0, 0])
                            rod(d=_zRodDiameter, l=_zRodLength);
            backFaceMotorMountHardware(zMotorType());
        }
    translate_z(bedHeight)
        explode(50, show_line=false)
            if (_printBedSize == 100)
                Print_bed_assembly();
            else
                Print_bed_3_point_printed_assembly();
    //cameraType = rpi_camera_v1;
    *translate([eX/2 + _zRodSeparation/4, eY + 2*eSizeY - 0*_backPlateThickness - camera_connector_size(cameraType).z - pcb_thickness(camera_pcb(cameraType)), eZ - 60])
        rotate([90, -135, 0])
            camera(cameraType);
}

module Back_Face_CF_dxf() {
    size = [eX + 2*eSizeX, eZ];

    dxf("Back_Face_CF")
        difference() {
            sheet_2D(CF3, size.x, size.y);
            translate([-size.x/2, -size.y/2]) {
                backFaceSideCutouts(cnc=true, plateThickness=_backPlateCFThickness, dogBoneThickness=0);
                yRailOffset = yRailOffset(_xyNEMA_width).x - (rail_width(railType(_yCarriageDescriptor)) + 3)/2;
                backFaceTopCutouts(cnc=true, plateThickness=_backPlateCFThickness, dogBoneThickness=0, yRailOffset=yRailOffset);
                // add the bolt holes for attachment to the left and right faces
                backFaceAllHolePositions(cf=true)
                    circle(r=M3_clearance_radius);
                backFaceCFTopHolePositions()
                    circle(r=M3_clearance_radius);
                backFaceCFSideHolePositions()
                    circle(r=M3_clearance_radius);
                backFaceBracketHolePositions(-_backPlateThickness, cnc=true)
                    circle(r=M3_clearance_radius);
                backFaceUpperBracketOffset = is_undef(_backFaceUpperBracketOffset) ? _topPlateThickness : _backFaceUpperBracketOffset;
                backFaceUpperSKBracketHolePositions(backFaceUpperBracketOffset)
                    circle(r=M5_clearance_radius);
                backFaceLowerSKBracketHolePositions()
                    circle(r=M5_clearance_radius);
                if (_fullLengthYRail)
                    railsCutout(_xyNEMA_width, yRailOffset(_xyNEMA_width), cnc=true);
                xyMotorMountBackHolePositions(left=true)
                    circle(r=M3_clearance_radius);
                xyMotorMountBackHolePositions(left=false)
                    circle(r=M3_clearance_radius);
                Z_MotorMountHolePositions(zMotorType())
                    circle(r=M3_clearance_radius);
                // cutouts for zipties
                *zipTiePositions()
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

//!1. Bolt the **Z_Motor_Mount** to the **Back_Face**.
//!2. Attach the SK brackets to the **Back_Face**. Note the orientation of the tightening bolts: the top tightening bolts should
//!face inward and the bottom tightening bolts should face outward. This allows access after the BabyCube is fully assembled.
//
module Back_Face_CF_Stage_1_assembly()
assembly("Back_Face_CF_Stage_1", big=true) {

    translate([0, eY + 2*eSizeY, 0])
        rotate([90, 0, 0]) {
            Back_Face_CF();
            backFaceUpperBracketOffset = is_undef(_backFaceUpperBracketOffset) ? _topPlateThickness : _backFaceUpperBracketOffset;
            backFaceUpperBracketsHardware(_backPlateCFThickness, backFaceUpperBracketOffset, counterSunk=false);
            backFaceLowerBracketsHardware(_backPlateCFThickness, counterSunk=false);
            Z_MotorMountHolePositions(zMotorType())
                vflip()
                    translate_z(_backPlateCFThickness)
                        boltM3Buttonhead(12);
            *backFaceBracketHolePositions(-_backPlateCFThickness)
                vflip()
                    boltM3Buttonhead(10);
            explode(20, show_line=false)
                translate([eX/2 + eSizeX, 0, _zLeadScrewOffset])
                    rotate([90, -90, 0])
                        stl_colour(pp1_colour)
                            Z_Motor_Mount_stl();
        }
}

//!1. Slide the linear rods through the SK brackets and the printbed bearings.
//!2. Tighten the bolts in the SK brackets, ensuring the **Z_Carriage** slides freely on the rods.
//!3. Place the cork damper on the stepper motor and thread the lead screw through the leadnut and attach the stepper
//!motor to the **Back_Face**. Note the orientation of the JST socket.
//
module Back_Face_CF_assembly(bedHeight=bedHeight())
assembly("Back_Face_CF", big=true) {
    Back_Face_CF_Stage_1_assembly();

    zRodOffsetX = (eX + 2*eSizeX - _zRodSeparation)/2;
    translate([0, eY + 2*eSizeY, 0])
        rotate([90, 0, 0]) {
            explode([0, 160, 0])
                for (x = [zRodOffsetX, zRodOffsetX + _zRodSeparation])
                    translate([x, _zRodLength/2, _zRodOffsetY])
                        rotate([90, 0, 0])
                            rod(d=_zRodDiameter, l=_zRodLength);
            backFaceMotorMountHardware(zMotorType());
        }
    explode(50, show_line=false)
        translate_z(bedHeight) {
            if (_printBedSize == 100)
                Print_bed_assembly();
            else
                Print_bed_3_point_printed_assembly();
        }
}
