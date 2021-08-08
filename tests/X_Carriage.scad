//! Display the X carriage

include <../scad/global_defs.scad>
include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/blowers.scad>

use <../scad/printed/Printhead.scad>
use <../scad/printed/PrintheadAssemblies.scad>
use <../scad/printed/X_Carriage.scad>
use <../scad/printed/X_CarriageAssemblies.scad>

use <../scad/utils/carriageTypes.scad>
include <../scad/Parameters_Main.scad>

//$explode = 1;
//$pose = 1;
module X_Carriage_test() {
    //echo(fho150=railFirstHoleOffset(MGN9, 150));
    //echo(fho200=railFirstHoleOffset(MGN9, 200));

    xCarriageType = xCarriageType();
    hotend_type = 0;

    //rotate([0, 90, 0]) X_Carriage_stl();
    //X_Carriage_assembly();
    //rotate([0, 90, 0]) X_Carriage_Front_stl();
    //X_Carriage_Front_assembly();
    //xCarriageFrontBolts(xCarriageType(), xCarriageFrontSize(xCarriageType, _beltWidth, clamps=true));
    X_Carriage_Belt_Side_MGN9C_assembly();
    X_Carriage_Groovemount_MGN9C_assembly();

    //let($preview=false)
    *translate([-xCarriageBackSize(xCarriageType).x/2, carriage_size(xCarriageType).y/2, 0])
        xCarriageTop(xCarriageType);
    //xCarriageBack(xCarriageType, xCarriageBackSize(xCarriageType, _beltWidth, clamps=true), beltOffsetZ(), _beltWidth, coreXYSeparation().z);
    //xCarriageBottom(xCarriageType);
    //X_CarriageBelt_Tensioner_stl();
    //X_Carriage_Belt_Clamp_stl();
    blower_type = BL30x10;
    hotEndHolderHardware(xCarriageType, hotend_type);
    translate(hotendClampOffset(xCarriageType, hotend_type))
        rotate([90, 0, -90]) {
            Hotend_Clamp_stl();
            Hotend_Clamp_hardware(xCarriageType, blower_type, countersunk=true);
        }
}

if ($preview)
    X_Carriage_test();
