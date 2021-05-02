include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/vitamins/e3d.scad>
include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/hot_ends.scad>
include <NopSCADlib/vitamins/rails.scad>
use <NopSCADlib/vitamins/wire.scad>

use <../utils/PrintheadOffsets.scad>
use <../utils/ziptieCutout.scad>

use <../vitamins/bolts.scad>

use <X_Carriage.scad>


function blower_size(type) = [blower_length(type), blower_width(type), blower_depth(type)];

function hotendOffset(xCarriageType, hotend_type=0) = printHeadHotendOffset(hotend_type) + [-xCarriageBackSize(xCarriageType).x/2, xCarriageBackOffsetY(xCarriageType), 0];
function hotendClampOffset(xCarriageType, hotend_type=0) =  [hotendOffset(xCarriageType, hotend_type).x, 18+xCarriageBackOffsetY(xCarriageType)+grooveMountOffsetX(hotend_type), hotendOffset(xCarriageType, hotend_type).z];
grooveMountHoleOffsets = [13.5, -12];
grooveMountFillet = 1;
function grooveMountSize(xCarriageType, hotend_type, blower_type) = [hotendOffset(xCarriageType, hotend_type).x + xCarriageBackSize(xCarriageType).x/2, blower_size(blower_type).x+6, 12];
function grooveMountOffsetX(hotend_type) = hotend_type == 0 ? 0 : 4;
grooveMountClampOffsetX = 0.5;
function grooveMountClampSize(xCarriageType, hotend_type, blower_type) = [grooveMountSize(xCarriageType, hotend_type, blower_type).y - 2*grooveMountFillet - grooveMountClampOffsetX, 12, 17];


module hotEndHolder(xCarriageType, hotend_type, blower_type) {
    fillet = 1.5;
    offsetY = 0; // to avoid clashing with fan
    hotendOffset = hotendOffset(xCarriageType, hotend_type);
    grooveMountSize = grooveMountSize(xCarriageType, hotend_type, blower_type);
    blowerMountSize = [3, grooveMountSize.y, blower_size(blower_type).x + 9];

    difference() {
        union() {
            translate([-xCarriageBackSize(xCarriageType).x/2, 3+carriage_size(xCarriageType).y/2, hotendOffset.z - grooveMountSize.z/2]) {
                translate([0, -fillet, 0])
                    rounded_cube_yz(grooveMountSize + [0, fillet, 0], fillet);
                translate([0, 2, 0]) {
                    translate_z(grooveMountSize.z)
                        rotate([90, 0, 90])
                            fillet(1.5, grooveMountSize.x);
                    rotate([0, 90, 0])
                        fillet(1.5, grooveMountSize.x);
                }
                blowerMountFillet = 1.5;
                if (blower_size(blower_type).x < 40) {
                    if (hotend_type == 0)
                        translate_z(-30)
                            rounded_cube_yz([grooveMountSize.x - 7, grooveMountSize.y, 2], 0.75);
                    translate_z(-blowerMountSize.z + 2*blowerMountFillet) {
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
        translate([-xCarriageBackSize(xCarriageType).x/2, hotendOffset.y - blower_size(blower_type).y/2 + 2, hotendOffset.z])
            rotate([90, 0, -90])
                zipTieFullCutout(10);
        // holes for the strain relief clamp
        /*translate([hotendOffset.x - grooveMountSize.x, xCarriageBackSize(xCarriageType()).x/2 - 2*fillet, hotendOffset.z - grooveMountSize.z/2])
            for (x = [4, 14])
                translate([x, grooveMountSize.y, grooveMountSize.z/2])
                    rotate([90, 90, 0])
                        boltHoleM3Tap(8, horizontal=true, chamfer_both_ends=false);*/
        // bolt holes for blower
        blowerTranslate(xCarriageType, hotend_type, blower_type, blowerMountSize.x) {
            blower_hole_positions(blower_type)
                boltHoleM2Tap(blowerMountSize.x);
            rotate([-90, 0, 0])
                fanDuctHolePositions()
                    rotate([90, 0, 0])
                        boltHoleM2Tap(blowerMountSize.x);
        }

        translate(hotendOffset) {
            translate_z(-37)
                cylinder(r=11.5, h=4);
            rotate([-90, 0, 0])
                grooveMountCutout(grooveMountSize.z);
            for (y = grooveMountHoleOffsets)
                translate([0, y - 1.5 + grooveMountOffsetX(hotend_type), 0])
                    rotate([0, -90, 0])
                        boltHoleM3Tap(10);
        }
    }
}

module hotEndPartCoolingFan(xCarriageType, hotend_type, blower_type) {
    hotendOffset = hotendOffset(xCarriageType, hotend_type);
    grooveMountSize = grooveMountSize(xCarriageType, hotend_type, blower_type);

    if (blower_size(blower_type).x < 40)
        partCoolingFan(xCarriageType, hotend_type, blower_type);
    if (!exploded())
        translate([hotendOffset.x - grooveMountSize.x + 1.5, hotendOffset.y - blower_size(blower_type).y/2 + 2, hotendOffset.z])
            rotate([90, 90, -90])
                cable_tie(cable_r=3, thickness=1);
}


module E3Dv6plusFan() {
    fan_type = fan30x10;
    translate_z(-36)
        rotate(180) {
            vitamin(str("E3D_V6_Fan_Duct(): ", "E3D V6 Fan Duct"));
            rotate([90, 0, 0])
                color("skyblue")
                    import("../stlimport/E3D_V6_6_Duct.stl");
            translate([-20, 0, 15])
                rotate([0, 90, 0]) {
                    fan(fan_type);
                    vflip()
                        for (i = [[-1, 1, 0], [1, -1, 0]])
                            translate(i * fan_hole_pitch(fan_type) + [0, 0, fan_depth(fan_type) / 2]) {
                                not_on_bom()
                                    boltM3Panhead(16);
                                vitamin(str(": M3 self tapping screw x 16mm"));
                            }
                }
        }
    translate_z(3)
        rotate(180)
            hot_end(E3Dv6, filament=1.75, naked=true, bowden=false);
}

module fanDuctHolePositions(z=0) {
    for (x = [-1, 27])
        translate([x, z, -3])
            children();
}

module blowerTranslate(xCarriageType, hotend_type, blower_type, z=0) {
    grooveMountSize = grooveMountSize(xCarriageType, hotend_type, blower_type);
    hotendOffset = hotendOffset(xCarriageType, hotend_type);

    translate([-grooveMountSize.x + z, blower_length(blower_type) - 16 + grooveMountOffsetX(hotend_type), -blower_size(blower_type).x - grooveMountClampSize(xCarriageType, hotend_type, blower_type).y/2])
        translate([hotendOffset.x, xCarriageBackOffsetY(xCarriageType) + 17, hotendOffset.z])
            rotate([90, 0, -90])
                children();
}

module partCoolingFan(xCarriageType, hotend_type, blower_type) {
    blowerTranslate(xCarriageType, hotend_type, blower_type) {
        blower(blower_type);
        blower_hole_positions(blower_type)
            translate_z(blower_lug(blower_type))
                boltM2Caphead(6);
    }
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
                    poly_cylinder(r = innerRadius, h = neckLength+2*eps);
                translate_z(neckLength/2 - chamfer)
                    cylinder(r1 = innerRadius, r2 = innerRadius + chamfer, h = chamfer + eps);
                translate_z(neckLength/2)
                    poly_cylinder(r = outerRadius, h = endLength);
                translate_z(length/2-chamfer)
                    cylinder(r1 = outerRadius, r2 = outerRadius + chamfer, h=chamfer + eps);
            }
}

function grooveMountClampStrainReliefOffset() = 7;
function hotendStrainReliefClampHoleSpacing() = 12;

module grooveMountClamp(xCarriageType, hotend_type, blower_type) {
    size = grooveMountClampSize(xCarriageType, hotend_type, blower_type);
    //hotendOffset = hotendOffset(xCarriageType, hotend_type) - [xCarriageBackSize(xCarriageType).x/2, 0, 0];
    fillet = 1.5;
    supportSize = [20, 12, 8];

    difference() {
        union() {
            translate([-size.x/2 - grooveMountClampOffsetX/2 + 1, -size.y/2, -size.z])
                rounded_cube_xy(size, fillet);
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
                boltHoleM3(size.z, twist=3);
        for (x = [hotendStrainReliefClampHoleSpacing()/2, -hotendStrainReliefClampHoleSpacing()/2])
            translate([x, grooveMountClampStrainReliefOffset(), -size.z])
                boltHoleM3Tap(6);
    }
}

module grooveMountClampHardware(xCarriageType, hotend_type, blower_type) {
    size = grooveMountClampSize(xCarriageType, hotend_type, blower_type);

    for (x = grooveMountHoleOffsets)
        translate([x, 0, -size.z])
            vflip()
                boltM3Buttonhead(25);
}
