
include <../global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

include <../utils/carriageTypes.scad>

use <Y_Carriage.scad>

include <../Parameters_CoreXY.scad>
use <../Parameters_Positions.scad>


//function pulleyOffset() = [-yRailShiftX(), 0, yCarriageThickness() - 6 + 1.25 + pulleyStackHeight()];
//function pulleyOffset() = [-yRailShiftX(), 0, yCarriageThickness() + pulleyStackHeight()/2];
function pulleyOffset() = [-yRailShiftX(), 0, 0];
function tongueOffset(NEMA_width=_xyNEMA_width) = (eX + 2*eSizeX - _xRailLength - 2*yRailOffset(NEMA_width).x)/2;

topInset = 3.5;

module yCarriage(NEMA_width, reversedBelts=false, left, cnc=false) {
    plainIdler = coreXY_plain_idler(coreXY_type());
    isBearing = plainIdler[0] == "F623" || plainIdler[0] == "F684" || plainIdler[0] == "F694" || plainIdler[0] == "F695";
    pulleyBore = isBearing ? bb_bore(plainIdler) : pulley_bore(plainIdler);
    washer =  pulleyBore == 3 ? M3_washer : pulleyBore == 4 ? M4_shim : M5_shim;

    idlerHeight = isBearing ? 2*bb_width(plainIdler) + washer_thickness(washer) : pulley_height(plainIdler);
    chamfer = 0;
    blockOffsetY = topInset - 2.75 - 0.5;
    endStopOffsetX = left ? 2.5 : 1;
    tongueOffset = tongueOffset(NEMA_width);

    assert(pulleyStackHeight(idlerHeight, pulleyBore) + yCarriageBraceThickness() == coreXYSeparation().z);
    Y_Carriage(carriageType(_yCarriageDescriptor), idlerHeight, pulleyBore, railType(_xCarriageDescriptor), _xRailLength, yCarriageThickness(), chamfer, yCarriageBraceThickness(), blockOffsetY, endStopOffsetX, tongueOffset, pulleyOffset(), pulleyOffset(), topInset, left=left, cnc=cnc);
}

module Y_Carriage_Left_stl() {
    stl("Y_Carriage_Left")
        color(pp2_colour)
            yCarriage(NEMA_width = NEMA_width(NEMA14_36), left=true);
}

module Y_Carriage_Left_RB_stl() {
    stl("Y_Carriage_Left_RB")
        color(pp2_colour)
            yCarriage(NEMA_width = NEMA_width(NEMA14_36), reversedBelts=true, left=true);
}

module Y_Carriage_Right_stl() {
    stl("Y_Carriage_Right")
        color(pp2_colour)
            yCarriage(NEMA_width = NEMA_width(NEMA14_36), left=false);
}

module Y_Carriage_Right_RB_stl() {
    stl("Y_Carriage_Right_RB")
        color(pp2_colour)
            yCarriage(NEMA_width = NEMA_width(NEMA14_36), reversedBelts=true, left=false);
}

module Y_Carriage_Left_NEMA_17_stl() {
    stl("Y_Carriage_Left_NEMA_17")
        color(pp2_colour)
            yCarriage(NEMA_width = NEMA_width(NEMA17_40), left=true);
}

module Y_Carriage_Right_NEMA_17_stl() {
    stl("Y_Carriage_Right_NEMA_17")
        color(pp2_colour)
            yCarriage(NEMA_width = NEMA_width(NEMA17_40), left=false);
}

module Y_Carriage_Left_AL_dxf() {
    dxf("Y_Carriage_Left_AL")
        color(silver)
            yCarriage(NEMA_width = NEMA_width(NEMA14_36), left=true, cnc=true);
}

module Y_Carriage_Right_AL_dxf() {
    dxf("Y_Carriage_Right_AL")
        color(silver)
            yCarriage(NEMA_width = NEMA_width(NEMA14_36), left=true, cnc=true);
}

module Y_Carriage_Brace_Left_stl() {
    holeRadius = M3_tap_radius;

    stl("Y_Carriage_Brace_Left")
        color(pp1_colour)
            yCarriageBraceMGN9C(yCarriageBraceThickness(), pulleyOffset(), holeRadius, reversedBelts=false, left=true);
}

module Y_Carriage_Brace_Right_stl() {
    holeRadius = M3_tap_radius;

    stl("Y_Carriage_Brace_Right")
        color(pp1_colour)
            yCarriageBraceMGN9C(yCarriageBraceThickness(), pulleyOffset(), holeRadius, reversedBelts=false, left=false);
}

module Y_Carriage_Brace_Left_RB_stl() {
    holeRadius = M3_tap_radius;

    stl("Y_Carriage_Brace_Left_RB")
        color(pp1_colour)
            yCarriageBraceMGN9C(yCarriageBraceThickness(), pulleyOffset(), holeRadius, reversedBelts=true, left=true);
}

module Y_Carriage_Brace_Right_RB_stl() {
    holeRadius = M3_tap_radius;

    stl("Y_Carriage_Brace_Right_RB")
        color(pp1_colour)
            yCarriageBraceMGN9C(yCarriageBraceThickness(), pulleyOffset(), holeRadius, reversedBelts=true, left=false);
}

module yCarriageLeftAssembly(NEMA_width, t=undef, reversedBelts=false) {

    yCarriageType = carriageType(_yCarriageDescriptor);
    railOffset = yRailOffset(NEMA_width);
    plainIdler = reversedBelts ? coreXYBearing() : coreXY_plain_idler(coreXY_type());
    toothedIdler = reversedBelts ? coreXYBearing() : coreXY_toothed_idler(coreXY_type());
    isBearing = plainIdler[0] == "F623" || plainIdler[0] == "F684" || plainIdler[0] == "F694" || plainIdler[0] == "F695";
    pulleyBore = isBearing ? bb_bore(plainIdler) : pulley_bore(plainIdler);
    washer =  pulleyBore == 3 ? M3_washer : pulleyBore == 4 ? M4_shim : M5_shim;
    idlerHeight = isBearing ? 2*bb_width(plainIdler) + washer_thickness(washer) : pulley_height(plainIdler);

    pulleyStackHeight = pulleyStackHeight(idlerHeight, pulleyBore);

    translate([railOffset.x, carriagePosition(t).y, railOffset.z - carriage_height(yCarriageType)])
        rotate([180, 0, 0]) {
            stl_colour(pp2_colour)
                if (NEMA_width < 40) {
                    if (reversedBelts)
                        Y_Carriage_Left_RB_stl();
                    else
                        Y_Carriage_Left_stl();
                    //hidden() Y_Carriage_Left_NEMA_17_stl();
                } else {
                    Y_Carriage_Left_NEMA_17_stl();
                }
            if (yCarriageBraceThickness())
                translate_z(yCarriageThickness() + pulleyStackHeight + eps)
                    explode(5*yCarriageExplodeFactor(), show_line=false)
                        stl_colour(pp1_colour)
                            if (reversedBelts)
                                Y_Carriage_Brace_Left_RB_stl();
                            else
                                Y_Carriage_Brace_Left_stl();
            Y_Carriage_hardware(yCarriageType, plainIdler, toothedIdler, yCarriageThickness(), yCarriageBraceThickness(), pulleyOffset(), pulleyOffset(), left=true);
        }
}

module yCarriageRightAssembly(NEMA_width, t=undef, reversedBelts=false) {

    yCarriageType = carriageType(_yCarriageDescriptor);
    railOffset = yRailOffset(NEMA_width);
    plainIdler = reversedBelts ? coreXYBearing() : coreXY_plain_idler(coreXY_type());
    toothedIdler = reversedBelts ? coreXYBearing() : coreXY_toothed_idler(coreXY_type());
    isBearing = plainIdler[0] == "F623" || plainIdler[0] == "F684" || plainIdler[0] == "F694" || plainIdler[0] == "F695";
    pulleyBore = isBearing ? bb_bore(plainIdler) : pulley_bore(plainIdler);
    washer =  pulleyBore == 3 ? M3_washer : pulleyBore == 4 ? M4_shim : M5_shim;
    idlerHeight = isBearing ? 2*bb_width(plainIdler) + washer_thickness(washer) : pulley_height(plainIdler);

    pulleyStackHeight = pulleyStackHeight(idlerHeight, pulleyBore);

    translate([eX + 2*eSizeX - railOffset.x, carriagePosition(t).y, railOffset.z - carriage_height(yCarriageType)])
        rotate([180, 0, 180]) {
            stl_colour(pp2_colour)
                if (NEMA_width < 40) {
                    if (reversedBelts)
                        Y_Carriage_Right_RB_stl();
                    else
                        Y_Carriage_Right_stl();
                    //hidden() Y_Carriage_Right_NEMA_17_stl();
                } else {
                    Y_Carriage_Right_NEMA_17_stl();
                }
            if (yCarriageBraceThickness())
                translate_z(yCarriageThickness() + pulleyStackHeight + 2*eps)
                    explode(5*yCarriageExplodeFactor(), show_line=false)
                        stl_colour(pp1_colour)
                            if (reversedBelts)
                                Y_Carriage_Brace_Right_RB_stl();
                            else
                                Y_Carriage_Brace_Right_stl();
            Y_Carriage_hardware(yCarriageType, plainIdler, toothedIdler, yCarriageThickness(), yCarriageBraceThickness(), pulleyOffset(), pulleyOffset(), left=false);
        }
}

module yCarriageLeftRailAssembly(NEMA_width, t=undef, reversedBelts=false) {
    yCarriageLeftAssembly(NEMA_width, t, reversedBelts);

    yCarriageType = carriageType(_yCarriageDescriptor);

    railOffset = yRailOffset(NEMA_width);
    posY = carriagePosition(t).y - railOffset.y;

    translate(railOffset)
        rotate([180, 0, 90])
            explode(-40, true, show_line=false)
                rail_assembly(yCarriageType, _yRailLength, posY, carriage_end_colour="green", carriage_wiper_colour="red");
}

module yCarriageRightRailAssembly(NEMA_width, t=undef, reversedBelts=false) {
    yCarriageRightAssembly(NEMA_width, t, reversedBelts);

    yCarriageType = carriageType(_yCarriageDescriptor);

    railOffset = yRailOffset(NEMA_width);
    posY = carriagePosition(t).y - railOffset.y;

    translate([eX + 2*eSizeX - railOffset.x, railOffset.y, railOffset.z])
        rotate([180, 0, 90])
            explode(-40, true, show_line=false)
                rail_assembly(yCarriageType, _yRailLength, posY, carriage_end_colour="green", carriage_wiper_colour="red");
}

module Y_Carriage_Left_Rail_assembly(t=undef) pose(a=[55 + 180, 0, 25 + 310])
assembly("Y_Carriage_Left_Rail", big=true, ngb=true) {
    yCarriageLeftRailAssembly(_xyNEMA_width, t=t, reversedBelts=true);
}

module Y_Carriage_Right_Rail_assembly(t=undef) pose(a=[55 + 180, 0, 25 + 310])
assembly("Y_Carriage_Right_Rail", big=true, ngb=true) {
    yCarriageRightRailAssembly(_xyNEMA_width, t=t, reversedBelts=true);
}

