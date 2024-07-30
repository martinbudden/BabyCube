//! Display the the Z motor mount

include <../scad/config/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

include <../scad/printed/Z_MotorMount.scad>

include <../scad/config/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module Z_MotorMount_test() {
    //let($preview=false)
    //Z_MotorMount(zMotorType());
    vflip()
        Z_Motor_Mount_stl();
    Z_MotorMountHardware(zMotorType());
}

if ($preview)
    Z_MotorMount_test();
