
include <../global_defs.scad>

include <../vitamins/bolts.scad>

include <../utils/carriageTypes.scad>

use <X_Carriage.scad>
use <X_CarriageBeltAttachment.scad>

include <../Parameters_CoreXY.scad>

xCarriageFrontSize = [30, 4, 40.5];
function xCarriageBeltSideSize(xCarriageType, beltWidth) =  [max(carriage_size(xCarriageType).x, xCarriageFrontSize.x), xCarriageFrontSize.y, 36 + carriage_height(xCarriageType) + xCarriageTopThickness() + (!is_undef(beltWidth) && beltWidth == 9 ? 4.5 : 0)];


function xCarriageBeltAttachmentMGN9CExtraX() = 4;
evaHoleSeparationTop = 34;
function xCarriageHoleSeparationTop(xCarriageType) = xCarriageType[0] == "MGN9C" ? 22 : evaHoleSeparationTop; //45.4 - 8
function xCarriageHoleSeparationBottom(xCarriageType) = xCarriageType[0] == "MGN9C" ? 22 : 38;//34;//37.4; //45.4 - 8

function accelerometerOffset() = [0, 3, 8];

xCarriageBeltTensionerSizeX = 23;
beltClampSize = [25, xCarriageBeltAttachmentSize(beltWidth(), beltSeparation()).x - 0.5, 3.5];
beltsCenterZOffset = coreXYPosBL(_xyNEMA_width, carriageType(_yCarriageDescriptor)).z - eZ + yRailSupportThickness();


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
                    xCarriageBeltSide(xCarriageType, size, beltsCenterZOffset, beltWidth(), beltSeparation(), holeSeparationTop, holeSeparationBottom, accelerometerOffset=accelerometerOffset(), topHoleOffset=-extraX/2, screwType=hs_cs_cap, halfCarriage=halfCarriage);
}

//!Insert the belts into the **X_Carriage_Belt_Tensioner**s and then bolt the tensioners into the
//!**X_Carriage_Belt_Side_MGN9C** part as shown. Note the belts are not shown in this diagram.
//
module X_Carriage_Belt_Side_MGN9C_HC_assembly()
assembly("X_Carriage_Belt_Side_MGN9C_HC") {
    xCarriageBeltSideMGN9CAssembly(halfCarriage=true);
}

//!Insert the belts into the **X_Carriage_Belt_Tensioner**s and then bolt the tensioners into the
//!**X_Carriage_Belt_Side_MGN9C** part as shown. Note the belts are not shown in this diagram.
//
module X_Carriage_Belt_Side_MGN9C_assembly()
assembly("X_Carriage_Belt_Side_MGN9C") {
    xCarriageBeltSideMGN9CAssembly(halfCarriage=false);
}

module xCarriageBeltSideMGN9CAssembly(halfCarriage) {
    translate([xCarriageBeltAttachmentMGN9CExtraX(), 0, 0])
        rotate([-90, 180, 0])
            stl_colour(pp4_colour)
                if (halfCarriage)
                    X_Carriage_Belt_Side_MGN9C_HC_stl();
                else
                    X_Carriage_Belt_Side_MGN9C_stl();

    beltTensionerSize = xCarriageBeltTensionerSize(beltWidth(), xCarriageBeltTensionerSizeX);
    offset = [  xCarriageBeltTensionerSizeX - 8.5 + xCarriageBeltAttachmentMGN9CExtraX(),
                -3.6,
                beltsCenterZOffset
            ];
    boltLength = 30;
    translate(offset) {
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
    }
}

module X_Carriage_Belt_Tensioner_stl() {
    stl("X_Carriage_Belt_Tensioner")
        color(pp2_colour)
            xCarriageBeltTensioner(xCarriageBeltTensionerSize(beltWidth(), xCarriageBeltTensionerSizeX));
}

module X_Carriage_Belt_Clamp_stl() {
    stl("X_Carriage_Belt_Clamp")
        color(pp2_colour)
            xCarriageBeltClamp(beltClampSize, offset=-0.25, countersunk=true);
}

module xCarriageBeltClampAssembly(xCarriageType) {
    size = xCarriageBeltSideSize(xCarriageType, beltWidth());
    translate([0, 5, beltsCenterZOffset])
        rotate([-90, 180, 0]) {
            stl_colour(pp2_colour)
                X_Carriage_Belt_Clamp_stl();
            X_Carriage_Belt_Clamp_hardware(beltClampSize, countersunk=true);
        }
}

