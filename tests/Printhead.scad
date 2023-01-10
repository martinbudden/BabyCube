//! Display the print head

include <../scad/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <../scad/utils/carriageTypes.scad>

include <NopSCADlib/vitamins/blowers.scad>

use <../scad/printed/Base.scad>
include <../scad/printed/Extras.scad>
include <../scad/printed/Printhead.scad>
use <../scad/printed/PrintheadAssemblies.scad>
use <../scad/printed/X_Carriage.scad>
use <../scad/printed/X_CarriageAssemblies.scad>

include <../scad/utils/CoreXYBelts.scad>
include <../scad/utils/printParameters.scad>
include <../scad/utils/X_Rail.scad>



//$explode = 1;
//$pose = 1;
module Printhead_test() {
    echoPrintSize();
    xCarriageType = carriageType(_xCarriageDescriptor);
    echo(coreXYSeparation=coreXYSeparation());

    //let($hide_bolts=true)
    translate(-[ eSizeX + eX/2, carriagePosition().y, eZ - yRailOffset(_xyNEMA_width).x - carriage_clearance(xCarriageType) ]) {
        printheadBeltSide();
        printheadHotendSide();
        CoreXYBelts(carriagePosition(), x_gap=2);
        xRail(carriagePosition(), xCarriageType, _xRailLength, carriageType(_yCarriageDescriptor));
        //bowdenTube(carriagePosition());
        //Back_Face_assembly();
        //printheadWiring(carriagePosition());
    }
    //X_Carriage_assembly();
    //let($hide_bolts=true) Printhead_assembly();
    //hotEndHolderHardware(xCarriageType);
    //Fan_Duct_stl();
    //X_Carriage_stl();
    //Hotend_Clamp_stl();
    //Hotend_Clamp_hardware(xCarriageType, BL30x10);
    //grooveMountClamp(xCarriageType, 0, BL30x10);
    //grooveMountClampHardware();
    //Hotend_Strain_Relief_Clamp_stl();
}

if ($preview)
    Printhead_test();
