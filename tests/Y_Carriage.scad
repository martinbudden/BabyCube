//! Display the Y carriages

include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/pulleys.scad>

use <../scad/printed/X_Carriage.scad>
use <../scad/printed/Y_Carriage.scad>
use <../scad/printed/Y_CarriageAssemblies.scad>

use <../scad/utils/CoreXYBelts.scad>
include <../scad/utils/carriageTypes.scad>

use <../scad/Parameters_Positions.scad>
include <../scad/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module Y_Carriage_test0() {
    translate_z(-eZ + 20) {
        CoreXYBelts(carriagePosition(), x_gap=16, show_pulleys=false);//[1,0,0]);
        yCarriageLeftAssembly(_xyNEMA_width);
        yCarriageRightAssembly(_xyNEMA_width);
    }
}

module Y_Carriage_test1() {

    //Y_Carriage_Left_AL_dxf();
    Y_Carriage_Left_stl();
    yCarriageType = carriageType(_yCarriageDescriptor);
    //Y_Carriage_hardware(yCarriageType, yCarriageThickness(), yCarriageBraceThickness(), pulleyOffset(), pulleyOffset(), left=true);
    idlerHeight = pulley_height(coreXY_toothed_idler(coreXY_type()));
    pulleyBore = pulley_bore(coreXY_toothed_idler(coreXY_type()));

    if (yCarriageBraceThickness())
        translate_z(yCarriageThickness() + pulleyStackHeight(idlerHeight, pulleyBore) + eps)
            Y_Carriage_Brace_Left_stl();
    *translate_z(-carriage_height(yCarriageType))
        rotate(90)
            carriage(yCarriageType);

    translate([100, 0, 0]) rotate(180) {
        //Y_Carriage_Right_AL_dxf();
        Y_Carriage_Right_stl();
        //Y_Carriage_hardware(yCarriageType, yCarriageThickness(), yCarriageBraceThickness(), pulleyOffset(), pulleyOffset(), left=false);
        if (yCarriageBraceThickness())
            translate_z(yCarriageThickness() + pulleyStackHeight(idlerHeight, pulleyBore) + 2*eps)
                Y_Carriage_Brace_Right_stl();
        *translate_z(-carriage_height(yCarriageType))
            rotate(90)
                carriage(yCarriageType);
    }

    *translate([0, 80, 0]) {
        Y_Carriage_MGN12H_Left_stl();
        yCarriageType = MGN12H_carriage;
        //Y_Carriage_hardware(yCarriageType, yCarriageThickness(), yCarriageBraceThickness(), pulleyOffset(), pulleyOffset(), left=true);
        translate_z(-carriage_height(yCarriageType))
            rotate(90)
                carriage(yCarriageType);
    }

    *translate([120, 80, 0]) rotate(180) {
        Y_Carriage_MGN12H_Right_stl();
        yCarriageType = MGN12H_carriage;
        //Y_Carriage_hardware(yCarriageType, yCarriageThickness(), yCarriageBraceThickness(), pulleyOffset(), pulleyOffset(), left=false);
        translate_z(-carriage_height(yCarriageType))
            rotate(90)
                carriage(yCarriageType);
    }
}

//translate([-12, 0, 0]) Y_Carriage_Left_stl();
//translate([-12, 40, 0]) Y_Carriage_Right_stl();
if ($preview)
    Y_Carriage_test0();
