//! Display the print head

include <../scad/config/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
//include <NopSCADlib/vitamins/screws.scad>
include <../scad/utils/carriageTypes.scad>

use <../scad/printed/BackFace.scad> // for zipTiePositions()
use <../scad/printed/PrintheadExtras.scad>
use <../scad/printed/PrintheadAssemblies.scad>
use <../scad/printed/PrintheadAssembliesE3DRevo.scad>
use <../scad/printed/PrintheadAssembliesE3DV6.scad>
use <../scad/printed/X_Carriage.scad>
use <../scad/printed/X_CarriageE3DRevo.scad>
use <../scad/printed/X_CarriageAssemblies.scad>

include <../scad/utils/printParameters.scad>
include <../scad/utils/X_Rail.scad>
use <../scad/vitamins/E3DRevo.scad>

include <../scad/config/Parameters_CoreXY.scad>
include <../scad/utils/CoreXYBelts.scad>



//$explode = 1;
//$pose = 1;
module Printhead_test() {
    echoPrintSize();
    xCarriageType = carriageType(_xCarriageDescriptor);
    carriagePosition = carriagePosition() + [yRailOffset(_xyNEMA_width).x, 0];
    //echo(xx=yRailOffset(_xyNEMA_width).x); 18.39
    //X_Carriage_E3DRevo_MGN9C_stl();
    //Printhead_E3DRevo_MGN9C_assembly();
    //Printhead_E3DRevo_40_MGN9C_assembly();

    //E3DRevoVoron();
    //let($hide_bolts=true)
    translate(-[ carriagePosition.x, carriagePosition.y, eZ - yRailOffset(_xyNEMA_width).x - carriage_clearance(xCarriageType) ]) {
        printheadBeltSide(halfCarriage=false, reversedBelts=true);
        printheadHotendSideE3DRevo(boltLength=0);
        //printheadHotendSideE3DV6(halfCarriage=false, noPrinthead=true, boltLength=0);
        CoreXYBelts(carriagePosition);
        //xRail(carriagePosition(), xCarriageType, _xRailLength, carriageType(_yCarriageDescriptor));
        //bowdenTube(carriagePosition, "E3DRevo");
        printheadWiring(carriagePosition, "E3DRevo",  backFaceZipTiePositions(), segment=true);
    }
    //X_Carriage_assembly();
    //let($hide_bolts=true) Printhead_assembly();
}

if ($preview)
    Printhead_test();
