//! Displays a reduced implementation to focus on the coreXY part.

include <../scad/global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/core_xy.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../scad/utils/carriageTypes.scad>
use <../scad/utils/CoreXYBelts.scad>
use <../scad/utils/X_rail.scad>

use <../scad/printed/LeftAndRightFaceAssemblies.scad>
use <../scad/printed/PrintheadAssemblies.scad>
use <../scad/printed/TopFaceAssemblies.scad>
use <../scad/printed/XY_IdlerBracket.scad>
use <../scad/printed/XY_MotorMount.scad>
use <../scad/printed/X_Carriage.scad>
use <../scad/printed/X_CarriageAssemblies.scad>
use <../scad/printed/Y_CarriageAssemblies.scad>

use <../scad/Parameters_CoreXY.scad>
use <../scad/Parameters_Positions.scad>
include <../scad/Parameters_Main.scad>


t=2;

module CoreXY() {

    echo(coreXY_drive_pulley_x_offset=coreXY_drive_pulley_x_alignment(coreXY_type()));
    echo(coreXYSeparation=coreXYSeparation());

    CoreXYBelts(carriagePosition());
    translate([0, carriagePosition(t).y - carriagePosition().y, 0])
        yCarriageLeftAssembly(_xyNEMA_width);
    translate([0, carriagePosition(t).y - carriagePosition().y, 0])
        yCarriageRightAssembly(_xyNEMA_width);
    //Left_Face_assembly();
    //Right_Face_assembly();
    //XY_Idler_Bracket_Left_assembly();
    //XY_Idler_Bracket_Right_assembly();
    XY_Idler_Left_assembly();
    XY_Idler_Right_assembly();
    XY_Motor_Mount_Left_assembly();
    XY_Motor_Mount_Right_assembly();
    xRail(carriagePosition(t), xCarriageType(), _xRailLength);
    //let($hide_bolts=true)
    printheadBeltSide(t=t);
    printheadHotendSide(t=t);
    //fullPrinthead(rotate=0, accelerometer=true);
    *xRailCarriagePosition(carriagePosition(), rotate=0) {// rotate 180 to make it easier to see belts
        *rotate([0, 90, 0])
            X_Carriage_stl();
        X_Carriage_assembly();
        X_Carriage_Front_assembly();
        xCarriageBeltFragments(xCarriageType(), coreXY_belt(coreXY_type()), beltOffsetZ(), coreXYSeparation().z, coreXY_upper_belt_colour(coreXY_type()), coreXY_lower_belt_colour(coreXY_type()));
    }
}

if ($preview)
    rotate(-90 + 30)
        translate([-eX/2, -eY/2, -coreXYPosBL(_xyNEMA_width).z])
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
