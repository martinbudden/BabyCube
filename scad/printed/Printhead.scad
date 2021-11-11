include <../global_defs.scad>

use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/e3d.scad>
include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/blowers.scad>
use <NopSCADlib/vitamins/wire.scad>

include <../utils/ziptieCutout.scad>

include <../vitamins/bolts.scad>

use <X_Carriage.scad>


grooveMountHoleOffsets = [13.5, -12];
function grooveMountOffsetX(hotend_type) = hotend_type == 0 ? 0 : 4;
function grooveMountClampOffsetX() = 0.5;

module hotEndHolderAlign(hotendOffset, left) {
    assert(left == true || left == false);
    rotate(left ? 0 : 180)
        translate([0, left ? 0 : -2*hotendOffset.y, hotendOffset.z])
            children();
}

module hotEndHolder(xCarriageType, grooveMountSize, hotendOffset, hotend_type, blower_type, baffle=true, left=true) {
    isMGN9C = xCarriageType[0] == "MGN9C";
    fillet = 1.5;
    offsetY = 0; // to avoid clashing with fan
    blowerMountOffsetY = 1;
    blowerMountSize = [3, grooveMountSize.y + blowerMountOffsetY, blower_size(blower_type).x + (xCarriageType[0] == "MGN9C" ? 9 : 5.5)];

    difference() {
        mirror([left ? 0 : 1, 0, 0])
        union() {
            translate([-xCarriageBackSize(xCarriageType).x/2, 3 + carriage_size(xCarriageType).y/2, hotendOffset.z - grooveMountSize.z/2]) {
                translate([0, -fillet, 0])
                    rounded_cube_yz(grooveMountSize + [0, fillet, 0], fillet);
                translate([0, 2, 0]) {
                    translate_z(grooveMountSize.z)
                        rotate([90, 0, 90])
                            fillet(1.5, grooveMountSize.x);
                    rotate([0, 90, 0])
                        fillet(1.5, grooveMountSize.x);
                }
                baffleOffsetZ = 30;
                baffleSize = [grooveMountSize.x - 7, grooveMountSize.y, 2];
                // fillet to improve airflow
                translate([blowerMountSize.x, 2, -baffleOffsetZ])
                    fillet(baffleSize.x - blowerMountSize.x + 5, baffleOffsetZ);
                blowerMountFillet = 1.5;
                if (blower_size(blower_type).x < 40) {
                    if (baffle) {
                        translate_z(-baffleOffsetZ)
                            rounded_cube_yz(baffleSize, 0.5);
                        baseOffsetZ = blowerMountSize.z - 2*blowerMountFillet;
                        if (!isMGN9C)
                            translate_z(-baseOffsetZ) {
                                rounded_cube_yz([baffleSize.x, 8, baffleSize.z + baseOffsetZ - baffleOffsetZ], 0.5);
                                sizeY = 6;
                                translate([0, blowerMountSize.y - blowerMountOffsetY - sizeY, 0])
                                    rounded_cube_yz([blowerMountSize.x + 4.5, sizeY, baffleSize.z + baseOffsetZ - baffleOffsetZ], blowerMountFillet);
                            }
                    }
                    translate_z(-blowerMountSize.z + 2*blowerMountFillet) {
                        translate([0, -blowerMountOffsetY, 0])
                            rounded_cube_yz(blowerMountSize, blowerMountFillet);
                        // add tab for fan duct bolt.
                        fanDuctTab = false;
                        if (fanDuctTab) {
                            rounded_cube_yz([blowerMountSize.x, blowerMountSize.y + 2.5, 6.5], blowerMountFillet);
                            translate([blowerMountSize.x, blowerMountSize.y, 6.5])
                                rotate([0, -90, 0])
                                    fillet(1, blowerMountSize.x);
                            translate([0, 2, 0])
                                rotate([0, 90, 0])
                                    fillet(1.5, blowerMountSize.x);
                        }
                    }
                }
            }
        }
        mirror([left ? 0 : 1, 0, 0])
        translate([-xCarriageBackSize(xCarriageType).x/2, hotendOffset.y - blower_size(blower_type).y/2 + 2, hotendOffset.z + 1])
            rotate([90, 0, -90])
                zipTieFullCutout(10);
        // holes for the strain relief clamp
        /*translate([hotendOffset.x - grooveMountSize.x, xCarriageBackSize(carriageType(_xCarriageDescriptor)).x/2 - 2*fillet, hotendOffset.z - grooveMountSize.z/2])
            for (x = [4, 14])
                translate([x, grooveMountSize.y, grooveMountSize.z/2])
                    rotate([90, 90, 0])
                        boltHoleM3Tap(8, horizontal=true, chamfer_both_ends=false);*/
        // bolt holes for blower
        rotate(left ? 0 : 180)
            translate([0, left ? 0 : -2*hotendOffset.y, hotendOffset.z])
                blowerTranslate(xCarriageType, grooveMountSize, hotendOffset, blower_type) {
                    blower_hole_positions(blower_type)
                        vflip()
                            boltHoleM2Tap(blowerMountSize.x + 4);
                    rotate([-90, 0, 0])
                        fanDuctHolePositions()
                            rotate([90, 0, 180])
                                boltHoleM2Tap(blowerMountSize.x + 4);
                }

        rotate(left ? 0 : 180)
            translate([0, left ? 0 : -2*hotendOffset.y, 0])
        translate(hotendOffset) {
            translate_z(-37)
                cylinder(r=11.5, h=4);
            rotate([-90, 0, 0])
                grooveMountCutout(grooveMountSize.z);
            for (y = grooveMountHoleOffsets)
                translate([0, y + grooveMountOffsetX(hotend_type) - (left ? 1.5 : 0), 0])
                    rotate([0, -90, 0])
                        boltHoleM3Tap(10);
        }
    }
}

module E3Dv6plusFan() {
    fan_type = fan30x10;
    translate_z(-36)
        rotate(180) {
            //vitamin(str("E3D_V6_Fan_Duct(): ", "E3D V6 Fan Duct"));
            rotate([90, 0, 0])
                color("SkyBlue")
                    import("../stlimport/E3D_V6_6_Duct.stl");
            translate([-20, 0, 15])
                rotate([0, 90, 0]) {
                    fan(fan_type);
                    vflip()
                        for (i = [[-1, 1, 0], [1, -1, 0]])
                            translate(i * fan_hole_pitch(fan_type) + [0, 0, fan_depth(fan_type) / 2]) {
                                not_on_bom()
                                    boltM3Panhead(16);
                                //vitamin(str(": M3 self tapping screw x 16mm"));
                            }
                }
        }
    translate_z(3)
        rotate(180)
            e3d_hot_end(E3Dv6, filament=1.75, naked=true, bowden=false);
}

module fanDuctHolePositions(z=0) {
    for (x = [-1, 27])
        translate([x, z, -3])
            children();
}

module blowerTranslate(xCarriageType, grooveMountSize, hotendOffset, blower_type, z=0) {
    isMGN9C = xCarriageType[0] == "MGN9C";
    translate([ hotendOffset.x - grooveMountSize.x + z,
                xCarriageBackOffsetY(xCarriageType) + blower_length(blower_type) + (isMGN9C ? 0.5 : 2),
                -blower_size(blower_type).x - grooveMountSize.z/2 + (isMGN9C ? 0 : 3)])
            rotate([90, 0, -90])
                children();
}

module partCoolingFan(xCarriageType, grooveMountSize, hotendOffset, blower_type) {
    blowerTranslate(xCarriageType, grooveMountSize, hotendOffset, blower_type) {
        blower(blower_type);
        blower_hole_positions(blower_type)
            translate_z(blower_lug(blower_type))
                boltM2Caphead(6);
    }
}

module hotEndPartCoolingFan(xCarriageType, grooveMountSize, hotendOffset, blower_type, left=true) {
    hotEndHolderAlign(hotendOffset, left)
        if (blower_size(blower_type).x < 40)
            partCoolingFan(xCarriageType, grooveMountSize, hotendOffset, blower_type);
    if (!exploded())
        mirror([left ? 0 : 1, 0, 0])
            translate([hotendOffset.x - grooveMountSize.x + 1.5, hotendOffset.y - blower_size(blower_type).y/2 + 2, hotendOffset.z + 1])
                rotate([90, 90, -90])
                    cable_tie(cable_r=3, thickness=1);
}

module grooveMountCutout(length) {
    tolerance = 1/8;
    neckLength = 6 - tolerance;
    innerRadius = 6;
    outerRadius = 8;
    chamfer = 0.5;
    endLength = (length - neckLength)/2;

    rotate([90, 0, 0])
        for (m = [0, 1])
            mirror([0, 0, m]) {
                translate_z(-neckLength/2 - eps)
                    poly_cylinder(r=innerRadius, h = neckLength + 2*eps);
                translate_z(neckLength/2 - chamfer)
                    cylinder(r1 = innerRadius, r2 = innerRadius + chamfer, h = chamfer + eps);
                translate_z(neckLength/2)
                    poly_cylinder(r=outerRadius, h = endLength);
                translate_z(length/2 - chamfer)
                    cylinder(r1 = outerRadius, r2 = outerRadius + chamfer, h=chamfer + eps);
            }
}

function grooveMountClampStrainReliefOffset() = 15;
function hotendStrainReliefClampHoleSpacing() = 12;

module grooveMountClamp(size, hotend_type=0, countersunk=true, strainRelief=false) {
    fillet = 1.5;
    supportSize = [20, grooveMountClampStrainReliefOffset() + 5, 6];

    difference() {
        union() {
            translate([-size.x/2 - grooveMountClampOffsetX()/2 + 1, -size.y/2, -size.z])
                rounded_cube_xy(size, fillet);
            if (strainRelief)
                translate([-supportSize.x/2, 0, -size.z]) {
                    rounded_cube_xy(supportSize, fillet);
                    translate([0, size.y/2, 0])
                        rotate(90)
                            fillet(2, supportSize.z);
                    translate([supportSize.x, size.y/2, 0])
                        fillet(2, supportSize.z);
                }
        }
        translate([grooveMountOffsetX(hotend_type), 0, 0])
            grooveMountCutout(size.y);
        for (x = grooveMountHoleOffsets)
            translate([x, 0, -size.z])
                if (countersunk)
                    boltPolyholeM3Countersunk(size.z);
                else
                    boltHoleM3(size.z, twist=4);
        if (strainRelief)
            for (x = [hotendStrainReliefClampHoleSpacing()/2, -hotendStrainReliefClampHoleSpacing()/2])
                translate([x, grooveMountClampStrainReliefOffset(), -size.z])
                    boltHoleM3Tap(6);
    }
}

module grooveMountClampHardware(grooveMountClampSize, countersunk=false) {
    for (x = grooveMountHoleOffsets)
        translate([x, 0, -grooveMountClampSize.z])
            vflip()
                if (countersunk)
                    boltM3Countersunk(25);
                else
                    boltM3Buttonhead(25);
}
