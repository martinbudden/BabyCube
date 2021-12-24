//! Display the X carriage

include <../scad/global_defs.scad>
include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/blowers.scad>

include <../scad/printed/Printhead.scad>
use <../scad/printed/PrintheadAssemblies.scad>
use <../scad/printed/X_Carriage.scad>
use <../scad/printed/X_CarriageAssemblies.scad>

include <../scad/utils/carriageTypes.scad>
include <../scad/Parameters_Main.scad>

//$explode = 1;
//$pose = 1;
module X_Carriage_test() {
    //echo(fho150=railFirstHoleOffset(MGN9, 150));
    //echo(fho200=railFirstHoleOffset(MGN9, 200));

    xCarriageType = carriageType(_xCarriageDescriptor);

    //rotate([0, 90, 0]) X_Carriage_stl();
    //X_Carriage_assembly();
    X_Carriage_Belt_Side_MGN9C_assembly();
    translate([xCarriageBeltAttachmentMGN9CExtraX()/2, 0, 0])
        xCarriageBeltClampAssembly(xCarriageType);
    X_Carriage_Groovemount_MGN9C_assembly();

    //let($preview=false)
    *translate([-xCarriageHotendSideSize(xCarriageType).x/2, carriage_size(xCarriageType).y/2, 0])
        xCarriageTop(xCarriageType);
    hotendDescriptor = "E3DV6";
    blower_type = BL30x10;
    *hotEndHolderHardware(xCarriageType, hotendDescriptor);
    *translate(hotendClampOffset(xCarriageType, hotendDescriptor))
        rotate([90, 0, -90]) {
            Hotend_Clamp_stl();
            Hotend_Clamp_hardware(xCarriageType, blower_type, countersunk=true);
        }
}

if ($preview)
    X_Carriage_test();
