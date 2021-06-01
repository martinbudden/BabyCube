//! Display the print head

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/vitamins/rails.scad>

use <../scad/printed/Base.scad>
use <../scad/printed/Extras.scad>
use <../scad/printed/Printhead.scad>
use <../scad/printed/PrintheadAssemblies.scad>
use <../scad/printed/X_Carriage.scad>
use <../scad/printed/X_CarriageAssemblies.scad>

use <../scad/utils/carriageTypes.scad>
use <../scad/utils/CoreXYBelts.scad>
use <../scad/utils/printParameters.scad>
use <../scad/utils/X_rail.scad>

use <../scad/Parameters_CoreXY.scad>
include <../scad/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module Printhead_test() {
    echoPrintSize();
    xCarriageType = xCarriageType();

    //let($hide_bolts=true)
    *translate(-[ eSizeX + eX/2, carriagePosition().y, eZ - yRailOffset(_xyNEMA_width).x - carriage_clearance(xCarriageType) ]) {
        fullPrinthead();
        CoreXYBelts(carriagePosition(), x_gap=2);
        xRail(xCarriageType(), _xRailLength);
        bowdenTube();
        //Back_Face_assembly();
        //printheadWiring();
    }
    //X_Carriage_assembly();
    //hotEndHolderHardware(xCarriageType);
    let($hide_bolts=true)
    Print_head_assembly();
    //Fan_Duct_stl();
    //X_Carriage_stl();
    //Hotend_Clamp_stl();
    //Hotend_Clamp_hardware(xCarriageType, 0, BL30x10);
    //grooveMountClamp(xCarriageType, 0, BL30x10);
    //grooveMountClampHardware();
    //hotEndHolder(xCarriageType());
    //Hotend_Strain_Relief_Clamp_stl();
}

if ($preview)
    Printhead_test();
