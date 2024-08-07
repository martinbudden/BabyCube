//! Display the Y carriages

include <../scad/printed/Y_Carriage.scad>
include <../scad/printed/Y_CarriageAssemblies.scad>

include <../scad/config/Parameters_CoreXY.scad>
include <../scad/utils/CoreXYBelts.scad>

use <../scad/config/Parameters_Positions.scad>


//$explode = 1;
//$pose = 1;
module Y_Carriage_test0() {
    t = 3;
    translate_z(-eZ + 20) {
        if (!exploded())
            CoreXYBelts(carriagePosition(t) + [yRailOffset(_xyNEMA_width).x, 0], show_pulleys=[1,0,0]);
        yCarriageLeftAssembly(_xyNEMA_width, t=t, reversedBelts=true);
        yCarriageRightAssembly(_xyNEMA_width, t=t, reversedBelts=true);
        //Y_Carriage_Left_Rail_assembly(t=t);
        //yCarriageLeftRailAssembly(_xyNEMA_width, t=t, reversedBelts=true);
        //yCarriageRightRailAssembly(_xyNEMA_width, t=t, reversedBelts=true);
    }
}

module Y_Carriage_test1() {

    yCarriageType = carriageType(_yCarriageDescriptor);
    toothedIdler = coreXY_toothed_idler(coreXY_type());
    plainIdler = coreXY_plain_idler(coreXY_type());
    idlerHeight = pulley_height(toothedIdler);
    pulleyBore = pulley_bore(toothedIdler);

    Y_Carriage_Left_stl();
    Y_Carriage_hardware(yCarriageType, plainIdler, toothedIdler, yCarriageThickness(), yCarriageBraceThickness(), pulleyOffset(), pulleyOffset(), left=true);

    *if (yCarriageBraceThickness())
        translate_z(yCarriageThickness() + pulleyStackHeight(idlerHeight, pulleyBore) + eps)
            Y_Carriage_Brace_Left_stl();
    *translate_z(-carriage_height(yCarriageType))
        rotate(90)
            carriage(yCarriageType);

    translate([100, 0, 0]) rotate(180) {
        Y_Carriage_Right_stl();
        Y_Carriage_hardware(yCarriageType, plainIdler, toothedIdler, yCarriageThickness(), yCarriageBraceThickness(), pulleyOffset(), pulleyOffset(), left=false);
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
