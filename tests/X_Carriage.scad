//! Display the X carriage

include <../scad/config/global_defs.scad>
include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/blowers.scad>

use <../scad/printed/PrintheadAssemblies.scad>
use <../scad/printed/X_Carriage.scad>
use <../scad/printed/X_CarriageE3DV6.scad>
use <../scad/printed/X_CarriageBeltAttachment.scad>
use <../scad/printed/X_CarriageAssemblies.scad>

include <../scad/utils/carriageTypes.scad>
include <../scad/config/Parameters_Main.scad>

//$explode = 1;
//$pose = 1;
module X_Carriage_test() {
    //echo(fho150=railFirstHoleOffset(MGN9, 150));
    //echo(fho200=railFirstHoleOffset(MGN9, 200));
    halfCarriage = !true;

    xCarriageType = carriageType(_xCarriageDescriptor);

    //rotate([0, 90, 0]) X_Carriage_stl();
    //X_Carriage_assembly();
    if (halfCarriage)
        X_Carriage_Belt_Side_MGN9C_HC_assembly();
    else
        X_Carriage_Belt_Side_MGN9C_assembly();
    translate([xCarriageBeltAttachmentMGN9CExtraX()/2, 0, 0])
        xCarriageBeltClampAssembly(xCarriageType);
    //xCarriageGroovemountMGN9CAssembly(halfCarriage=halfCarriage);
    translate_z(-carriage_height(MGN9C_carriage)) carriage(MGN9C_carriage);

    //let($preview=false)
    *translate([-xCarriageHotendSideSize(xCarriageType).x/2, carriage_size(xCarriageType).y/2, 0])
        xCarriageTop(xCarriageType);
    hotendDescriptor = "E3DV6";
    blower_type = BL30x10;
    *translate(hotendOffset(xCarriageType, hotendDescriptor))
        rotate([90, 0, -90]) {
            E3DV6_Clamp_stl();
            E3DV6_Clamp_hardware(xCarriageType, blower_type, countersunk=true);
        }
}

//X_Carriage_Belt_Tensioner_stl();
//X_Carriage_Belt_Tensioner_hardware(beltTensionerSize, beltWidth());
//xCarriageBeltAttachment( [21, 19.95, 34], beltWidth(), beltSeparation(), cutoutOffsetY=1);
//X_Carriage_Belt_Side_MGN9C_stl();
//let($hide_bolts=true)
//X_Carriage_Belt_Side_MGN9C_assembly();
if ($preview)
    X_Carriage_test();
