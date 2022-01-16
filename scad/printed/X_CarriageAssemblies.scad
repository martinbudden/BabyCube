
include <../global_defs.scad>

include <../utils/carriageTypes.scad>

use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/blowers.scad>

include <../utils/PrintheadOffsets.scad>

include <../vitamins/bolts.scad>

include <Printhead.scad>
use <X_Carriage.scad>
use <X_CarriageBeltAttachment.scad>
use <X_CarriageFanDuct.scad>

include <../Parameters_CoreXY.scad>

xCarriageFrontSize = [30, 4, 40.5];
function xCarriageBeltSideSize(xCarriageType, beltWidth) =  [max(carriage_size(xCarriageType).x, xCarriageFrontSize.x), xCarriageFrontSize.y, 36 + carriage_height(xCarriageType) + xCarriageTopThickness() + (!is_undef(beltWidth) && beltWidth == 9 ? 4.5 : 0)];
function xCarriageHotendSideSize(xCarriageType, beltWidth) = [xCarriageBeltSideSize(xCarriageType, beltWidth).x, 4.5, xCarriageBeltSideSize(xCarriageType, beltWidth).z];
function xCarriageHotendOffsetY(xCarriageType) = carriage_size(xCarriageType).y/2 + xCarriageHotendSideSize(xCarriageType).y + 0.5;
function xCarriageBeltAttachmentMGN9CExtraX() = 4;
evaHoleSeparationTop = 34;
function xCarriageHoleSeparationTop(xCarriageType) = xCarriageType[0] == "MGN9C" ? 22 : evaHoleSeparationTop; //45.4 - 8
function xCarriageHoleSeparationBottom(xCarriageType) = xCarriageType[0] == "MGN9C" ? 22 : 38;//34;//37.4; //45.4 - 8

//!!TODO - change hotendOffset.z to 1.5 for new X_Carriage with belt attachments
function hotendOffset(xCarriageType, hotendDescriptor="E3DV6") = printheadHotendOffset(hotendDescriptor) + [-xCarriageHotendSideSize(xCarriageType).x/2, xCarriageHotendOffsetY(xCarriageType), 0];
function grooveMountSize(blower_type, hotendDescriptor="E3DV6") = [printheadHotendOffset(hotendDescriptor).x, blower_size(blower_type).x + 6.25, 12];
function blower_type() = is_undef(_blowerDescriptor) || _blowerDescriptor == "BL30x10" ? BL30x10 : BL40x10;
function accelerometerOffset() = [0, 3, 8];

xCarriageBeltTensionerSizeX = 23;
beltClampSize = [25, xCarriageBeltAttachmentSize(beltWidth(), beltSeparation()).x - 0.5, 3.5];


module X_Carriage_Belt_Side_MGN9C_stl() {
    xCarriageType = MGN9C_carriage;
    extraX = xCarriageBeltAttachmentMGN9CExtraX();
    size = xCarriageBeltSideSize(xCarriageType, beltWidth()) + [extraX, 0, 0];
    holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);

    // orientate for printing
    stl("X_Carriage_Belt_Side_MGN9C")
        color(pp4_colour)
            translate([extraX/2, 0, 0])
            rotate([90, 0, 180])
                    xCarriageBeltSide(xCarriageType, size, beltWidth(), beltSeparation(), holeSeparationTop, holeSeparationBottom, accelerometerOffset=accelerometerOffset(), topHoleOffset=-extraX/2, halfCarriage=true);
}

//!Insert the belts into the **X_Carriage_Belt_Tensioner**s and then bolt the tensioners into the
//!**X_Carriage_Belt_Side_MGN9C** part as shown. Note the belts are not shown in this diagram.
//
module X_Carriage_Belt_Side_MGN9C_assembly()
assembly("X_Carriage_Belt_Side_MGN9C") {

    translate([xCarriageBeltAttachmentMGN9CExtraX(), 0, 0])
        rotate([-90, 180, 0])
            stl_colour(pp4_colour)
                X_Carriage_Belt_Side_MGN9C_stl();

    beltTensionerSize = xCarriageBeltTensionerSize(beltWidth());
    offset = xCarriageBeltTensionerSizeX - 8.5 + xCarriageBeltAttachmentMGN9CExtraX();
    boltLength = 30;
    translate([offset, -3.6, -27]) {
        rotate([0, 0, 180]) {
            explode([-40, 0, 0])
                stl_colour(pp2_colour)
                    X_Carriage_Belt_Tensioner_stl();
            X_Carriage_Belt_Tensioner_hardware(beltTensionerSize, boltLength, offset - 7.75);
        }
        translate([-2*offset + xCarriageBeltAttachmentMGN9CExtraX(), 0, -2])
            rotate([180, 0, 0]) {
                explode([-40, 0, 0])
                    stl_colour(pp2_colour)
                        X_Carriage_Belt_Tensioner_stl();
                X_Carriage_Belt_Tensioner_hardware(beltTensionerSize, boltLength, offset - 7.75);
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
    translate([0, 5, -size.z + xCarriageTopThickness() + xCarriageBaseThickness() + 0.5])
        rotate([-90, 180, 0]) {
            stl_colour(pp2_colour)
                X_Carriage_Belt_Clamp_stl();
            X_Carriage_Belt_Clamp_hardware(beltClampSize, offset=-0.25, countersunk=true);
        }
}

module X_Carriage_Groovemount_MGN9C_stl() {
    xCarriageType = MGN9C_carriage;
    blower_type = blower_type();
    hotendDescriptor = "E3DV6";
    grooveMountSize = grooveMountSize(blower_type, hotendDescriptor);
    hotendOffset = hotendOffset(xCarriageType, hotendDescriptor);
    extraX = xCarriageBeltAttachmentMGN9CExtraX();
    holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);

    stl("X_Carriage_Groovemount_MGN9C")
        color(pp1_colour)
            rotate([0, -90, 0]) {
                size = xCarriageHotendSideSize(xCarriageType, beltWidth());
                xCarriageBack(xCarriageType, size, extraX, holeSeparationTop, holeSeparationBottom, halfCarriage=true, strainRelief=false, countersunk=_xCarriageCountersunk ? 4 : 0, topHoleOffset=-xCarriageBeltAttachmentMGN9CExtraX()/2, accelerometerOffset = accelerometerOffset());
                hotEndHolder(xCarriageType, xCarriageHotendSideSize(xCarriageType), grooveMountSize, hotendOffset, hotendDescriptor, blower_type, baffle=true, left=true);
            }
}

//pose(a=[55, 0, 25 + 290])
module X_Carriage_Groovemount_MGN9C_assembly() {
//assembly("X_Carriage_Groovemount_MGN9C", big=true, ngb=true) {

    xCarriageType = MGN9C_carriage;
    blower_type = blower_type();
    hotendDescriptor = "E3DV6";
    hotendOffset = hotendOffset(xCarriageType, hotendDescriptor);

    rotate([0, 90, 0])
        stl_colour(pp1_colour)
            X_Carriage_Groovemount_MGN9C_stl();

    grooveMountSize = grooveMountSize(blower_type, hotendDescriptor);

    explode([-20, 0, 10], true)
        hotEndPartCoolingFan(xCarriageType, grooveMountSize, hotendOffset, blower_type, left=true);
    explode([-20, 0, -10], true)
        hotEndHolderAlign(hotendOffset, left=true)
            blowerTranslate(xCarriageType, grooveMountSize, hotendOffset, blower_type)
                rotate([-90, 0, 0]) {
                    stl_colour(pp2_colour)
                        Fan_Duct_stl();
                    Fan_Duct_hardware(xCarriageType, hotendDescriptor);
                }
}

module Fan_Duct_stl() {
    stl("Fan_Duct")
        color(pp2_colour)
            fanDuct(printheadHotendOffset().x);
}
