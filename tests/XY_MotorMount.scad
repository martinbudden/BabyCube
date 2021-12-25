//! Display the XY motor mounts

include <../scad/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

include <../scad/printed/XY_Motors.scad>
include <../scad/printed/XY_MotorMountCF.scad>

include <../scad/Parameters_Main.scad>


NEMA_type = xyMotorType();

//$explode = 1;
//$pose = 1;
module XY_MotorMount_test() {
    left = true;
    echo(XY_MotorMountSize=XY_MotorMountSize(NEMA_width(NEMA_type)));
    //XY_MotorUpright(NEMA_type, left);
    //XY_MotorMount(NEMA_type, left, basePlateThickness = 5, offset = basePlateThickness + eZ-coreXYPosBL(NEMA_width(NEMA_type)).z+(left?0:coreXYSeparation().z));
    //XY_MotorMountHardware(NEMA_type);
    XY_Motor_Mount_Left_stl();
    translate([50, 0, 0])
        rotate(180)
            XY_Motor_Mount_Right_stl();
}

if ($preview)
    XY_MotorMount_test();
