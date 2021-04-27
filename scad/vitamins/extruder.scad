include <NopSCADlib/core.scad>

use <NopSCADlib/utils/fillet.scad>
use <NopSCADlib/utils/tube.scad>
use <NopSCADlib/vitamins/e3d.scad>
include <NopSCADlib/vitamins/pillar.scad>
include <NopSCADlib/vitamins/pin_headers.scad>
include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/vitamins/springs.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <CorkDamper.scad>

extruder_spring  = ["spring", 8, 0.9, 21, 10, 1, false, 0, "silver"];
extruder_pulley  = ["pulley", "EP", 16, 9.5, GT2x6, 3.5, 8, 9.5, 5, 8, 0.5, 0, 0, false, 0];

function extruderBowdenOffset() = [18, 4.5, 30];
function extruderBaseSize() = [42, 42, 4];
function extruderFilamentOffset() = [extruderBowdenOffset().y, extruderBaseSize().y / 2, extruderBowdenOffset().x];

module Extruder_MK10_Dual_Pulley(NEMA_type = NEMA17, motorOffsetZ = 3, motorRotate = 180, corkDamperThickness = 0, color = "crimson") {
    vitamin(str("Extruder_MK10_Dual_Pulley() : MK10 Dual Pulley Extruder"));

    baseSize = extruderBaseSize();

    motorholeOffset = NEMA_hole_pitch(NEMA17);
    bowdenOffset = extruderFilamentOffset();
    fenceOffset = [0, baseSize.y / 2 - 15, baseSize.z];
    fenceSize = [baseSize.x, 5, 12];
    springOffset = [-12, -baseSize.y/2 + 10 , 5 + baseSize.z];
    topSizeZ = fenceSize.z + 8;
    armOffsetZ = 0.25;
    pulleyOffset = [bowdenOffset.x*2, 0, baseSize.z + armOffsetZ + 3];

    module cutCube(size, tSize) {
        cube([size.x, size.y, size.z - tSize]);
        translate([tSize, 0, 0])
            cube([size.x-2*tSize, size.y, size.z]);
        translate([tSize, 0, size.z - tSize])
            rotate([90, 0, 180])
                right_triangle(tSize, tSize, size.y, center=false);
        translate([size.x-tSize, size.y, size.z-tSize])
            rotate([90, 0, 0])
                right_triangle(tSize, tSize, size.y, center=false);
    }

    module fence(size) {
        translate([-size.x/2, 0, 0])
            color(color)
                difference() {
                    feedFillet = 3.5;
                    feedWidth = 1.5;
                    union() {
                        cutCube(size, 5);
                        translate([size.x/2, 0, 0]) {
                            cubeSize = [12, baseSize.y/2 - fenceOffset.y, topSizeZ];
                            translate([bowdenOffset.x - cubeSize.x/2, 0, 0]) {
                                difference() {
                                    cube(cubeSize);
                                    translate([0, 0, cubeSize.z])
                                        rotate([-90, 0, 0])
                                            fillet(1, cubeSize.y);
                                    translate([cubeSize.x, 0, cubeSize.z])
                                        rotate([-90, 90, 0])
                                            fillet(1, cubeSize.y);
                                }
                                translate([0, size.y, 0])
                                    rotate(90)
                                        fillet(4, size.z);
                                translate([12, size.y, 0])
                                    rotate(0)
                                        fillet(4, size.z);
                            }
                            translate([bowdenOffset.x - feedWidth/2, 0, size.z]) {
                                rotate(180)
                                    fillet(feedFillet, topSizeZ - size.z);
                                translate([feedWidth, 0, 0])
                                    rotate(270)
                                        fillet(feedFillet, topSizeZ - size.z);
                                translate([0, -feedFillet, 0])
                                    cube([feedWidth, feedFillet, topSizeZ - size.z]);
                            }
                        }
                    }
                    holeLength = baseSize.y/2 - fenceOffset.y + 2*eps;
                    translate([size.x / 2 + bowdenOffset.x, 0, bowdenOffset.z - baseSize.z]) {
                        translate([0, baseSize.y/2 - fenceOffset.y - 6, 0])
                        rotate([-90, 0, 0]) {
                            cylinder(h = 6 + eps, d = 6);
                        }
                       translate([0, -feedFillet - eps, 0]) {
                            rotate([-90, 0, 0])
                                cylinder(h = feedFillet + holeLength, d = 3);
                            translate([-1.5, 0, -2])
                                cube([3, 2, 2]);
                       }
                    }
                    translate([size.x/2 + springOffset.x, -eps, springOffset.z - baseSize.z])
                        rotate([-90, 0, 0])
                            cylinder(r = M4_tap_radius, h = size.y + 2*eps);

                }
            translate([springOffset.x, size.y, springOffset.z - baseSize.z])
                rotate([-90, 0, 0])
                    screw(M4_dome_screw, 12);
    } // fence

    module arm() {
        module bushing() {
            color(color) {
                tube(5/2, M3_clearance_radius, 15.5, center = false);
                translate_z(14.5)
                    tube(8/2, M3_clearance_radius, 1, center = false);
                translate_z(14.5)
                    tube(8/2, 3, 4, center = false);
            }
            translate_z(15.5)
                screw(M3_cap_screw, 25);
        }

        module rounded_triangle(sizeZ) {
            r = 3;
            translate([21 - r, r, 0])
                linear_extrude(sizeZ)
                    hull() {
                        circle(r=r);
                    translate([r - 1.5, 4, 0])
                        circle(r=1.5);
                    translate([-18, 0, 0])
                        circle(r=r);
                    translate([-4.5 - bowdenOffset.x, 19.5, 0])
                        circle(r=2.5);
                    }
        }


        translate([0, -baseSize.y / 2, 0]) {
            color(color)
                difference() {
                    translate_z(baseSize.z + armOffsetZ)
                        union() {
                            translate([-56 + baseSize.x/2, 2,0]) {
                                size = [26, 8, 12];
                                difference() {
                                    cube(size);
                                    translate_z(-eps)
                                        fillet(3, size.z + 2*eps);
                                    translate([0, size.y, -eps])
                                        rotate(270)
                                            fillet(3, size.z+2*eps);
                                }
                                translate([size.x, size.y - 1, 0])
                                    right_triangle(3, 1, 12, center=false);

                            }
                            cubeSize = [34, 9, 12];
                            translate([-cubeSize.x + baseSize.x/2, 0, 0]) {
                                rounded_cube_xy(cubeSize, 3);
                                translate([0, 2, 0])
                                    rotate(180)
                                        right_triangle(10, 2, 12, center=false);
                                cube([3, 2, 12]);
                            }
                            rounded_triangle(3);
                            translate_z(20 - 9)
                                rounded_triangle(9);
                        }
                translate([0, 12, baseSize.z + armOffsetZ + 20 - 9 - eps])
                    cube([20, 16, 6]);
                translate([bowdenOffset.x, -eps, bowdenOffset.z])
                    rotate([-90, 0, 0])
                        cylinder(d=3, h=15 + 2*eps);
                translate([springOffset.x, 5, springOffset.z])
                    rotate([-90, 0, 0])
                        cylinder(r=M3_tap_radius, h=5);
                translate([motorholeOffset / 2, 6, baseSize.z]) {
                    cylinder(d=5, h=15.5);
                    translate_z(15.5)
                        cylinder(d=8.5, h=5);
                }
                translate(pulleyOffset + [0, baseSize.y / 2, -20 - eps])
                    cylinder(r=M3_tap_radius, h=20 + 2*eps);
            }
        }
        translate([0, -baseSize.y / 2 + 5, 0]) {
            translate([springOffset.x, 8, springOffset.z])
                rotate([-90, 0, 0])
                    screw(M3_dome_screw, 10);
            translate([motorholeOffset / 2, 1, baseSize.z])
                bushing();
        }
        translate(pulleyOffset) {
            translate_z(pulley_height(extruder_pulley))
                vflip()
                    rotate(180/16)
                        pulley(extruder_pulley);
            translate_z(17)
                screw(M3_cap_screw, 20);
        }
    } // arm

    explode(30, false) not_on_bom() {
        color(color)
            difference() {
                linear_extrude(baseSize.z, convexity=2) {
                    difference() {
                        rounded_square([baseSize.x, baseSize.y], 3);
                        NEMA_screw_positions(NEMA17)
                            circle(r = M3_clearance_radius);
                        circle(r = NEMA_boss_radius(NEMA17));
                    }
                }
                translate([-motorholeOffset / 2, -motorholeOffset / 2, baseSize.z])
                    screw_countersink(M3_cs_cap_screw);
            }

        translate(fenceOffset)
            fence(fenceSize);

        arm();

        translate(bowdenOffset)
            rotate([-90, 0, 0])
                bowden_connector();

        translate(springOffset)
            rotate([-90, 0, 0])
                comp_spring(extruder_spring, fenceOffset.y - springOffset.y);

        translate_z(baseSize.z) {
            for (i = [ [-1, 1, 0], [1, 1, 0] ])
                translate(i * motorholeOffset / 2)
                    screw(M3_dome_screw, 10);
            translate([-motorholeOffset / 2, -motorholeOffset / 2, 0])
                screw(M3_cs_cap_screw, 10);
        }

    }

    explode(-100, true)
        if (NEMA_type) {
            translate_z(-corkDamperThickness) {
                if (corkDamperThickness)
                    explode(40)
                        corkDamper(NEMA_type, corkDamperThickness);
                translate_z(-motorOffsetZ)
                    rotate(motorRotate)
                        NEMA(NEMA_type, jst_connector = true);
            }
            translate_z(pulley_height(extruder_pulley) + 7)
                vflip()
                    not_on_bom()
                        pulley(extruder_pulley);
        }
}
