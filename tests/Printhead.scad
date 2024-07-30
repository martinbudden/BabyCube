//! Display the print head

include <../scad/config/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <../scad/utils/carriageTypes.scad>

include <NopSCADlib/vitamins/blowers.scad>

use <../scad/printed/Base.scad>
include <../scad/printed/Extras.scad>
use <../scad/printed/PrintheadAssemblies.scad>
use <../scad/printed/PrintheadAssembliesE3DV6.scad>
use <../scad/printed/X_Carriage.scad>
use <../scad/printed/X_CarriageAssemblies.scad>

include <../scad/utils/printParameters.scad>
include <../scad/utils/X_Rail.scad>

include <../scad/config/Parameters_CoreXY.scad>
include <../scad/utils/CoreXYBelts.scad>



//$explode = 1;
//$pose = 1;
module Printhead_test() {
    echoPrintSize();
    xCarriageType = carriageType(_xCarriageDescriptor);
    echo(coreXYSeparation=coreXYSeparation());
    halfCarriage = !true;

    //let($hide_bolts=true)
    translate(-[ eSizeX + eX/2, carriagePosition().y, eZ - yRailOffset(_xyNEMA_width).x - carriage_clearance(xCarriageType) ]) {
        //printheadBeltSide(halfCarriage=halfCarriage);
        printheadHotendSideE3DV6(halfCarriage=halfCarriage);
        //CoreXYBelts(carriagePosition(), x_gap=2);
        //xRail(carriagePosition(), xCarriageType, _xRailLength, carriageType(_yCarriageDescriptor));
        //bowdenTube(carriagePosition());
        //Back_Face_assembly();
        //printheadWiring(carriagePosition());
    }
    //X_Carriage_assembly();
    //let($hide_bolts=true) Printhead_assembly();
    //Fan_Duct_stl();
    //X_Carriage_stl();
    //E3DV6_Clamp_stl();
    //E3DV6_Clamp_hardware(xCarriageType, BL30x10);
    //grooveMountClamp(xCarriageType, 0, BL30x10);
    //grooveMountClampHardware();
    //Hotend_Strain_Relief_Clamp_stl();
}

//let($hide_bolts=true)
if ($preview)
    Printhead_test();
