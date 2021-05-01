include <../global_defs.scad>

include <NopSCADlib/core.scad>

include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/vitamins/rails.scad>

use <../utils/carriageTypes.scad>

use <Y_Carriage.scad>

use <../Parameters_CoreXY.scad>
use <../Parameters_Positions.scad>
include <../Parameters_Main.scad>


//function pulleyOffset() = [-yRailShiftX(), 0, yCarriageThickness() - 6 + 1.25 + pulleyStackHeight()];
//function pulleyOffset() = [-yRailShiftX(), 0, yCarriageThickness() + pulleyStackHeight()/2];
function pulleyOffset() = [-yRailShiftX(), 0, 0];
function tongueOffset(NEMA_width) = (eX + 2*eSizeX - _xRailLength - 2*yRailOffsetXYZ(NEMA_width).x)/2;

topInset = 3.5;


module Y_Carriage_Left_stl() {
    assert(pulleyStackHeight() + yCarriageBraceThickness() == coreXYSeparation().z);

    tongueOffset = tongueOffset(_xyNEMA_width);
    endStopOffsetX = 2.5;
    chamfer = 0;

    stl("Y_Carriage_Left")
        color(pp2_colour)
            Y_Carriage(yCarriageType(), xRailType(), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), endStopOffsetX, tongueOffset, pulleyOffset(), topInset, left=true, cnc=false);
}

module Y_Carriage_Right_stl() {
    tongueOffset = tongueOffset(_xyNEMA_width);
    endStopOffsetX = 1;
    chamfer = 0;

    stl("Y_Carriage_Right")
        color(pp2_colour)
            Y_Carriage(yCarriageType(), xRailType(), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), endStopOffsetX, tongueOffset, pulleyOffset(), topInset, left=false, cnc=false);
}

module Y_Carriage_Brace_Left_stl() {
    stl("Y_Carriage_Brace_Left")
        color(pp1_colour)
            yCarriageBrace(yCarriageType(), yCarriageBraceThickness(), pulleyOffset(), left=true);
}

module Y_Carriage_Brace_Right_stl() {
    stl("Y_Carriage_Brace_Right")
        color(pp1_colour)
            yCarriageBrace(yCarriageType(), yCarriageBraceThickness(), pulleyOffset(), left=false);
}

module yCarriageLeftAssembly(NEMA_width) {

    railOffset = yRailOffsetXYZ(NEMA_width);

    translate([railOffset.x, carriagePosition().y, railOffset.z - carriage_height(yCarriageType())])
        rotate([180, 0, 0]) {
            stl_colour(pp2_colour)
                Y_Carriage_Left_stl();
            if (yCarriageBraceThickness())
                translate_z(yCarriageThickness() + pulleyStackHeight() + eps)
                    explode(4*yCarriageExplodeFactor())
                        stl_colour(pp1_colour)
                            Y_Carriage_Brace_Left_stl();
            Y_Carriage_hardware(yCarriageType(), yCarriageThickness(), yCarriageBraceThickness(), pulleyOffset(), left=true);
        }
    //hidden() Y_Carriage_Left_AL_dxf();
}

module yCarriageRightAssembly(NEMA_width) {

    railOffset = yRailOffsetXYZ(NEMA_width);

    translate([eX + 2*eSizeX - railOffset.x, carriagePosition().y, railOffset.z - carriage_height(yCarriageType())])
        rotate([180, 0, 180]) {
            stl_colour(pp2_colour)
                Y_Carriage_Right_stl();
            if (yCarriageBraceThickness())
                translate_z(yCarriageThickness() + pulleyStackHeight() + 2*eps)
                    explode(4*yCarriageExplodeFactor())
                        stl_colour(pp1_colour)
                            Y_Carriage_Brace_Right_stl();
            Y_Carriage_hardware(yCarriageType(), yCarriageThickness(), yCarriageBraceThickness(), pulleyOffset(), left=false);
        }
    //hidden() Y_Carriage_Right_AL_dxf();
}

module Y_Carriage_Left_AL_dxf() {
    tongueOffset = tongueOffset(_xyNEMA_width);
    endStopOffsetX = 2.5;
    chamfer = 0;

    dxf("Y_Carriage_Left_AL")
        color(silver)
            Y_Carriage(yCarriageType(), xRailType(), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), endStopOffsetX, tongueOffset, pulleyOffset(), topInset, left=true, cnc=true);
}

module Y_Carriage_Right_AL_dxf() {
    tongueOffset = tongueOffset(_xyNEMA_width);
    endStopOffsetX = 1;
    chamfer = 0;

    dxf("Y_Carriage_Right_AL")
        color(silver)
            Y_Carriage(yCarriageType(), xRailType(), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), endStopOffsetX, tongueOffset, pulleyOffset(), topInset, left=false, cnc=true);
}
