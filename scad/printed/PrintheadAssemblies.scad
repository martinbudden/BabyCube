include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/core_xy.scad>
include <NopSCADlib/vitamins/belts.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/vitamins/rails.scad>

use <../utils/carriageTypes.scad>
use <../utils/PrintheadOffsets.scad>
use <../utils/X_rail.scad>

use <../vitamins/bolts.scad>
use <../vitamins/extruder.scad>

use <Printhead.scad>
use <X_Carriage.scad>
use <X_CarriageAssemblies.scad>

use <../Parameters_CoreXY.scad>
include <../Parameters_Main.scad>


//!
//!Note that wiring is not shown in this diagram.
//!
//!1. Assemble the E3D hotend, including fan, thermistor cartridge and heater cartridge.
//!2. Use the Hotend_Clamp to attach the hotend to the X_Carriage.
//!3. Collect the wires together and attach to the X_Carriage using the Hotend_Strain_Relief_Clamp.
module Print_head_assembly()
assembly("Print_head", big=true) {

    X_Carriage_assembly();

    xCarriageType = xCarriageType();
    blower_type = BL30x10;
    hotend_type = 0;

    explode([20, 0, 0])
        hotEndHolderHardware(xCarriageType, hotend_type);

    translate(hotendClampOffset(xCarriageType, hotend_type))
        rotate([90, 0, -90]) {
            explode(-40, true) {
                stl_colour(pp2_colour)
                    Hotend_Clamp_stl();
                Hotend_Clamp_hardware(xCarriageType, hotend_type, blower_type);
            }
            explode(-60, true)
                translate([0, grooveMountClampStrainReliefOffset(), -grooveMountClampSize(xCarriageType, hotend_type, blower_type).z - 5])
                    vflip() {
                        stl_colour(pp1_colour)
                            Hotend_Strain_Relief_Clamp_stl();
                        Hotend_Strain_Relief_Clamp_hardware();
                    }
        }
}

module fullPrinthead(rotate=0) {
    xRailCarriagePosition()
        rotate(rotate) {// for debug, to see belts better
            explode([0, -20, 0], true) {
                X_Carriage_Front_assembly();
                xCarriageFrontAssemblyBolts(xCarriageType());
            }
            Print_head_assembly();
            xCarriageTopBolts(xCarriageType());
            if (!exploded())
                xCarriageBeltFragments(xCarriageType(), beltOffsetZ(), coreXYSeparation().z, coreXY_upper_belt_colour(coreXY_type()), coreXY_lower_belt_colour(coreXY_type()));
        }
}


module hotEndHolderHardware(xCarriageType, hotend_type) {
    hotendOffset = hotendOffset(xCarriageType, hotend_type);

    translate(hotendOffset)
        E3Dv6plusFan();
}


module Hotend_Strain_Relief_Clamp_stl() {
    holeSpacing = hotendStrainReliefClampHoleSpacing();
    size = [holeSpacing + 8, 10, 3];

    stl("Hotend_Strain_Relief_Clamp")
        color(pp1_colour)
            linear_extrude(size.z)
                difference() {
                    rounded_square([size.x, size.y], 1.5);
                    for (x = [-holeSpacing/2, holeSpacing/2])
                        translate([x, 0, 0])
                            poly_circle(r = M3_clearance_radius);
                }
}

module Hotend_Strain_Relief_Clamp_hardware() {
    holeSpacing = hotendStrainReliefClampHoleSpacing();
    size = [holeSpacing + 8, 10, 3];

    for (x = [-holeSpacing/2, holeSpacing/2])
        translate([x, 0, size.z])
            boltM3Buttonhead(12);
}

module Hotend_Clamp_stl() {
    blower_type = BL30x10;

    stl("Hotend_Clamp")
        color(pp2_colour)
            grooveMountClamp(MGN9C_carriage, 0, blower_type);
}

module Hotend_Clamp_40_stl() {
    blower_type = BL40x10;

    stl("Hotend_Clamp")
        color(pp2_colour)
            grooveMountClamp(MGN9C_carriage, 0, blower_type);
}

module Hotend_Clamp_hardware(xCarriageType, hotend_type, blower_type) {
    grooveMountClampHardware(xCarriageType, hotend_type, blower_type);
}

module Hotend_Clamp_MGN12H_stl() {
    blower_type = BL40x10;

    stl("Hotend_Clamp_MGN12H")
        color(pp2_colour)
            grooveMountClamp(MGN12H_carriage, 0, blower_type);
}

fanDuctTabThickness = 2;


module Fan_Duct_stl() {
    blower_type = BL30x10;
    blowerSize = blower_size(blower_type);

    exit = blower_exit(blower_type);
    wallLeft = blower_wall_left(blower_type);
    wallRight = blower_wall_right(blower_type);
    base = blower_base(blower_type);
    top = blower_top(blower_type);

    stl("Fan_Duct")
        color(pp2_colour) {
            difference() {
                fillet = 2;
                offsetX = 1;
                chimneySize = [exit + wallLeft + wallRight - offsetX, blowerSize.z, 14];
                chimneyTopSize = [exit, blowerSize.z - base - top, chimneySize.z + 2];
                union() {
                    translate([0, -chimneySize.y, -chimneySize.z]) {
                        translate([offsetX, 0, 0])
                            rounded_cube_xy(chimneySize, fillet);
                        translate([wallLeft, top, 0])
                            rounded_cube_xy(chimneyTopSize, fillet);
                        translate([offsetX, 0, -3]) {
                            // the foot
                            hull() {
                                rounded_cube_xy([chimneySize.x, chimneySize.y, 5], fillet);
                                translate([0, 11, 0])
                                    rounded_cube_xy([chimneySize.x, 5, 3], fillet);
                            }
                        }
                    }
                    tabTopSize = [33.25, fanDuctTabThickness, 5];
                    tabBottomSize = [chimneySize.x, tabTopSize.y, 1];
                    hull() {
                        translate([offsetX, -fanDuctTabThickness, -chimneySize.z+0.5])
                            rounded_cube_xy(tabBottomSize, 0.5);
                        translate([30 - tabTopSize.x, -fanDuctTabThickness, -tabTopSize.z])
                            rounded_cube_xy(tabTopSize, 0.5);
                    }
                }
                fanDuctHolePositions(-fanDuctTabThickness)
                    rotate([-90, 180, 0])
                        boltHoleM2(fanDuctTabThickness, horizontal=true);

                flueSize = chimneyTopSize - [1.5, 1.5, 0];
                translate([wallLeft + 1.5/2, -chimneySize.y + top+1.5/2, -chimneySize.z + eps])
                    rounded_cube_xy(flueSize, 1);

                jetEndSize = [5, 2, 2];
                jetStartSize = [16, 2, 2];
                translate([13, -8, 0])
                    #hull() {
                        translate([-jetEndSize.x/2, 6+printHeadHotendOffset().x, -21])
                            cube(jetEndSize);
                        translate([-jetStartSize.x/2, 0, -13])
                            cube(jetStartSize);
                    }
            }
        }
}

module Fan_Duct_hardware(xCarriageType, hotend_type) {
    fanDuctHolePositions(-fanDuctTabThickness)
        rotate([90, 0, 0])
            boltM2Caphead(6);
}

/*module fanDuctTranslate(xCarriageType, hotend_type) {
    hotendOffset = hotendOffset(xCarriageType);
    grooveMountSize = grooveMountSize(xCarriageType, hotend_type, blower_type);

    translate([hotendOffset.x - grooveMountSize.x, hotendOffset.y + grooveMountOffsetX(hotend_type), 3 - grooveMountSize.z/2 - 38])
        rotate([90, 0, 90])
            children();
}*/
