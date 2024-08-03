//! Display the print head

include <../scad/config/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
//include <NopSCADlib/vitamins/screws.scad>
include <../scad/utils/carriageTypes.scad>

include <../scad/printed/Extras.scad>
use <../scad/printed/BackFace.scad> // for printheadWiring
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

    //E3DRevoVoron();
    //DropEffectXG();
    //Printhead_DropEffect_XG_MGN9C_assembly();
    translate(-[ eSizeX + eX/2, carriagePosition().y, eZ - yRailOffset(_xyNEMA_width).x - carriage_clearance(xCarriageType) ]) {
        //printheadBeltSide(halfCarriage=false);
        printheadHotendSideDropEffectXG();
        //printheadHotendSideE3DRevo();
        //printheadHotendSideE3DV6(halfCarriage=false, noPrinthead=!true);
        //CoreXYBelts(carriagePosition(), x_gap=2);
        //xRail(carriagePosition(), xCarriageType, _xRailLength, carriageType(_yCarriageDescriptor));
        //bowdenTube(carriagePosition(), "DropEffectXG");
        //printheadWiring(carriagePosition(), "DropEffectXG");
    }
    //X_Carriage_assembly();
    //let($hide_bolts=true) Printhead_assembly();
}

if ($preview)
    Printhead_test();
