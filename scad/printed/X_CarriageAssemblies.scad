
include <../global_defs.scad>

use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/blowers.scad>

include <../utils/carriageTypes.scad>
include <../utils/PrintheadOffsets.scad>

include <../vitamins/bolts.scad>

include <Printhead.scad>
use <X_Carriage.scad>
use <X_CarriageBeltAttachment.scad>
use <X_CarriageFanDuct.scad>

include <../Parameters_CoreXY.scad>

xCarriageFrontSize = [30, 4, 40.5];
function xCarriageFrontSize(xCarriageType, beltWidth) =  [max(carriage_size(xCarriageType).x, xCarriageFrontSize.x), xCarriageFrontSize.y, 36 + carriage_height(xCarriageType) + xCarriageTopThickness() + (!is_undef(beltWidth) && beltWidth == 9 ? 4.5 : 0)]; //has the belt tensioners
function xCarriageBackSize(xCarriageType, beltWidth) = [xCarriageFrontSize(xCarriageType, beltWidth).x, 5, xCarriageFrontSize(xCarriageType, beltWidth).z];
function xCarriageBackOffsetY(xCarriageType) = carriage_size(xCarriageType).y/2 + xCarriageBackSize(xCarriageType).y;

//!!TODO - change hotendoffset.z to 1.5 for new X_Carriage with belt attachments
function hotendOffset(xCarriageType, hotend_type=0) = printHeadHotendOffset(hotend_type) + [-xCarriageBackSize(xCarriageType).x/2, xCarriageBackOffsetY(xCarriageType), 0];
function grooveMountSize(blower_type, hotend_type=0) = [printHeadHotendOffset(hotend_type).x, blower_size(blower_type).x + 6.25, 12];
function blower_type() = is_undef(_blowerDescriptor) || _blowerDescriptor == "BL30x10" ? BL30x10 : BL40x10;
function accelerometerOffset() = [0, 3, 8];

xCarriageBeltTensionerSizeX = 23;


module X_Carriage_Belt_Side_MGN9C_stl() {
    xCarriageType = MGN9C_carriage;
    extraX = xCarriageBeltAttachmentMGN9CExtraX();
    size = xCarriageFrontSize(xCarriageType, beltWidth()) + [extraX, 0, 0];
    holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);

    // orientate for printing
    stl("X_Carriage_Belt_Side_MGN9C")
        color(pp4_colour)
            translate([extraX/2, 0, 0])
                rotate([90, 0, 0])
                    xCarriageBeltSide(xCarriageType, size, holeSeparationTop, holeSeparationBottom, extraX=extraX, accelerometerOffset=accelerometerOffset(), topHoleOffset=-extraX/2);
}

//!Insert the belts into the **X_Carriage_Belt_Tensioner**s and then bolt the tensioners into the
//!**X_Carriage_Belt_Side_MGN9C** part as shown. Note the belts are not shown in this diagram.
//
module X_Carriage_Belt_Side_MGN9C_assembly()
assembly("X_Carriage_Belt_Side_MGN9C") {

    rotate([-90, 0, 0])
        stl_colour(pp4_colour)
            X_Carriage_Belt_Side_MGN9C_stl();

    offset = xCarriageBeltTensionerSizeX - 8.5 + xCarriageBeltAttachmentMGN9CExtraX();
    boltLength = 30;
    translate([offset, -3.4, -27]) {
        rotate([0, 0, 180]) {
            explode([-40, 0, 0])
                stl_colour(pp2_colour)
                    X_Carriage_Belt_Tensioner_stl();
            X_Carriage_Belt_Tensioner_hardware(boltLength, offset - 7.75);
        }
        translate([-2*offset + xCarriageBeltAttachmentMGN9CExtraX(), 0, -2])
            rotate([180, 0, 0]) {
                explode([-40, 0, 0])
                    stl_colour(pp2_colour)
                        X_Carriage_Belt_Tensioner_stl();
                X_Carriage_Belt_Tensioner_hardware(boltLength, offset - 7.75);
            }
    }
}

module X_Carriage_Belt_Tensioner_stl() {
    stl("X_Carriage_Belt_Tensioner")
        color(pp2_colour)
            xCarriageBeltTensioner(xCarriageBeltTensionerSizeX);
}

module X_Carriage_Belt_Clamp_stl() {
    size = [xCarriageBeltAttachmentSize().x - 0.5, 25, 3.5];

    stl("X_Carriage_Belt_Clamp")
        color(pp2_colour)
            vflip()
                xCarriageBeltClamp(size, countersunk=true);
}

module xCarriageBeltClampAssembly(xCarriageType) {
    size = xCarriageFrontSize(xCarriageType, beltWidth());
    translate([4, 0.3, 3.85])
        xCarriageBeltClampPosition(xCarriageType, size) {
            stl_colour(pp2_colour)
                vflip()
                    X_Carriage_Belt_Clamp_stl();
            X_Carriage_Belt_Clamp_hardware(countersunk=true);
        }
}

module X_Carriage_Groovemount_MGN9C_stl() {
    xCarriageType = MGN9C_carriage;
    blower_type = blower_type();
    hotend_type = 0;
    grooveMountSize = grooveMountSize(blower_type, hotend_type);
    hotendOffset = hotendOffset(xCarriageType, hotend_type);
    holeSeparation = 22;

    stl("X_Carriage_Groovemount_MGN9C")
        color(pp1_colour)
            rotate([0, -90, 0]) {
                size = xCarriageBackSize(xCarriageType, beltWidth());
                xCarriageBack(xCarriageType, size, coreXYSeparation().z, strainRelief=false, countersunk=_xCarriageCountersunk ? 4 : 0, topHoleOffset=-xCarriageBeltAttachmentMGN9CExtraX()/2, accelerometerOffset = accelerometerOffset());
                hotEndHolder(xCarriageType, grooveMountSize, hotendOffset, hotend_type, blower_type, baffle=true, left=true);
            }
}

//pose(a=[55, 0, 25 + 290])
module X_Carriage_Groovemount_MGN9C_assembly() {
//assembly("X_Carriage_Groovemount_MGN9C", big=true, ngb=true) {

    xCarriageType = MGN9C_carriage;
    blower_type = blower_type();
    hotend_type = 0;
    hotendOffset = hotendOffset(xCarriageType, hotend_type);

    rotate([0, 90, 0])
        stl_colour(pp1_colour)
            X_Carriage_Groovemount_MGN9C_stl();

    grooveMountSize = grooveMountSize(blower_type, hotend_type);

    explode([-20, 0, 10], true)
        hotEndPartCoolingFan(xCarriageType, grooveMountSize, hotendOffset, blower_type, left=true);
    explode([-20, 0, -10], true)
        hotEndHolderAlign(hotendOffset, left=true)
            blowerTranslate(xCarriageType, grooveMountSize, hotendOffset, blower_type)
                rotate([-90, 0, 0]) {
                    stl_colour(pp2_colour)
                        Fan_Duct_stl();
                    Fan_Duct_hardware(xCarriageType, hotend_type);
                }
}

module Fan_Duct_stl() {
    stl("Fan_Duct")
        color(pp2_colour)
            fanDuct(printHeadHotendOffset().x);
}
