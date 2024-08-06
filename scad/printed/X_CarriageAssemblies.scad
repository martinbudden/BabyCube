
include <../config/global_defs.scad>

include <../vitamins/bolts.scad>

include <../utils/carriageTypes.scad>

use <X_Carriage.scad>
use <X_CarriageBeltAttachment.scad>

include <../config/Parameters_CoreXY.scad>
include <../utils/CoreXYBelts.scad>

xCarriageFrontSize = [30, 4, 40.5];
function xCarriageBeltSideSize(xCarriageType, beltWidth) = 
    [max(carriage_size(xCarriageType).x, xCarriageFrontSize.x),
     xCarriageFrontSize.y,
     28 + carriage_height(xCarriageType) + xCarriageTopThickness() + xCarriageBaseThickness(xCarriageType) + (!is_undef(beltWidth) && beltWidth == 9 ? 4.5 : 0)
    ];
function xCarriageBoreDepth() = 6.5;

function xCarriageBeltAttachmentMGN9CExtraX() = 4;
evaHoleSeparationTop = 34;
function xCarriageHoleSeparationTop(xCarriageType) = xCarriageType[0] == "MGN9C" ? 22 : evaHoleSeparationTop; //45.4 - 8
function xCarriageHoleSeparationBottom(xCarriageType) = xCarriageType[0] == "MGN9C" ? 22 : 38;//34;//37.4; //45.4 - 8

function accelerometerOffset() = [0, 3, 8];

xCarriageBeltTensionerSizeX = 23;
beltClampSize = [25, xCarriageBeltAttachmentSize(beltWidth(), beltSeparation()).x - 0.5, 3.5];
beltsCenterZOffset = coreXYPosBL(_xyNEMA_width, carriageType(_yCarriageDescriptor)).z - eZ + yRailSupportThickness();


module xCarriageHotendSideHolePositions(xCarriageType, flipSide=false) {
    size = xCarriageBeltSideSize(xCarriageType, beltWidth());
    holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);
    carriageSize = carriage_size(xCarriageType);

    for (x = xCarriageHolePositions(size.x, holeSeparationTop))
        translate([x - size.x/2, carriageSize.y/2 + railCarriageGap() + (flipSide ? size.y : 0), xCarriageTopThickness()/2])
            rotate([-90, 90, 0])
                children();
    for (x = xCarriageHolePositions(size.x, holeSeparationBottom))
        translate([x - size.x/2, carriageSize.y/2 + railCarriageGap() + (flipSide ? size.y : 0), -size.z + xCarriageTopThickness() + xCarriageBaseThickness()/2])
            rotate([-90, 90, 0])
                children();
}

module X_Carriage_Belt_Side_MGN9C_HC_stl() {
    xCarriageType = MGN9C_carriage;
    extraX = xCarriageBeltAttachmentMGN9CExtraX();
    size = xCarriageBeltSideSize(xCarriageType, beltWidth()) + [extraX, 0, 0];
    holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);
    beltsCenterZOffset = coreXYPosBL(_xyNEMA_width, carriageType(_yCarriageDescriptor)).z - eZ + yRailSupportThickness();
    halfCarriage = true;

    // orientate for printing
    stl("X_Carriage_Belt_Side_MGN9C_HC")
        color(pp4_colour)
            translate([extraX/2, 0, 0])
                rotate([90, 0, 180])
                    xCarriageBeltSide(xCarriageType, size, beltsCenterZOffset, beltWidth(), beltSeparation(), holeSeparationTop, holeSeparationBottom, accelerometerOffset=accelerometerOffset(), topHoleOffset=-extraX/2, screwType=hs_cs_cap, halfCarriage=halfCarriage);
}

module X_Carriage_Belt_Side_MGN9C_stl() {
    xCarriageType = MGN9C_carriage;
    extraX = xCarriageBeltAttachmentMGN9CExtraX();
    size = xCarriageBeltSideSize(xCarriageType, beltWidth()) + [extraX, 0, 0];
    holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);
    beltsCenterZOffset = coreXYPosBL(_xyNEMA_width, carriageType(_yCarriageDescriptor)).z - eZ + yRailSupportThickness();
    halfCarriage = false;

    // orientate for printing
    stl("X_Carriage_Belt_Side_MGN9C")
        color(pp4_colour)
            translate([extraX/2, 0, 0])
                rotate([90, 0, 180])
                    xCarriageBeltSide(xCarriageType, size, beltsCenterZOffset, beltWidth(), beltSeparation(), holeSeparationTop, holeSeparationBottom, accelerometerOffset=accelerometerOffset(), topHoleOffset=-extraX/2, screwType=hs_cap, boreDepth=xCarriageBoreDepth(), halfCarriage=halfCarriage);
}

module X_Carriage_Belt_Side_MGN9C_RB_stl() {
    xCarriageType = MGN9C_carriage;
    extraX = xCarriageBeltAttachmentMGN9CExtraX();
    size = xCarriageBeltSideSize(xCarriageType, beltWidth()) + [extraX, 0, 0];
    holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);
    beltsCenterZOffset = coreXYPosBL(_xyNEMA_width, carriageType(_yCarriageDescriptor)).z - eZ + yRailSupportThickness();
    halfCarriage = false;

    // orientate for printing
    stl("X_Carriage_Belt_Side_MGN9C_RB")
        color(pp4_colour)
            translate([extraX/2, 0, 0])
                rotate([90, 0, 180])
                    xCarriageBeltSide(xCarriageType, size, beltsCenterZOffset, beltWidth(), beltSeparation(), holeSeparationTop, holeSeparationBottom, accelerometerOffset=accelerometerOffset(), topHoleOffset=-extraX/2, screwType=hs_cap, boreDepth=xCarriageBoreDepth(), halfCarriage=halfCarriage, reversedBelts=true,endCube=true);
}

//!1. Insert the belts into the **X_Carriage_Belt_Tensioner**s.
//!2. Bolt the tensioners into the **X_Carriage_Belt_Side_MGN9C** part as shown.
//!
//!Note: it may be a tight fit to insert the **X_Carriage_Belt_Tensioner**s into the **X_Carriage_Belt_Side_MGN9C**.
//!It may be necessary to use a small file to file the slots in the X_Carriage. This is especially the case with the tops
//!of the slots - these are printed using bridging and depending on how well your printer does bridging, so adjustemnt
//!may be required.
//!
//! Note: for clarity, only a segment of the belts are shown in this diagram.
//
module X_Carriage_Belt_Side_MGN9C_HC_assembly()
assembly("X_Carriage_Belt_Side_MGN9C_HC", big=true) {
    xCarriageBeltSideMGN9CAssembly(halfCarriage=true, reversedBelts=false);
}

//!1. Insert the belts into the **X_Carriage_Belt_Tensioner**s.
//!2. Bolt the tensioners into the **X_Carriage_Belt_Side_MGN9C** part as shown.
//!
//!Note: it may be a tight fit to insert the **X_Carriage_Belt_Tensioner**s into the **X_Carriage_Belt_Side_MGN9C**.
//!It may be necessary to use a small file to file the slots in the X_Carriage. This is especially the case with the tops
//!of the slots - these are printed using bridging and depending on how well your printer does bridging, so adjustemnt
//!may be required.
//!
//! Note: for clarity, only a segment of the belts are shown in this diagram.
//
module X_Carriage_Belt_Side_MGN9C_assembly()
assembly("X_Carriage_Belt_Side_MGN9C", big=true) {
    xCarriageBeltSideMGN9CAssembly(halfCarriage=false, reversedBelts=false);
}

//!1. Insert the belts into the **X_Carriage_Belt_Tensioner**s.
//!2. Bolt the tensioners into the **X_Carriage_Belt_Side_MGN9C** part as shown.
//!
//!Note: it may be a tight fit to insert the **X_Carriage_Belt_Tensioner**s into the **X_Carriage_Belt_Side_MGN9C**.
//!It may be necessary to use a small file to file the slots in the X_Carriage. This is especially the case with the tops
//!of the slots - these are printed using bridging and depending on how well your printer does bridging, so adjustemnt
//!may be required.
//!
//! Note: for clarity, only a segment of the belts are shown in this diagram.
//
module X_Carriage_Belt_Side_MGN9C_RB_assembly()
assembly("X_Carriage_Belt_Side_MGN9C_RB", big=true) {
    xCarriageBeltSideMGN9CAssembly(halfCarriage=false, reversedBelts=true);
}

module xCarriageBeltSideMGN9CAssembly(halfCarriage, reversedBelts) {
    hidden()
        CoreXYBelts([eX/2 + eSizeX, eY/2 + eSizeY]);
    translate([xCarriageBeltAttachmentMGN9CExtraX(), 0, 0])
        rotate([-90, 180, 0])
            stl_colour(pp4_colour)
                if (halfCarriage)
                    X_Carriage_Belt_Side_MGN9C_HC_stl();
                else if (reversedBelts)
                    X_Carriage_Belt_Side_MGN9C_RB_stl();
                else
                    X_Carriage_Belt_Side_MGN9C_stl();

    beltTensionerSize = xCarriageBeltTensionerSize(beltWidth(), xCarriageBeltTensionerSizeX);
    offset = [  xCarriageBeltTensionerSizeX - 8.5 + xCarriageBeltAttachmentMGN9CExtraX(),
                -3.6,
                beltsCenterZOffset
            ];
    boltLength = 30;
    /*translate(offset) {
        translate_z((beltSeparation() + beltWidth())/2)
            rotate([0, 0, 180]) {
                explode([-40, 0, 0])
                    stl_colour(pp2_colour)
                        X_Carriage_Belt_Tensioner_stl();
                X_Carriage_Belt_Tensioner_hardware(beltTensionerSize, boltLength, xCarriageFrontSize.x/2 + offset.x);
            }
        translate([-2*offset.x + xCarriageBeltAttachmentMGN9CExtraX(), 0, -(beltSeparation() + beltWidth())/2])
            rotate([180, 0, 0]) {
                explode([-40, 0, 0])
                    stl_colour(pp2_colour)
                        X_Carriage_Belt_Tensioner_stl();
                X_Carriage_Belt_Tensioner_hardware(beltTensionerSize, boltLength, xCarriageFrontSize.x/2 + offset.x);
            }
    }*/
    translate(offset) {
        zOffset = (beltSeparation() + beltWidth())/2;
        if (reversedBelts) {
            translate([0, 0, -zOffset]) // -1.0 to -1.2
                rotate([0, 180, 0]) {
                    explode([-40, 0, 0], true, show_line=false) {
                        stl_colour(pp2_colour)
                            X_Carriage_Belt_Tensioner_RB_stl();
                    mirror([0, 1, 0])
                        X_Carriage_Belt_Tensioner_hardware(beltTensionerSize, boltLength, xCarriageFrontSize.x/2 + offset.x, upper=false);
                    }
                }
            translate([-2*offset.x + xCarriageBeltAttachmentMGN9CExtraX(), 0, zOffset]) // 1.0 to 1.2
                rotate([0, 0, 0]) {
                    explode([-40, 0, 0], true, show_line=false) {
                        stl_colour(pp2_colour)
                            X_Carriage_Belt_Tensioner_RB_stl();
                        mirror([0, 1, 0])
                            X_Carriage_Belt_Tensioner_hardware(beltTensionerSize, boltLength, xCarriageFrontSize.x/2 + offset.x, upper=true);
                    }
                }
        } else {
            translate([0, 0, zOffset]) // 0.75 to 0.95
                rotate([0, 0, 180]) {
                    explode([-40, 0, 0])
                        stl_colour(pp2_colour)
                            X_Carriage_Belt_Tensioner_stl();
                    X_Carriage_Belt_Tensioner_hardware(beltTensionerSize, boltLength, xCarriageFrontSize.x/2 + offset.x, upper=true);
                }
            translate([-2*offset.x + xCarriageBeltAttachmentMGN9CExtraX(), 0, -zOffset]) // -0.75 to -0.95
                rotate([180, 0, 0]) {
                    explode([-40, 0, 0])
                        stl_colour(pp2_colour)
                            X_Carriage_Belt_Tensioner_stl();
                    X_Carriage_Belt_Tensioner_hardware(beltTensionerSize, boltLength, xCarriageFrontSize.x/2 + offset.x, upper=false);
                }
        }
    }
}

module X_Carriage_Belt_Tensioner_stl() {
    stl("X_Carriage_Belt_Tensioner")
        color(pp2_colour)
            xCarriageBeltTensioner(xCarriageBeltTensionerSize(beltWidth(), xCarriageBeltTensionerSizeX));
}

module X_Carriage_Belt_Tensioner_RB_stl() {
    stl("X_Carriage_Belt_Tensioner_RB")
        color(pp2_colour)
            mirror([0, 1, 0])
                xCarriageBeltTensioner(xCarriageBeltTensionerSize(beltWidth(), xCarriageBeltTensionerSizeX));
}

module X_Carriage_Belt_Clamp_stl() {
    stl("X_Carriage_Belt_Clamp")
        color(pp2_colour)
            xCarriageBeltClamp(beltClampSize, offset=-0.25, countersunk=true);
}

module xCarriageBeltClampAssembly(xCarriageType) {
    size = xCarriageBeltSideSize(xCarriageType, beltWidth());
    translate([0, 6, beltsCenterZOffset])
        rotate([-90, 180, 0]) {
            explode(50, true) {
                stl_colour(pp2_colour)
                    X_Carriage_Belt_Clamp_stl();
                X_Carriage_Belt_Clamp_hardware(beltClampSize, countersunk=true);
            }
        }
}

