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
use <../scad/printed/PrintheadAssembliesDropEffectXG.scad>
use <../scad/printed/X_Carriage.scad>
use <../scad/printed/X_CarriageDropEffectXG.scad>
use <../scad/printed/X_CarriageAssemblies.scad>

include <../scad/utils/printParameters.scad>
include <../scad/utils/X_Rail.scad>
use <../scad/vitamins/DropEffectXG.scad>

include <../scad/config/Parameters_CoreXY.scad>
include <../scad/utils/CoreXYBelts.scad>



//$explode = 1;
//$pose = 1;
module Printhead_test() {
    echoPrintSize();
    xCarriageType = carriageType(_xCarriageDescriptor);
    carriagePosition = carriagePosition() + [yRailOffset(_xyNEMA_width).x, 0];

    //E3DRevoVoron();
    //DropEffectXG();
    //Printhead_DropEffect_XG_MGN9C_assembly();
    //X_Carriage_DropEffect_XG_MGN9C_stl();

    //translate_z(50) Printhead_DropEffect_XG_MGN9C_assembly(); // clearance of 50-46=4 from bottome of xCarriage
    //translate([50, 0, 50]) Printhead_E3DRevo_MGN9C_assembly(); // clearance of 2.8 from bottom of xCarriage
    //translate([-60, 0, 53.25]) Printhead_E3DV6_MGN9C_assembly(); // nozzle clearance of 7.25 from bottom of xCarriage, fan duct has less clearance

    translate(-[ carriagePosition.x, carriagePosition.y, eZ - yRailOffset(_xyNEMA_width).x - carriage_clearance(xCarriageType) ]) {
        //printheadBeltSide(halfCarriage=false, reversedBelts=true);
        printheadHotendSideDropEffectXG(boltLength=0);
        //printheadHotendSideE3DRevo(boltLength=0);
        //printheadHotendSideE3DV6(halfCarriage=false, noPrinthead=!true, boltLength=0);
        //CoreXYBelts(carriagePosition);
        //xRail(carriagePosition(), xCarriageType, _xRailLength, carriageType(_yCarriageDescriptor));
        //bowdenTube(carriagePosition, "DropEffectXG");
        //printheadWiring(carriagePosition, "DropEffectXG",  backFaceZipTiePositions());
    }
    //X_Carriage_assembly();
    //let($hide_bolts=true) Printhead_assembly();
}

if ($preview)
    rotate(90)
        Printhead_test();
