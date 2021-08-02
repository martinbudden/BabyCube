
include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/vitamins/rails.scad>

use <../utils/carriageTypes.scad>
use <../utils/PrintheadOffsets.scad>

use <../vitamins/bolts.scad>

use <Printhead.scad>
use <X_Carriage.scad>
use <X_CarriageBeltAttachment.scad>
use <X_CarriageBeltClamps.scad>
use <X_CarriageFanDuct.scad>

use <../Parameters_CoreXY.scad>
include <../Parameters_Main.scad>

//!!TODO - change hotendoffset.z to 1.5 for new X_Carriage with belt attachments
function hotendOffset(xCarriageType, hotend_type=0) = printHeadHotendOffset(hotend_type) + [-xCarriageBackSize(xCarriageType).x/2, xCarriageBackOffsetY(xCarriageType), 0];
function grooveMountSize(blower_type, hotend_type=0) = [printHeadHotendOffset(hotend_type).x, blower_size(blower_type).x + 6.25, 12];
function blower_type() = is_undef(_blowerDescriptor) || _blowerDescriptor == "BL30x10" ? BL30x10 : BL40x10;
function accelerometerOffset() = [0, 3, 8];

xCarriageBeltTensionerSizeX = 23;


module X_Carriage_Belt_Side_MGN9C_stl() {
    xCarriageType = MGN9C_carriage;
    extraX = xCarriageBeltAttachmentMGN9CExtraX();
    size = xCarriageFrontSize(xCarriageType, _beltWidth, clamps=false) + [extraX, 1, 3];

    // orientate for printing
    stl("X_Carriage_Belt_Side_MGN9C")
        color(pp4_colour)
            translate([extraX/2, 0, 0])
                rotate([90, 0, 0])
                    xCarriageBeltSide(xCarriageType, size, extraX=4, accelerometerOffset=accelerometerOffset(), countersunk=false, topHoleOffset=-extraX/2);
}

//!Insert the belts into the **X_Carriage_Belt_Tensioner**s and then bolt the tensioners into the
//!**X_Carriage_Belt_Side_MGN9C** part as shown. Note the belts are not shown in this diagram.
//
module X_Carriage_Belt_Side_MGN9C_assembly()
assembly("X_Carriage_Belt_Side_MGN9C") {

    rotate([-90, 0, 0])
        stl_colour(pp4_colour)
            X_Carriage_Belt_Side_MGN9C_stl();

    offset = xCarriageBeltTensionerSizeX - 0.5;
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
            xCarriageBeltClamp(size, countersunk=true);
}

module xCarriageBeltClampAssembly(xCarriageType) {
    size = xCarriageFrontSize(xCarriageType, _beltWidth, clamps=false);
    translate([4, 0.3, 3.85])
        xCarriageBeltClampPosition(xCarriageType, size) {
            stl_colour(pp2_colour)
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
                size = xCarriageBackSize(xCarriageType, _beltWidth, clamps=true) - [0, 0, 1.5];
                xCarriageBack(xCarriageType, size, _beltWidth, beltOffsetZ(), coreXYSeparation().z, clamps=false, strainRelief=false, countersunk=_xCarriageCountersunk ? 4 : 0, topHoleOffset=-xCarriageBeltAttachmentMGN9CExtraX()/2, accelerometerOffset = accelerometerOffset());
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

module X_Carriage_Front_stl() {
    xCarriageType = xCarriageType();

    // orientate for printing
    stl("X_Carriage_Front")
        color(pp4_colour)
            rotate([0, -90, 0])
                xCarriageFront(xCarriageType, _beltWidth, beltOffsetZ(), coreXYSeparation().z);
}

//!1. Bolt the Belt_Clamps to the X_Carriage_Front, leaving them loose for later insertion of the belts.
//!2. Insert the Belt_tensioners into the X_Carriage_Front, and use the 20mm bolts to secure them in place.
module X_Carriage_Front_assembly()
assembly("X_Carriage_Front", big=true) {

    xCarriageType = xCarriageType();
    size = xCarriageFrontSize(xCarriageType, _beltWidth, clamps=true);
    beltOffsetZ = beltOffsetZ();

    rotate([0, 90, 0])
        stl_colour(pp4_colour)
            X_Carriage_Front_stl();

    translate([-size.x/2, -xCarriageFrontOffsetY(xCarriageType), 0]) {
        for (i= [
                    [beltClampOffsetX(), -1.5, beltOffsetZ - coreXYSeparation().z/2],
                    [size.x - beltClampOffsetX(), -1.5, beltOffsetZ + coreXYSeparation().z/2]
                ])
            translate(i)
                rotate([0, -90, 90])
                    explode(20, true) {
                        stl_colour(pp2_colour)
                            Belt_Clamp_stl();
                        Belt_Clamp_hardware(_beltWidth);
                    }
        translate([size.x/2, -1.5, beltOffsetZ])
            rotate([0, -90, 90])
                explode(20, true) {
                    stl_colour(pp2_colour)
                        Belt_Tidy_stl();
                    Belt_Tidy_hardware(_beltWidth);
                }

        translate([12, (size.y + beltInsetFront(xCarriageType))/2, beltOffsetZ - coreXYSeparation().z/2]) {
            explode([0, -10, 0])
                stl_colour(pp3_colour)
                    Belt_Tensioner_stl();
            Belt_Tensioner_hardware(_beltWidth);
        }

        translate([size.x - 12, (size.y + beltInsetFront(xCarriageType))/2, beltOffsetZ + coreXYSeparation().z/2])
            rotate(180) {
                explode([0, 10, 0])
                    stl_colour(pp3_colour)
                        Belt_Tensioner_stl();
                Belt_Tensioner_hardware(_beltWidth);
            }
    }
}

module xCarriageBeltClamps(xCarriageType) {
    assert(is_list(xCarriageType));

    sizeX = xCarriageBackSize(xCarriageType, _beltWidth).x;

    translate([-sizeX/2 - 1, 0, -coreXYSeparation().z/2])
        rotate([0, 90, 180])
            explode(10, true) {
                stl_colour(pp2_colour)
                    Belt_Clamp_stl();
                Belt_Clamp_hardware(_beltWidth);
            }
    translate([sizeX/2 + 1, 0, coreXYSeparation().z/2])
        rotate([0, 90, 0])
            explode(10, true) {
                stl_colour(pp2_colour)
                    Belt_Clamp_stl();
                Belt_Clamp_hardware(_beltWidth);
            }
}

module X_Carriage_stl() {
    xCarriageType = xCarriageType();
    blower_type = blower_type();
    hotend_type = 0;
    grooveMountSize = grooveMountSize(blower_type, hotend_type);
    hotendOffset = hotendOffset(xCarriageType, hotend_type);
    holeSeparation = 22;

    stl("X_Carriage")
        color(pp1_colour)
            rotate([0, -90, 0]) {
                size = xCarriageBackSize(xCarriageType, _beltWidth, clamps=true);
                xCarriageBack(xCarriageType, size, _beltWidth, beltOffsetZ(), coreXYSeparation().z, clamps=true, strainRelief=false, countersunk=_xCarriageCountersunk ? 4 : 0, accelerometerOffset = accelerometerOffset());
                hotEndHolder(xCarriageType, grooveMountSize, hotendOffset, hotend_type, blower_type, baffle=true, left=true);
            }
}

//!1. Bolt the belt clamps to the sides of the X_Carriage. Leave the clamps loose to allow later insertion of the belts.
//!2. Bolt the fan onto the side of the X_Carriage, secure the fan wire with a ziptie.
//!3. Ensure a good fit between the fan and the fan duct and bolt the fan duct to the X_Carriage.
module X_Carriage_assembly()  pose(a=[55, 0, 25 + 290])
assembly("X_Carriage", big=true, ngb=true) {

    xCarriageType = xCarriageType();
    blower_type = blower_type();
    hotend_type = 0;
    hotendOffset = hotendOffset(xCarriageType, hotend_type);

    rotate([0, 90, 0])
        stl_colour(pp1_colour)
            X_Carriage_stl();

    translate([0, carriage_size(xCarriageType).y/2 + xCarriageBackSize(xCarriageType).y - beltInsetBack(xCarriageType), beltOffsetZ()])
        xCarriageBeltClamps(xCarriageType);

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

module Belt_Tidy_stl() {
    stl("Belt_Tidy")
        color(pp2_colour)
            beltTidy(_beltWidth);
}

module Belt_Clamp_stl() {
    stl("Belt_Clamp")
        color(pp2_colour)
            beltClamp(_beltWidth);
}

module Belt_Tensioner_stl() {
    stl("Belt_Tensioner")
        color(pp3_colour)
            beltTensioner(_beltWidth);
}

module Fan_Duct_stl() {
    stl("Fan_Duct")
        color(pp2_colour)
            fanDuct(printHeadHotendOffset().x);
}
