//! Display the the spool holder

include <../scad/global_defs.scad>

include <../scad/printed/SpoolHolder.scad>

//$explode = 1;
//$pose = 1;
module Spool_Holder_test() {
    eSize = 20;
    eSizeX = 8;
    color(pp2_colour)
        spoolHolder(bracketSize=[eSizeX, 30, 20], offsetX=spoolOffset().x, innerFillet=5, spoolInternalRadius=36, capOffset=true);
    //spoolHolder(bracketSize=[eSize, 2*eSize, 20], offsetX=17.5 + 3);
}

if ($preview)
    Spool_Holder_test();
