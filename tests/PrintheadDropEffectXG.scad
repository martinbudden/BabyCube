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

    //E3DRevoVoron();
    //DropEffectXG();
    //translate_z(50) Printhead_DropEffect_XG_MGN9C_assembly(); // clearance of 50-46=4 from bottome of xCarriage
    //translate([50, 0, 50]) Printhead_E3DRevo_MGN9C_assembly(); // clearance of 2.8 from bottom of xCarriage
    //translate([-50, 0, 53.25]) Printhead_E3DV6_MGN9C_assembly(); // nozzle clearance of 7.25 from bottom of xCarriage, fan duct has less clearance
    translate(-[ eSizeX + eX/2, carriagePosition().y, eZ - yRailOffset(_xyNEMA_width).x - carriage_clearance(xCarriageType) ]) {
        //printheadBeltSide(halfCarriage=false);
        printheadHotendSideDropEffectXG(boltLength=0);
        //printheadHotendSideE3DRevo(boltLength=0);
        //printheadHotendSideE3DV6(halfCarriage=false, noPrinthead=!true, boltLength=0);
        //CoreXYBelts(carriagePosition(), x_gap=2);
        //xRail(carriagePosition(), xCarriageType, _xRailLength, carriageType(_yCarriageDescriptor));
        bowdenTube(carriagePosition(), "DropEffectXG");
        assert(is_list(zipTiePositions()));
        assert(!is_undef(zipTiePositions()[0].x));
        printheadWiring(carriagePosition(), "DropEffectXG", zipTiePositions());
    }
    //X_Carriage_assembly();
    //let($hide_bolts=true) Printhead_assembly();
}

if ($preview)
    Printhead_test();
