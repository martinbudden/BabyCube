include <../global_defs.scad>

include <NopSCADlib/core.scad>

include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/vitamins/rails.scad>

use <../utils/carriageTypes.scad>

use <Y_Carriage.scad>

use <../Parameters_CoreXY.scad>
include <../Parameters_Main.scad>


//function pulleyOffset() = [-yRailShiftX(), 0, yCarriageThickness() - 6 + 1.25 + pulleyStackHeight()];
//function pulleyOffset() = [-yRailShiftX(), 0, yCarriageThickness() + pulleyStackHeight()/2];
function pulleyOffset() = [-yRailShiftX(), 0, 0];
topInset = 3.5;


function tongueOffset(NEMA_width) = (eX + 2*eSizeX - _xRailLength - 2*yRailOffset(NEMA_width).z)/2;

module Y_Carriage_Left_stl() {
    assert(pulleyStackHeight() + yCarriageBraceThickness() == coreXYSeparation().z);

    tongueOffset = tongueOffset(_xyNEMA_width);
    endStopOffsetX = 2.5;
    chamfer = 0;

    stl("Y_Carriage_Left")
        color(pp2_colour)
            Y_Carriage(yCarriageType(), xRailType(), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), endStopOffsetX, tongueOffset, left=true, pulleyOffset=pulleyOffset(), topInset=topInset, cnc=false);
}

module Y_Carriage_Right_stl() {
    tongueOffset = tongueOffset(_xyNEMA_width);
    endStopOffsetX = 1;
    chamfer = 0;

    stl("Y_Carriage_Right")
        color(pp2_colour)
            Y_Carriage(yCarriageType(), xRailType(), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), endStopOffsetX, tongueOffset, left=false, pulleyOffset=pulleyOffset(), topInset=topInset, cnc=false);
}

module Y_Carriage_Brace_Left_stl() {
    stl("Y_Carriage_Brace_Left")
        color(pp1_colour)
            yCarriageBrace(yCarriageType(), yCarriageBraceThickness(), left=true, pulleyOffset=pulleyOffset());
}

module Y_Carriage_Brace_Right_stl() {
    stl("Y_Carriage_Brace_Right")
        color(pp1_colour)
            yCarriageBrace(yCarriageType(), yCarriageBraceThickness(), left=false, pulleyOffset=pulleyOffset());
}

module Y_Carriage_Left_AL_dxf() {
    tongueOffset = tongueOffset(_xyNEMA_width);
    endStopOffsetX = 2.5;
    chamfer = 0;

    dxf("Y_Carriage_Left_AL")
        color(silver)
            Y_Carriage(yCarriageType(), xRailType(), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), endStopOffsetX, tongueOffset, left=true, pulleyOffset=pulleyOffset(), topInset=topInset, cnc=true);
}

module Y_Carriage_Right_AL_dxf() {
    tongueOffset = tongueOffset(_xyNEMA_width);
    endStopOffsetX = 1;
    chamfer = 0;

    dxf("Y_Carriage_Right_AL")
        color(silver)
            Y_Carriage(yCarriageType(), xRailType(), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), endStopOffsetX, tongueOffset, left=false, pulleyOffset=pulleyOffset(), topInset=topInset, cnc=true);
}
