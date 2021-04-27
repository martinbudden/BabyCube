//! Displays a reduced implementation to focus on the coreXY part.

include <../scad/global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/core_xy.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../scad/utils/carriageTypes.scad>
use <../scad/utils/CoreXYBelts.scad>
use <../scad/utils/X_Rail.scad>

use <../scad/printed/TopFaceAssemblies.scad>
use <../scad/printed/XY_IdlerBracket.scad>
use <../scad/printed/XY_MotorMount.scad>
use <../scad/printed/X_Carriage.scad>
use <../scad/printed/X_CarriageAssemblies.scad>
use <../scad/printed/PrintheadAssemblies.scad>
use <../scad/printed/Y_CarriageAssemblies.scad>
use <../scad/printed/LeftAndRightFaceAssemblies.scad>

use <../scad/Parameters_CoreXY.scad>
include <../scad/Parameters_Main.scad>
include <../scad/Parameters_Positions.scad>


module CoreXY() {

    echo(coreXY_drive_pulley_x_offset=coreXY_drive_pulley_x_alignment(coreXY_type()));
    echo(coreXYSeparation=coreXYSeparation());

    CoreXYBelts(_xyNEMA_width, carriagePosition, x_gap=16, show_pulleys=false);
    yCarriageAssemblies(_xyNEMA_width);
    XY_Idler_Bracket_Left_assembly();
    XY_Idler_Bracket_Right_assembly();
    //XY_Idler_Left_assembly();
    //XY_Idler_Right_assembly();
    XY_Motor_Mount_Left_assembly();
    XY_Motor_Mount_Right_assembly();
    xRail(xCarriageType(), _xRailLength);
    //let($hide_bolts=true) fullPrinthead(rotate=180);
    xRailCarriagePosition()
        rotate(0) {// rotate 180 to make it easier to see belts
            *rotate([0, 90, 0])
                X_Carriage_stl();
            X_Carriage_assembly();
            X_Carriage_Front_assembly();
            xCarriageBeltFragments(xCarriageType(), beltOffsetZ(), coreXYSeparation().z, coreXY_upper_belt_colour(coreXY_type()), coreXY_lower_belt_colour(coreXY_type()));
        }
}

if ($preview)
    translate_z(-coreXYPosBL(_xyNEMA_width).z)
        CoreXY();


/*
module XY_Motor_Mount_Left_assembly()
assembly("XY_Motor_Mount_Left") {

    rotate([90, 0, 90]) {
        XY_MotorUpright(NEMA_type, left=true);
        XY_MotorUprightHardware(NEMA_type, left=true);
    }
}

module XY_Motor_Mount_Right_assembly()
assembly("XY_Motor_Mount_Right") {

    translate([eX + 2*eSizeX, 0, 0]) {
        rotate([90, 0, 90])
            mirror([0, 0, 1]) {
                XY_MotorUpright(NEMA_type, left=false);
                XY_MotorUprightHardware(NEMA_type, left=false);
        }
    }
}
*/

module XY_Idler_Left_assembly()
assembly("XY_Idler_Left") {

    rotate([90, 0, 90]) {
        XY_IdlerBracket(coreXYPosBL(_xyNEMA_width, yCarriageType()), _xyNEMA_width);
        XY_IdlerBracketHardware(coreXYPosBL(_xyNEMA_width, yCarriageType()));
    }
}

module XY_Idler_Right_assembly()
assembly("XY_Idler_Right") {

    translate([eX + 2*eSizeX, 0, 0])
        rotate([90, 0, 90])
            mirror([0, 0, 1]) {
                XY_IdlerBracket(coreXYPosBL(_xyNEMA_width, yCarriageType()), _xyNEMA_width);
                XY_IdlerBracketHardware(coreXYPosBL(_xyNEMA_width, yCarriageType()));
            }
}
