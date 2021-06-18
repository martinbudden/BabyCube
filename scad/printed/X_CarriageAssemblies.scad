
include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/vitamins/rails.scad>

use <../utils/carriageTypes.scad>
use <../utils/PrintheadOffsets.scad>

use <../vitamins/bolts.scad>
include <../vitamins/pcbs.scad>

use <Printhead.scad>
use <X_Carriage.scad>
use <X_CarriageBeltClamps.scad>
use <X_CarriageFanDuct.scad>

use <../Parameters_CoreXY.scad>
include <../Parameters_Main.scad>


function hotendOffset(xCarriageType, hotend_type=0) = printHeadHotendOffset(hotend_type) + [-xCarriageBackSize(xCarriageType).x/2, xCarriageBackOffsetY(xCarriageType), 0];
function grooveMountSize(blower_type, hotend_type=0) = [printHeadHotendOffset(hotend_type).x, blower_size(blower_type).x + 6.25, 12];
function blower_type() = is_undef(_blowerDescriptor) || _blowerDescriptor == "BL30x10" ? BL30x10 : BL40x10;
function accelerometerOffset() = [0, 3, 8];

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
    size = xCarriageFrontSize(xCarriageType, _beltWidth);
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

module xCarriageFrontAssemblyBolts(xCarriageType, beltWidth) {
    assert(isCarriageType(xCarriageType));

    size = xCarriageFrontSize(xCarriageType, beltWidth);

    translate([-size.x/2, -xCarriageFrontOffsetY(xCarriageType), 0]) {
        // holes at the top to connect to the printhead
        for (x = xCarriageTopHolePositions(xCarriageType))
            translate([x, 0, xCarriageTopThickness()/2])
                rotate([90, 90, 0])
                    boltM3Buttonhead(10);
        // holes at the bottom to connect to the printhead
        for (x = xCarriageBottomHolePositions(xCarriageType))
            translate([x, 0, -size.z + xCarriageTopThickness() + xCarriageBaseThickness()/2])
                rotate([90, 90, 0])
                    boltM3Buttonhead(12);
    }
}

module xCarriageAssembly(xCarriageType, beltOffsetZ, coreXYSeparationZ) {
    assert(is_list(xCarriageType));

    size = xCarriageBackSize(xCarriageType, _beltWidth);
    hotend_type = 0;

    //translate([-size.x/2-eps, carriage_size(xCarriageType).y/2 - beltInsetBack(xCarriageType) + xCarriageBackSize(xCarriageType).y, beltOffsetZ + coreXYSeparationZ/2]) {
    //!!TODO fix magic number 5
    translate([-size.x/2 - 1, carriage_size(xCarriageType).y/2 - beltInsetBack(xCarriageType) + xCarriageBackSize(xCarriageType).y, beltOffsetZ - 5]) {
        rotate([0, 90, 180])
            explode(10, true) {
                stl_colour(pp2_colour)
                    Belt_Clamp_stl();
                Belt_Clamp_hardware(_beltWidth);
            }
        translate([size.x + 2, 0, coreXYSeparationZ])
            rotate([0, 90, 0])
                explode(10, true) {
                    stl_colour(pp2_colour)
                        Belt_Clamp_stl();
                    Belt_Clamp_hardware(_beltWidth);
                }
    }
}

module X_Carriage_stl() {
    xCarriageType = xCarriageType();
    blower_type = blower_type();
    hotend_type = 0;
    grooveMountSize = grooveMountSize(blower_type, hotend_type);
    hotendOffset = hotendOffset(xCarriageType, hotend_type);

    stl("X_Carriage")
        color(pp1_colour)
            rotate([0, -90, 0]) {
                difference() {
                    xCarriageBack(xCarriageType, _beltWidth, beltOffsetZ(), coreXYSeparation().z, strainRelief=true, countersunk=_xCarriageCountersunk ? 4 : 0);
                    translate(accelerometerOffset())
                        rotate(180)
                            pcb_hole_positions(ADXL345)
                                vflip()
                                    boltHoleM3Tap(8, horizontal=true, rotate=-90);
                }
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

    xCarriageAssembly(xCarriageType, beltOffsetZ(), coreXYSeparation().z);

    grooveMountSize = grooveMountSize(blower_type, hotend_type);

    explode([-20, 0, 10], true)
        hotEndPartCoolingFan(xCarriageType, grooveMountSize, hotendOffset, blower_type, left=true);
    explode([-20, 0, -10], true)
        translate([0, -1.5, hotendOffset.z])
            blowerTranslate(xCarriageType, grooveMountSize, hotendOffset, blower_type, left=false)
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
