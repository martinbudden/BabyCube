//! Display the print head

include <../scad/config/global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
//include <NopSCADlib/vitamins/screws.scad>
include <../scad/utils/carriageTypes.scad>

use <../scad/printed/BackFace.scad> // for zipTiePositions()
//use <../scad/printed/LeftAndRightFaces.scad> // for extruderPosition()
//use <../scad/vitamins/extruder.scad> // for extruderBowdenOffset()
use <../scad/printed/PrintheadAssembliesAll.scad>
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
    //X_Carriage_E3DRevo_stl();
    //Printhead_E3DRevo_assembly();
    //Printhead_E3DRevo_40_assembly();

    //E3DRevoVoron();
    //let($hide_bolts=true)
    translate(-[ carriagePosition.x, carriagePosition.y, eZ - yRailOffset(_xyNEMA_width).x - carriage_clearance(xCarriageType) ]) {
        //printheadBeltSide(halfCarriage=false, reversedBelts=true);
        printheadHotendSide("E3DRevo", boltLength=0);
        //printheadHotendSide("E3DRevoCompact", boltLength=0);
        //printheadHotendSide("E3DV6", boltLength=0, halfCarriage=false, noPrinthead=true);
        //CoreXYBelts(carriagePosition);
        //xRail(carriagePosition(), xCarriageType, _xRailLength, carriageType(_yCarriageDescriptor));
        //bowdenTube("E3DRevo", carriagePosition, extruderPosition(_xyNEMA_width) + extruderBowdenOffset());
        //printheadWiring("E3DRevo", carriagePosition, backFaceZipTiePositions());
    }
    //X_Carriage_assembly();
    //let($hide_bolts=true) Printhead_assembly();
}

if ($preview)
    rotate(90)
        Printhead_test();
