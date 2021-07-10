//! Display the XY motor mounts

include <../scad/global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../scad/printed/XY_MotorMount.scad>

use <../scad/Parameters_CoreXY.scad>
include <../scad/Parameters_Main.scad>


NEMA_type = xyMotorType();

//$explode = 1;
//$pose = 1;
module XY_MotorMount_test() {
    left = true;
    echo(XY_MotorMountSize=XY_MotorMountSize(NEMA_width(NEMA_type)));
    //XY_MotorUpright(NEMA_type, left);
    //XY_MotorMount(NEMA_type, left, basePlateThickness = 5, offset = basePlateThickness+eZ-coreXYPosBL(NEMA_width(NEMA_type)).z+(left?0:coreXYSeparation().z));
    //XY_MotorMountHardware(NEMA_type);
    XY_Motor_Mount_Left_stl();
    XY_Motor_Mount_Right_stl();
}

if ($preview)
    XY_MotorMount_test();
