//! Display the print head

include <../scad/config/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <../scad/utils/carriageTypes.scad>

include <NopSCADlib/vitamins/blowers.scad>

use <../scad/printed/BackFace.scad> // for zipTiePositions()
use <../scad/printed/Base.scad>
use <../scad/printed/PrintheadExtras.scad>
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
    carriagePosition = carriagePosition() + [yRailOffset(_xyNEMA_width).x, 0];
    echo(coreXYSeparation=coreXYSeparation());
    halfCarriage = !true;

    translate(-[ carriagePosition.x, carriagePosition.y, eZ - yRailOffset(_xyNEMA_width).x - carriage_clearance(xCarriageType) ]) {
        printheadBeltSide(halfCarriage=halfCarriage);
        printheadHotendSideE3DV6(halfCarriage=halfCarriage, boltLength=0);
        CoreXYBelts(carriagePosition);
        //xRail(carriagePosition(), xCarriageType, _xRailLength, carriageType(_yCarriageDescriptor));
        //bowdenTube(carriagePosition, "E3DV6");
        //printheadWiring(carriagePosition, "E3DV6",  backFaceZipTiePositions());
        //Back_Face_assembly();
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
