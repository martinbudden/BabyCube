include <../global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <../utils/motorTypes.scad>
include <XY_Motors.scad>

module XY_Motor_Mount_Left_stl() {
    NEMA_type = NEMA14T;
    NEMA_width = NEMA_width(NEMA_type);

    stl("XY_Motor_Mount_Left")
        color(pp1_colour)
            XY_MotorMount(NEMA_type, left=true, basePlateThickness=basePlateThickness, offset=eZ - xyMotorPosition(NEMA_width, left=true).z, cf=true);
}

module XY_Motor_Mount_Right_stl() {
    NEMA_type = NEMA14T;
    NEMA_width = NEMA_width(NEMA_type);

    stl("XY_Motor_Mount_Right")
        color(pp1_colour)
            mirror([0, 1, 0])
                XY_MotorMount(NEMA_type, left=false, basePlateThickness=basePlateThickness, offset=eZ - xyMotorPosition(NEMA_width, left=false).z, cf=true);
}

module XY_Motor_Mount_Left_NEMA_17_stl() {
    NEMA_type = NEMA17_40;
    NEMA_width = NEMA_width(NEMA_type);

    stl("XY_Motor_Mount_Left_NEMA_17")
        color(pp1_colour)
            XY_MotorMount(NEMA_type, left=true, basePlateThickness=basePlateThickness, offset=eZ - xyMotorPosition(NEMA_width, left=true).z, cf=true);
}

module XY_Motor_Mount_Right_NEMA_17_stl() {
    NEMA_type = NEMA17_40;
    NEMA_width = NEMA_width(NEMA_type);

    stl("XY_Motor_Mount_Right_NEMA_17")
        color(pp1_colour)
            mirror([0, 1, 0])
                XY_MotorMount(NEMA_type, left=false, basePlateThickness=basePlateThickness, offset=eZ - xyMotorPosition(NEMA_width, left=false).z, cf=true);
}

//!1. Place the cork damper on the stepper motor and bolt the motor to the **XY_Motor_Mount_Left**.
//! Note the cork damper is important as it provides thermal insulation between the stepper motor and the frame.
//! Note orientation of the JST connector.
//!2. Bolt the pulley to the motor shaft.
//
module XY_Motor_Mount_Left_CF_assembly()
assembly("XY_Motor_Mount_Left_CF", big=true, ngb=true) {

    NEMA_type = xyMotorType();
    NEMA_width = NEMA_width(NEMA_type);

    translate([-eps, 0, 0])
        rotate([90, 0, 90])
            XY_MotorPosition(NEMA_width, left=true) {
                stl_colour(pp1_colour)
                    if (_xyMotorDescriptor == "NEMA14")
                        XY_Motor_Mount_Left_stl();
                    else
                        XY_Motor_Mount_Left_NEMA_17_stl();
                XY_MotorMountHardware(NEMA_type);
            }
}

//!1. Place the cork damper on the stepper motor and bolt the motor to the **XY_Motor_Mount_Right**.
//! Note the cork damper is important as it provides thermal insulation between the stepper motor and the frame.
//! Note orientation of the JST connector.
//!2. Bolt the pulley to the motor shaft.
//
module XY_Motor_Mount_Right_CF_assembly()
assembly("XY_Motor_Mount_Right_CF", big=true, ngb=true) {

    NEMA_type = xyMotorType();
    NEMA_width = NEMA_width(NEMA_type);

    translate([eX + 2 * eSizeX - NEMA_width - _sidePlateThickness - 1, 0, 0])
        rotate([90, 0, 90])
            XY_MotorPosition(NEMA_width, left=false)
                rotate(180) {
                    stl_colour(pp1_colour)
                        if (_xyMotorDescriptor == "NEMA14")
                            XY_Motor_Mount_Right_stl();
                        else
                            XY_Motor_Mount_Right_NEMA_17_stl();
                    XY_MotorMountHardware(NEMA_type);
                }
}
