
include <../global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/spools.scad>

include <../utils/bezierTube.scad>
include <../utils/carriageTypes.scad>
include <../utils/PrintheadOffsets.scad>

use <../vitamins/extruder.scad>

use <LeftAndRightFaces.scad>
include <SpoolHolder.scad>
use <X_Carriage.scad>

include <../Parameters_Main.scad>


module bowdenTube(carriagePosition, extraZ=120) {
    xCarriageType = carriageType(_xCarriageDescriptor);
    color("White")
        bezierTube(extruderPosition(_xyNEMA_width) + extruderBowdenOffset(), [carriagePosition.x + eSizeX - 6 - xCarriageBeltSideSize(xCarriageType).x/2, carriagePosition.y + xCarriageHotendOffsetY(xCarriageType), eZ] + printheadBowdenOffset(), ptfeTube=true, extraZ=extraZ);
}

module faceRightSpoolHolder(cf=false) {
    translate(spoolHolderPosition(cf))
        rotate([90, 0, 0])
            stl_colour(pp2_colour)
                if (cf)
                    Spool_Holder_CF_stl();
                else
                    Spool_Holder_stl();
}

module faceRightSpool(cf=false) {
    spool = spool_200x60;
    translate(spoolHolderPosition(cf) + spoolOffset())
        translate([0.1 + spool_width(spool)/2 + spool_rim_thickness(spool), 0, -spool_hub_bore(spool)/2])
            rotate([0, 90, 0])
                not_on_bom()
                    spool(spool, 46, "red", 1.75);
}

module Spool_Holder_stl() {
    stl("Spool_Holder")
        color(pp2_colour)
            spoolHolder(spoolHolderBracketSize(cf=false), offsetX=spoolOffset().x, innerFillet=5);
}

module Spool_Holder_CF_stl() {
    stl("Spool_Holder_CF")
        color(pp2_colour)
            spoolHolder(spoolHolderBracketSize(cf=true), offsetX=spoolOffset().x, innerFillet=5, endHeight=18);
}
