include <../config/global_defs.scad>

include <NopSCADlib/vitamins/spools.scad>
use <../printed/LeftAndRightFaces.scad> // for spoolHolderBracketSize()

include <SpoolHolder.scad>
include <../config/Parameters_Main.scad>


module faceRightSpoolHolder(cf=false) {
    translate(spoolHolderPosition(cf))
        explode([40, 0, 90])
            rotate([90, 0, 0])
                stl_colour(pp4_colour)
                    if (cf)
                        Spool_Holder_CF_stl();
                    else
                        Spool_Holder_stl();
}

module faceRightSpool(cf=false) {
    spool = spool_200x60;
    translate(spoolHolderPosition(cf) + spoolOffset(cf))
        translate([0.1 + spool_width(spool)/2 + spool_rim_thickness(spool), 0, -spool_hub_bore(spool)/2])
            rotate([0, 90, 0])
                not_on_bom()
                    spool(spool, 46, "red", 1.75);
}

module Spool_Holder_stl() {
    stl("Spool_Holder")
        color(pp4_colour)
            spoolHolder(spoolHolderBracketSize(cf=false), offsetX=spoolOffset().x, innerFillet=5);
}

/*module Spool_Holder_CF_stl() {
    stl("Spool_Holder_CF")
        color(pp2_colour)
            spoolHolder(spoolHolderBracketSize(cf=true), offsetX=spoolOffset().x, innerFillet=5, endHeight=18);
}*/

module Spool_Holder_CF_stl() {
    eSize = 20;
    stl("Spool_Holder_CF")
        color(pp4_colour)
            spoolHolder(bracketSize=[5, 2*eSize - 10, 20], offsetX=7, catchRadius=0, length=90, capOffset=false);
}

module Spool_Holder_Bracket_stl() {
    stl("Spool_Holder_Bracket")
        color(pp2_colour)
            spoolHolderBracket();
}

