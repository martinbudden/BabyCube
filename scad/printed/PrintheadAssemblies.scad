include <../global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/vitamins/rails.scad>
use <NopSCADlib/vitamins/wire.scad>

use <../utils/carriageTypes.scad>
use <../utils/PrintheadOffsets.scad>
use <../utils/X_rail.scad>

use <../vitamins/bolts.scad>
include <../vitamins/pcbs.scad>

use <Printhead.scad>
use <X_Carriage.scad>
use <X_CarriageBeltAttachment.scad>
use <X_CarriageAssemblies.scad>

use <../Parameters_CoreXY.scad>
use <../Parameters_Positions.scad>
include <../Parameters_Main.scad>


function hotendClampOffset(xCarriageType, hotend_type=0) =  [hotendOffset(xCarriageType, hotend_type).x, 18 + xCarriageBackOffsetY(xCarriageType) + grooveMountOffsetX(hotend_type), hotendOffset(xCarriageType, hotend_type).z];
grooveMountFillet = 1;
function grooveMountClampSize(blower_type, hotend_type) = [grooveMountSize(blower_type, hotend_type).y - 2*grooveMountFillet - grooveMountClampOffsetX(), 12, 15];

module printheadAssembly() {
    xCarriageType = xCarriageType();
    blower_type = blower_type();
    hotend_type = 0;
    hotendOffset = hotendOffset(xCarriageType, hotend_type);

    explode([20, 0, 0])
        hotEndHolderHardware(xCarriageType, hotend_type);

    translate(hotendClampOffset(xCarriageType, hotend_type))
        rotate([90, 0, -90]) {
            explode(-40, true) {
                stl_colour(pp2_colour)
                    Hotend_Clamp_stl();
                Hotend_Clamp_hardware(xCarriageType, blower_type, hotend_type, countersunk=true);
            }
            explode(-60, true)
                translate([0, grooveMountClampStrainReliefOffset(), -grooveMountClampSize(blower_type, hotend_type).z - 5])
                    vflip() {
                        stl_colour(pp1_colour)
                            Hotend_Strain_Relief_Clamp_stl();
                        Hotend_Strain_Relief_Clamp_hardware();
                    }
        }
}

//!1. Assemble the E3D hotend, including fan, thermistor cartridge and heater cartridge.
//!2. Use the Hotend_Clamp to attach the hotend to the X_Carriage.
//!3. Collect the wires together and attach to the X_Carriage using the Hotend_Strain_Relief_Clamp.
module Printhead_assembly()
assembly("Printhead", big=true) {

    X_Carriage_assembly();
    printheadAssembly();
}

module Printhead_E3DV6_MGN9C_assembly() pose(a=[55, 0, 25 + 180])
assembly("Printhead_E3DV6_MGN9C", big=true) {

    X_Carriage_Groovemount_MGN9C_assembly();
    printheadAssembly();
}

module printheadBeltSide(rotate=0, explode=0, t=undef) {
    xCarriageType = xCarriageType();

    xRailCarriagePosition(carriagePosition(t))
        explode(explode, true)
            rotate(rotate) {// for debug, to see belts better
                explode([0, -20, 0], true)
                    X_Carriage_Belt_Side_MGN9C_assembly();
                xCarriageTopBolts(xCarriageType, countersunk=_xCarriageCountersunk, positions = [ [1, -1], [-1, -1] ]);
                xCarriageBeltClampAssembly(xCarriageType);
            }
}

module printheadHotendSide(rotate=0, explode=0, t=undef, accelerometer=false) {
    xCarriageType = xCarriageType();
    xCarriageFrontSize = xCarriageFrontSize(xCarriageType, _beltWidth, clamps=false) + [xCarriageBeltAttachmentMGN9CExtraX(), 0, 3];

    xRailCarriagePosition(carriagePosition(t))
        explode(explode, true)
            rotate(rotate) {// for debug, to see belts better
                explode([0, -20, 0], true)
                    xCarriageFrontBolts(xCarriageType, xCarriageFrontSize, topBoltLength=30, bottomBoltLength=30, countersunk=true);
                Printhead_E3DV6_MGN9C_assembly();
                xCarriageTopBolts(xCarriageType, countersunk=_xCarriageCountersunk, positions = [ [1, 1], [-1, 1] ]);
            }
}

module fullPrinthead(rotate=0, explode=0, t=undef, accelerometer=false) {
    xCarriageType = xCarriageType();

    xRailCarriagePosition(carriagePosition(t))
        explode(explode, true)
            rotate(rotate) {// for debug, to see belts better
                explode([0, -20, 0], true) {
                    X_Carriage_Front_assembly();
                    xCarriageFrontBolts(xCarriageType, xCarriageFrontSize(xCarriageType, _beltWidth, clamps=true));
                }
                Printhead_assembly();
                xCarriageTopBolts(xCarriageType, countersunk=_xCarriageCountersunk);
                if (accelerometer)
                    explode(50, true)
                        printheadAccelerometerAssembly();
                if (!exploded())
                    xCarriageBeltFragments(xCarriageType, coreXY_belt(coreXY_type()), beltOffsetZ(), coreXYSeparation().z, coreXY_upper_belt_colour(coreXY_type()), coreXY_lower_belt_colour(coreXY_type()));
            }
}

module printheadAccelerometerAssembly() {
    translate(accelerometerOffset() + [0, 0, 1])
        rotate(180) {
            pcb = ADXL345;
            pcb(pcb);
            pcb_hole_positions(pcb) {
                translate_z(pcb_size(pcb).z)
                    boltM3Caphead(10);
                explode(-5)
                    vflip()
                        washer(M3_washer)
                            washer(M3_washer);
            }
        }
}

module hotEndHolderHardware(xCarriageType, hotend_type=0) {
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
    stl("Hotend_Clamp")
        color(pp2_colour)
            grooveMountClamp(grooveMountClampSize(BL30x10), strainRelief=true);
}

module Hotend_Clamp_40_stl() {
    stl("Hotend_Clamp")
        color(pp2_colour)
            grooveMountClamp(grooveMountClampSize(BL40x10));
}

module Hotend_Clamp_hardware(xCarriageType, blower_type, hotend_type, countersunk=false) {
    grooveMountClampHardware(grooveMountClampSize(blower_type, hotend_type), countersunk);
}
