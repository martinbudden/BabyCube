//! Display the the Z motor mount

include <../scad/global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../scad/printed/Z_MotorMount.scad>

include <../scad/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module Z_MotorMount_test() {
    //let($preview=false)
    //Z_MotorMount(zNEMA_type());
    vflip()
        Z_Motor_Mount_stl();
    Z_MotorMountHardware(zNEMA_type());
}

if ($preview)
    Z_MotorMount_test();
