include <../global_defs.scad>

include <Printhead.scad>

include <NopSCADlib/vitamins/blowers.scad>
use <NopSCADlib/vitamins/wire.scad>

include <../utils/PrintheadOffsets.scad>
include <../utils/X_Rail.scad>

include <../vitamins/pcbs.scad>

include <../utils/carriageTypes.scad>

use <X_CarriageBeltAttachment.scad>
use <X_CarriageAssemblies.scad>

include <../Parameters_CoreXY.scad>
use <../Parameters_Positions.scad>


function hotendClampOffset(xCarriageType, hotendDescriptor="E3DV6") =  [hotendOffset(xCarriageType, hotendDescriptor).x, 18 + xCarriageHotendOffsetY(xCarriageType) + grooveMountOffsetX(hotendDescriptor), hotendOffset(xCarriageType, hotendDescriptor).z];
grooveMountFillet = 1;
function grooveMountClampSize(blower_type, hotendDescriptor) = [grooveMountSize(blower_type, hotendDescriptor).y - 2*grooveMountFillet - grooveMountClampOffsetX(), 12, 15];

module printheadAssembly() {
    xCarriageType = carriageType(_xCarriageDescriptor);
    blower_type = blower_type();
    hotendDescriptor = "E3DV6";
    hotendOffset = hotendOffset(xCarriageType, hotendDescriptor);

    explode([20, 0, 0])
        hotEndHolderHardware(xCarriageType, hotendDescriptor);

    translate(hotendClampOffset(xCarriageType, hotendDescriptor))
        rotate([90, 0, -90]) {
            explode(-40, true) {
                stl_colour(pp2_colour)
                    Hotend_Clamp_stl();
                Hotend_Clamp_hardware(xCarriageType, blower_type, hotendDescriptor, countersunk=true);
            }
            explode(-60, true)
                translate([0, grooveMountClampStrainReliefOffset(), -grooveMountClampSize(blower_type, hotendDescriptor).z - 6])
                    vflip() {
                        stl_colour(pp1_colour)
                            Hotend_Strain_Relief_Clamp_stl();
                        Hotend_Strain_Relief_Clamp_hardware();
                    }
        }
}

/*
module Printhead_assembly()
assembly("Printhead", big=true) {

    X_Carriage_assembly();
    printheadAssembly();
}
*/

//!1. Assemble the E3D hotend, including fan, thermistor cartridge and heater cartridge.
//!2. Use the **Hotend_Clamp** to attach the hotend to the **X_Carriage**.
//!3. Collect the wires together and attach to the **X_Carriage** using the **Hotend_Strain_Relief_Clamp**.
//
module Printhead_E3DV6_MGN9C_assembly() pose(a=[55, 0, 25 + 180])
assembly("Printhead_E3DV6_MGN9C", big=true) {

    X_Carriage_Groovemount_MGN9C_assembly();
    printheadAssembly();
}

module printheadBeltSide(rotate=0, explode=0, t=undef) {
    xCarriageType = carriageType(_xCarriageDescriptor);

    xRailCarriagePosition(carriagePosition(t), rotate)
        explode(explode, true) {
            explode([0, -20, 0], true)
                X_Carriage_Belt_Side_MGN9C_assembly();
            xCarriageTopBolts(xCarriageType, countersunk=_xCarriageCountersunk, positions = [ [1, -1], [-1, -1] ]);
            xCarriageBeltClampAssembly(xCarriageType);
        }
}

module printheadHotendSide(rotate=0, explode=0, t=undef, accelerometer=false) {
    xCarriageType = carriageType(_xCarriageDescriptor);
    xCarriageBeltSideSize = xCarriageBeltSideSize(xCarriageType, beltWidth()) + [xCarriageBeltAttachmentMGN9CExtraX(), 0, 0];
    holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);

    xRailCarriagePosition(carriagePosition(t), rotate=rotate)
        explode(explode, true) {
            explode([0, -20, 0], true)
                xCarriageBeltSideBolts(xCarriageType, xCarriageBeltSideSize, topBoltLength=30, holeSeparationTop=holeSeparationTop, bottomBoltLength=30, holeSeparationBottom=holeSeparationBottom, countersunk=true);
            Printhead_E3DV6_MGN9C_assembly();
            xCarriageTopBolts(xCarriageType, countersunk=_xCarriageCountersunk, positions = [ [1, 1], [-1, 1] ]);
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

module hotEndHolderHardware(xCarriageType, hotendDescriptor="E3DV6") {
    hotendOffset = hotendOffset(xCarriageType, hotendDescriptor);

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
                            poly_circle(r=M3_clearance_radius);
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

module Hotend_Clamp_hardware(xCarriageType, blower_type, hotendDescriptor, countersunk=false) {
    grooveMountClampHardware(grooveMountClampSize(blower_type, hotendDescriptor), countersunk);
}
