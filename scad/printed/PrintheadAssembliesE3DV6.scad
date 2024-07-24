include <../global_defs.scad>

use <NopSCADlib/vitamins/wire.scad>

include <../utils/X_Rail.scad>

use <X_CarriageBeltAttachment.scad>

include <X_CarriageE3DV6.scad>

include <../Parameters_CoreXY.scad>
use <../Parameters_Positions.scad>


module printheadE3DV6Assembly() {
    xCarriageType = carriageType(_xCarriageDescriptor);
    blower_type = blower_type();
    hotendDescriptor = "E3DV6";
    hotendOffset = hotendOffset(xCarriageType, hotendDescriptor);

    explode([20, 0, 0])
    translate(hotendOffset) {
        E3Dv6plusFan();

        rotate([90, 0, -90]) {
            explode(-40, true) {
                stl_colour(pp2_colour)
                    E3DV6_Clamp_stl();
                E3DV6_Clamp_hardware(xCarriageType, blower_type, hotendDescriptor, countersunk=true);
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
}

//!1. Assemble the E3D hotend, including fan, thermistor cartridge and heater cartridge.
//!2. Use the **E3DV6_Clamp** to attach the hotend to the **X_Carriage_Groovemount**.
//!3. Collect the wires together and attach to the **X_Carriage_Groovemount** using the **Hotend_Strain_Relief_Clamp**.
//
module Printhead_E3DV6_MGN9C_HC_assembly() pose(a=[55, 0, 25 + 180])
assembly("Printhead_E3DV6_MGN9C_HC", big=true) {

    xCarriageGroovemountMGN9CAssembly(halfCarriage=true);
    printheadE3DV6Assembly();
}

//!1. Assemble the E3D hotend, including fan, thermistor cartridge and heater cartridge.
//!2. Use the **E3DV6_Clamp** to attach the hotend to the **X_Carriage_Groovemount**.
//!3. Collect the wires together and attach to the **X_Carriage_Groovemount** using the **Hotend_Strain_Relief_Clamp**.
//
module Printhead_E3DV6_MGN9C_assembly() pose(a=[55, 0, 25 + 180])
assembly("Printhead_E3DV6_MGN9C", big=true) {

    xCarriageGroovemountMGN9CAssembly(halfCarriage=false);
    printheadE3DV6Assembly();
}

module printheadHotendSide(rotate=0, explode=0, t=undef, accelerometer=false, halfCarriage=true) {
    xCarriageType = carriageType(_xCarriageDescriptor);
    xCarriageBeltSideSize = xCarriageBeltSideSize(xCarriageType, beltWidth()) + [xCarriageBeltAttachmentMGN9CExtraX(), 0, 0];
    holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);
    screwType = halfCarriage ? hs_cs_cap : hs_cap;

    xRailCarriagePosition(carriagePosition(t), rotate=rotate)
        explode(explode, true) {
            explode([0, -20, 0], true)
                xCarriageBeltSideBolts(xCarriageType, xCarriageBeltSideSize, topBoltLength=25, holeSeparationTop=holeSeparationTop, bottomBoltLength=25, holeSeparationBottom=holeSeparationBottom, screwType=screwType, boreDepth=xCarriageBoreDepth());
            if (halfCarriage) {
                xCarriageTopBolts(xCarriageType, countersunk=_xCarriageCountersunk, positions = [ [1, 1], [-1, 1] ]);
                Printhead_E3DV6_MGN9C_HC_assembly();
            } else {
                Printhead_E3DV6_MGN9C_assembly();
            }
        }
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

module E3DV6_Clamp_stl() {
    stl("E3DV6_Clamp")
        color(pp2_colour)
            grooveMountClamp(grooveMountClampSize(BL30x10), strainRelief=true, left=true);
}

module E3DV6_Clamp_40_stl() {
    stl("E3DV6_Clamp_40")
        color(pp2_colour)
            grooveMountClamp(grooveMountClampSize(BL40x10), left=true);
}

module E3DV6_Clamp_hardware(xCarriageType, blower_type, hotendDescriptor, countersunk=false) {
    grooveMountClampHardware(grooveMountClampSize(blower_type, hotendDescriptor), countersunk, left=true);
}
