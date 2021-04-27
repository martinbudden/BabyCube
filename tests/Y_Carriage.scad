//! Display the Y carriages

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rails.scad>

use <../scad/printed/LeftAndRightFaceAssemblies.scad>
use <../scad/printed/TopFaceAssemblies.scad>
use <../scad/printed/X_Carriage.scad>
use <../scad/printed/Y_Carriage.scad>
use <../scad/printed/Y_CarriageAssemblies.scad>

use <../scad/utils/CoreXYBelts.scad>
use <../scad/utils/carriageTypes.scad>

use <../scad/Parameters_CoreXY.scad>
include <../scad/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module Y_Carriage_test0() {
    translate_z(-eZ+20) {
        CoreXYBelts(_xyNEMA_width, carriagePosition, x_gap=16, show_pulleys=false);
        yCarriageAssemblies(_xyNEMA_width);
    }
}

module Y_Carriage_test1() {

    //Y_Carriage_Left_AL_dxf();
    Y_Carriage_Left_stl();
    Y_Carriage_hardware(yCarriageType(), yCarriageThickness(), yCarriageBraceThickness(), left=true, pulleyOffset=pulleyOffset());
    if (yCarriageBraceThickness())
        translate_z(yCarriageThickness() + pulleyStackHeight() + eps)
            Y_Carriage_Brace_Left_stl();
    *translate_z(-carriage_height(yCarriageType()))
        rotate(90)
            carriage(yCarriageType());

    translate([100, 0, 0]) rotate(180) {
        Y_Carriage_Right_stl();
        Y_Carriage_hardware(yCarriageType(), yCarriageThickness(), yCarriageBraceThickness(), left=false, pulleyOffset=pulleyOffset());
        if (yCarriageBraceThickness())
            translate_z(yCarriageThickness() + pulleyStackHeight() + 2*eps)
                Y_Carriage_Brace_Right_stl();
        *translate_z(-carriage_height(yCarriageType()))
            rotate(90)
                carriage(yCarriageType());
    }

    *translate([0, 80, 0]) {
        Y_Carriage_MGN12H_Left_stl();
        yCarriageType = MGN12H_carriage;
        Y_Carriage_hardware(yCarriageType, yCarriageThickness(), yCarriageBraceThickness(), left=true, pulleyOffset=pulleyOffset());
        translate_z(-carriage_height(yCarriageType))
            rotate(90)
                carriage(yCarriageType);
    }

    *translate([120, 80, 0]) rotate(180) {
        Y_Carriage_MGN12H_Right_stl();
        yCarriageType = MGN12H_carriage;
        Y_Carriage_hardware(yCarriageType, yCarriageThickness(), yCarriageBraceThickness(), left=false, pulleyOffset=pulleyOffset());
        translate_z(-carriage_height(yCarriageType))
            rotate(90)
                carriage(yCarriageType);
    }
}

if ($preview)
    Y_Carriage_test1();
