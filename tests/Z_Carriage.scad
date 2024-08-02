//! Display the Z carriage

use <../scad/printed/Z_Carriage.scad>

include <../scad/config/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module Z_Carriage_test() {
    rotate([180, 0, 0]) {
        Z_Carriage_stl();
        zCarriage_hardware();
    }
    //Z_Carriage_cable_ties(100);
    //Z_Carriage_assembly();
    //zCarriage(testing=true);
}

//let($preview=false)
if ($preview)
    Z_Carriage_test();
else
    Z_Carriage_stl();
