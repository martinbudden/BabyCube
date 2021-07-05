include <../global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rockers.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../utils/carriageTypes.scad>

use <../vitamins/bolts.scad>
use <../vitamins/cables.scad>
use <../vitamins/extruder.scad>

use <LeftAndRightFaces.scad>
use <SwitchShroud.scad>
use <XY_IdlerBracket.scad>
use <XY_MotorMount.scad>

use <../Parameters_CoreXY.scad>
include <../Parameters_Main.scad>


module Left_Face_stl() {
    stl("Left_Face")
        color(pp1_colour)
            leftFace(NEMA14T());
            //cube([eY + 2*eSizeY, eZ, eSizeX]);
}

module Left_Face_NEMA_17_stl() {
    stl("Left_Face_NEMA_17")
        color(pp1_colour)
            leftFace(NEMA17M);
            //cube([eY + 2*eSizeY, eZ, eSizeX]);
}

module Right_Face_stl() {
    stl("Right_Face")
        color(pp1_colour)
            rightFace(NEMA14T());
}

module Right_Face_NEMA_17_stl() {
    stl("Right_Face_NEMA_17")
        color(pp1_colour)
            rightFace(NEMA17M);
            //cube([eY + 2*eSizeY, eZ, eSizeX]);
}

module leftFaceAssembly() {
    translate([-eps, 0, 0])
        rotate([90, 0, 90]) {
            if (_xyMotorDescriptor=="NEMA14") {
                Left_Face_stl();
                *hidden()
                    Left_Face_NEMA_17_stl();
            } else {
                Left_Face_NEMA_17_stl();
                *hidden()
                    Left_Face_stl();
            }
        }
}

module leftFaceHardware(NEMA_type, rocker=true) {
    rotate([90, 0, 90]) {
        XY_IdlerBracketHardware(coreXYPosBL(NEMA_width(NEMA_type), yCarriageType()));
        XY_MotorUprightHardware(NEMA_type, left=true);
        stepper_motor_cable(400);
        if (!exploded())
            leftAndRightFaceZipTies(left=true);
        if (rocker)
            translate(rockerPosition(rocker_type()))
                rotate([0, -90, 0])
                    rocker(rocker_type(), "red");
    }
}

//!
//!1. Place the cork damper on the stepper motor and bolt the motor to the frame.
//! Note the cork damper is important as it provides thermal insulation between the stepper motor and the frame.
//! Note orientation of the JST connector.
//!2. Secure the motor wires with zip ties.
//!3. Bolt the two front idler pulleys with washers to the frame.
//!4. Attach the wires to the switch and bolt the Switch_Shroud to the left face.
module Left_Face_assembly() pose(a=[55, 0, 25 + 50])
assembly("Left_Face", big=true) {

    stl_colour(pp1_colour)
        leftFaceAssembly();
    leftFaceHardware(xyMotorType());
    explode([25, 0, 0])
        Switch_Shroud_assembly();
    Switch_Shroud_bolts();
}

module Right_Face_with_Inserts_assembly() pose(a=[55, 0, 25 + 180])
assembly("Right_Face_with_Inserts", big=true) {
    stl_colour(pp1_colour)
        rightFacePart1Assembly();
    translate([eX + 2 * eSizeX + eps, 0, 0])
        rotate([90, 0, 90])
            vflip()
                mirror([0, 1, 0])
                    XY_IdlerBracketThreadedInsert(coreXYPosBL(NEMA_width));
}

module rightFaceStage1Assembly() {
    translate([eX + 2 * eSizeX + eps, 0, 0])
        rotate([90, 0, 90])
            hflip()
                if (_xyMotorDescriptor=="NEMA14") {
                    Right_Face_stl();
                    *hidden()
                        Right_Face_NEMA_17_stl();
                } else {
                    Right_Face_NEMA_17_stl();
                    *hidden()
                        Right_Face_stl();
                }
}

//!1. Place the cork damper on the stepper motor and bolt the motor to the frame.
//! Note the cork damper is important as it provides thermal insulation between the stepper motor and the frame.
//! Note orientation of the JST connector.
//!2. Attach the toothed idler pulleys to the frame, separated by the washers as shown.
//!3. Thread the zip ties through the frame, but do not tighten them yet, since the extruder motor cable will also go through the zip ties.
module Right_Face_Stage_1_assembly() pose(a=[55, 0, 25 + 260])
assembly("Right_Face_Stage_1", big=true, ngb=true) {

    if (_useInsertsForFaces)
        Right_Face_with_Inserts_assembly();
    else
        stl_colour(pp1_colour)
            rightFaceStage1Assembly();
    rightFaceHardware(xyMotorType());
}

module rightFaceAssembly(NEMA_width) {

    stepper_motor_cable(400); // cable to extruder motor
    if (!exploded())
        rightFaceExtruderZipTies(NEMA_width);
    translate(extruderPosition(NEMA_width))
        rotate([90, 0, 90])
            Extruder_MK10_Dual_Pulley(extruderMotorType(), extruderMotorOffsetZ(), corkDamperThickness=_corkDamperThickness);
}


module rightFaceHardware(NEMA_type) {
    translate([eX + 2*eSizeX, 0, 0])
        rotate([90, 0, 90])
            vflip()
                mirror([0, 1, 0]) {
                    XY_IdlerBracketHardware(coreXYPosBL(_xyNEMA_width, yCarriageType()));
                    XY_MotorUprightHardware(NEMA_type, left=false);
                    stepper_motor_cable(400);
                    if (!exploded())
                        leftAndRightFaceZipTies(left=false);
                }
}

//!1. Attach the extruder gear to the stepper motor.
//!2. Place the cork damper on the stepper motor and attach the motor through the frame to the extruder. Note the cork damper is important as it provides thermal insulation between the stepper motor and the frame.
//!3. Secure the cables for both motors with the zip ties.
module Right_Face_assembly()
assembly("Right_Face") {
    Right_Face_Stage_1_assembly();
    rightFaceAssembly(_xyNEMA_width);
}
