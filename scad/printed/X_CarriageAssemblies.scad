
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
use <X_CarriageBeltClamps.scad>
use <X_CarriageFanDuct.scad>

use <../Parameters_CoreXY.scad>
include <../Parameters_Main.scad>


function blower_type() = is_undef(_blower_type) || _blower_type == 30 ? BL30x10 : BL40x10;

module X_Carriage_Front_stl() {
    xCarriageType = xCarriageType();

    // orientate for printing
    stl("X_Carriage_Front")
        color(pp4_colour)
            rotate([0, -90, 0])
                xCarriageFront(xCarriageType, beltOffsetZ(), coreXYSeparation().z);
}

//!1. Bolt the Belt_Clamps to the X_Carriage_Front, leaving them loose for later insertion of the belts.
//!2. Insert the Belt_tensioners into the X_Carriage_Front, and use the 20mm bolts to secure them in place.
module X_Carriage_Front_assembly()
assembly("X_Carriage_Front", big=true) {

    xCarriageType = xCarriageType();
    size = xCarriageFrontSize(xCarriageType);
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
                        Belt_Clamp_hardware();
                    }
        translate([size.x/2, -1.5, beltOffsetZ])
            rotate([0, -90, 90])
                explode(20, true) {
                    hidden()
                        stl_colour(pp2_colour)
                            Belt_Tidy_stl();
                    //Belt_Tidy_hardware();
                }

        translate([12, (size.y + beltInsetFront())/2, beltOffsetZ - coreXYSeparation().z/2]) {
            explode([0, -10, 0])
                stl_colour(pp3_colour)
                    Belt_Tensioner_stl();
            Belt_Tensioner_hardware();
        }

        translate([size.x - 12, (size.y + beltInsetFront())/2, beltOffsetZ + coreXYSeparation().z/2])
            rotate(180) {
                explode([0, 10, 0])
                    stl_colour(pp3_colour)
                        Belt_Tensioner_stl();
                Belt_Tensioner_hardware();
            }
    }
}

module xCarriageFrontAssemblyBolts(xCarriageType) {
    assert(is_list(xCarriageType));

    size = xCarriageFrontSize(xCarriageType);

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

    size = xCarriageBackSize(xCarriageType);
    hotend_type = 0;

    //translate([-size.x/2-eps, carriage_size(xCarriageType).y/2-beltInsetBack()+xCarriageBackSize(xCarriageType).y, beltOffsetZ + coreXYSeparationZ/2]) {
    //!!TODO fix magic number 5
    translate([-size.x/2 - 1, carriage_size(xCarriageType).y/2 - beltInsetBack() + xCarriageBackSize(xCarriageType).y, beltOffsetZ - 5]) {
        rotate([0, 90, 180])
            explode(10, true) {
                stl_colour(pp2_colour)
                    Belt_Clamp_stl();
                Belt_Clamp_hardware();
            }
        translate([size.x + 2, 0, coreXYSeparationZ])
            rotate([0, 90, 0])
                explode(10, true) {
                    stl_colour(pp2_colour)
                        Belt_Clamp_stl();
                    Belt_Clamp_hardware();
                }
    }
}

module X_Carriage_stl() {
    xCarriageType = xCarriageType();
    blower_type = blower_type();
    hotend_type = 0;

    stl("X_Carriage")
        color(pp1_colour)
            rotate([0, -90, 0]) {
                xCarriageBack(xCarriageType, beltOffsetZ(), coreXYSeparation().z);
                hotEndHolder(xCarriageType, hotend_type, blower_type);
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

    rotate([0, 90, 0])
        stl_colour(pp1_colour)
            X_Carriage_stl();

    xCarriageAssembly(xCarriageType, beltOffsetZ(), coreXYSeparation().z);
    explode([-20, 0, 10], true)
        hotEndPartCoolingFan(xCarriageType, hotend_type, blower_type);

    explode([-20, 0, -10], true)
        blowerTranslate(xCarriageType, hotend_type, blower_type)
            rotate([-90, 0, 0]) {
                stl_colour(pp2_colour)
                    Fan_Duct_stl();
                Fan_Duct_hardware(xCarriageType, hotend_type);
            }
}
