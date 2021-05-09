
include <../global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/spools.scad>

use <../utils/bezierTube.scad>
use <../utils/carriageTypes.scad>
use <../utils/PrintheadOffsets.scad>

use <../vitamins/extruder.scad>

use <LeftAndRightFaces.scad>
use <SpoolHolder.scad>
use <X_Carriage.scad>

use <../Parameters_Positions.scad>
include <../Parameters_Main.scad>


module bowdenTube() {
    explode(120)
        bezierTube(extruderPosition(_xyNEMA_width) + extruderBowdenOffset(), [carriagePosition().x + eSizeX - 6 - xCarriageFrontSize(xCarriageType()).x/2, carriagePosition().y + xCarriageBackOffsetY(xCarriageType()), eZ] + printheadBowdenOffset(), color="white");
}

module faceRightSpoolHolder() {
    explode([75, 0, 100])
        translate(spoolHolderPosition())
            rotate([90, 0, 0])
                stl_colour(pp2_colour)
                    Spool_Holder_stl();
}

module faceRightSpool() {
    spool = spool_200x60;
    explode([150, 0, 0])
        translate(spoolHolderPosition() + spoolOffset())
            translate([0.1 + spool_width(spool)/2 + spool_rim_thickness(spool), 0, -spool_hub_bore(spool)/2])
                rotate([0, 90, 0])
                    not_on_bom()
                        spool(spool, 46, "deepskyblue", 1.75);
}

module Spool_Holder_stl() {
    stl("Spool_Holder")
        color(pp2_colour)
            spoolHolder(bracketSize=[eSizeX, 30, 20], offsetX=spoolOffset().x, innerFillet=5);
}
