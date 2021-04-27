//! Display the switch shroud.

include <NopSCADlib/core.scad>
use <../scad/printed/SwitchShroud.scad>


//$explode = 1;
//$pose = 1;
module SwitchShroud_test() {
    //let($hide_bolts=true)
    Switch_Shroud_assembly();
    *Switch_Shroud_stl();
    *translate([32, -10, 2.5]) hflip()
        Switch_Shroud_Clamp_stl();
}

//if ($preview)
    SwitchShroud_test();
