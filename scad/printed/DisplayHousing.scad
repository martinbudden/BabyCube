//include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>
use <NopSCADlib/utils/tube.scad>
include <NopSCADlib/vitamins/displays.scad>
include <NopSCADlib/vitamins/pcbs.scad>

use <../vitamins/bolts.scad>


sideThickness = 8;

function componentPosition(display_type, name) = pcb_component_position(display_pcb(display_type), name);
module componentPosition(display_type, name) {
    if (!is_undef(componentPosition(display_type, name)))
        translate(componentPosition(display_type, name))
            children();
}

function apertureLayerHeight() = 1;
function display_size(type) = [display_width(type), display_height(type), display_thickness(type)];
function displayHousingSize(display_type) = let(pcbSize = pcb_size(display_pcb(display_type))) [ceil(pcbSize.x) + 2*sideThickness, ceil(pcbSize.y) + 2*sideThickness, display_thickness(display_type)];
function displayHousingInnerWidth(display_type) = displayHousingSize(display_type).x - 12;
function useCounterbore() = sideThickness >= 8;


module displayHousingLocate(displayHousingSize, angle, sideSizeZ=10) {
    translate([0, -displayHousingSize.y/2*cos(angle), displayHousingSize.y/2*sin(angle)])
        rotate([180 - angle, 0, 180])
            translate_z(-displayHousingSize.z - sideSizeZ)
                children();
}

module displayHousingHolePositions(display_type, z=0) {
    assert(is_list(display_type));

    size = displayHousingSize(display_type);
    offset = sideThickness < 8 ? 4 : 5;
    for (x = [offset, size.x - offset],
        y = [offset, size.y -offset])
        translate([x - size.x/2, y - size.y/2, z])
            children();
}

module displayHousingBoltPositions(display_type, z=0) {
    displayHousingHolePositions(display_type, z - apertureLayerHeight() + (useCounterbore() ? screw_head_height(M3_cap_screw) : 0))
        children();
}

module knob(d, h) {
    // knob
    ringThickness = 1;
    color(grey(20)) {
        cylinder(d = d-ringThickness, h = h);
        cylinder(d = d, h = h-ringThickness);
    }
    color(silver) translate_z(h-ringThickness) {
        tube(or = d/2, ir = (d-ringThickness)/2, h = ringThickness, center = false);
        rotate(45) {
            markOffset = 6;
            translate([markOffset, -0.5, 0])
                cube([d/2 - markOffset-ringThickness/2, 1, ringThickness + eps]);
            translate([markOffset, 0, 0])
                cylinder(d = 1, h = ringThickness + eps);
        }
    }
}

module displayHousing(display_type, displayBracketBackThickness, sideSizeZ=10) {
    size = displayHousingSize(display_type);

    fillet = 2;
    color("SkyBlue")
    render_if(useCounterbore())
    difference() {
        displayHousingBase(display_type, fillet);
        if (useCounterbore())
            displayHousingHolePositions(display_type, -apertureLayerHeight())
                boltHoleM3HangingCounterbore(sideThickness + apertureLayerHeight() + displayBracketBackThickness, boltHeadTolerance=0.2);
        pcb_screw_positions(display_pcb(display_type))
            translate_z(0.5) // 0.5 above top layer
                boltHoleM3Tap(size.z);
    }
    displayHousingSides(display_type, sideSizeZ, fillet);
}

module displayHousingHardware(display_type) {
    pcb_offset = display_pcb_offset(display_type);

    explode(40)
        translate([-pcb_offset.x, -pcb_offset.y, -display_touch_screen(display_type)[1].z])
            display(display_type);
    explode(-20)
        translate_z(-4.5) {
            componentPosition(display_type, "-potentiometer")
                vflip()
                    knob(d=18, h=10);
            // check if there is a daughter PCB which has the potentiometer
            componentPosition(display_type, "pcb")
                translate(pcb_component_position(pcb_component(display_pcb(display_type), "pcb", 0)[5], "-potentiometer"))
                    vflip()
                        knob(d=18, h=10);
        }
}

module displayHousingFrontCutouts(display_type, cutoutComponents=true) {
    display_size = display_size(display_type);
    fillet = 1;

    translate([-display_pcb_offset(display_type).x, -display_pcb_offset(display_type).y]) {
        rounded_square([display_size.x + fillet, display_size.y + fillet], fillet, center = true);
        rb = display_ribbon(display_type);
        if(rb) {
            rbSize = [rb[1].x - rb[0].x, rb[1].y - rb[0].y];
            translate([-(display_size.x + fillet)/2 - rbSize.x, rb[0].y - fillet/2])
                rounded_square([rbSize.x + 2*fillet, rbSize.y + fillet], fillet, center = false);
        }
    }

    displayHousingHolePositions(display_type)
        poly_circle(r = M3_clearance_radius);

    if (cutoutComponents) {
        componentPosition(display_type, "-button_6mm")
            rounded_square([7, 7], 1, center = true);
        componentPosition(display_type, "-buzzer")
            poly_circle(r = 5.5);
        componentPosition(display_type, "buzzer")
            rounded_square([12, 4], 1, center = true);
        componentPosition(display_type, "-potentiometer")
            rounded_square([13, 13], 1, center = true);
        componentPosition(display_type, "pcb")
            translate(pcb_component_position(pcb_component(display_pcb(display_type), "pcb", 0)[5], "-potentiometer"))
                rounded_square([30, 15], 1, center = true);
    }
}

module displayHousingBase(display_type, fillet=2, testLayer=0) {
    size = displayHousingSize(display_type);
    totalHeight = display_thickness(display_type);

    if (testLayer != 0) {
        echo(displayHousingSize=size);
        echo(pcbSize = pcb_size(display_pcb(display_type)));
        da = display_aperture(display_type);
        echo(da = da);
        echo(db = [-da[0].x + da[1].x, -da[0].y+da[1].y]);
    }
    baseLayerHeight = 0.5;
    solderLayerHeight = 2;

    module controlCutouts(display_type) {
        componentPosition(display_type, "-button_6mm")
            poly_circle(r = 2.5);
        componentPosition(display_type, "-buzzer")
            circle(r = 1.5);
        componentPosition(display_type, "-potentiometer")
            rounded_square([13, 13], 1, center = true);
        componentPosition(display_type, "pcb")
            translate(pcb_component_position(pcb_component(display_pcb(display_type), "pcb", 0)[5], "-potentiometer"))
                circle(r = 4);
    }

    if (testLayer == 0 || testLayer == 1) color("SkyBlue")
    translate_z(-apertureLayerHeight())
        linear_extrude(apertureLayerHeight())
            difference() {
                rounded_square([size.x, size.y], fillet, center = true);

                aperture = display_aperture(display_type);
                pcbOffset = display_pcb_offset(display_type);
                apertureSize = [aperture[1].x - aperture[0].x + fillet, aperture[1].y - aperture[0].y + fillet];
                translate([-pcbOffset.x + aperture[0].x - fillet/2, -pcbOffset.y + aperture[0].y - fillet/2])
                    rounded_square(apertureSize, fillet, center = false);
                displayHousingHolePositions(display_type)
                    poly_circle(r = M3_clearance_radius);
                controlCutouts(display_type);
            }

    if (testLayer == 0 || testLayer == 2) color("Red")
    linear_extrude(baseLayerHeight)
        difference() {
            rounded_square([size.x, size.y], fillet, center = true);
            displayHousingFrontCutouts(display_type, cutoutComponents = false);
            controlCutouts(display_type);
        }

    if (testLayer == 0 || testLayer == 3) color("Blue")
    translate_z(baseLayerHeight)
        linear_extrude(totalHeight - solderLayerHeight - baseLayerHeight)
            difference() {
                rounded_square([size.x, size.y], fillet, center = true);
                displayHousingFrontCutouts(display_type);
            }
    if (testLayer == 0 || testLayer == 4) color("Yellow")
    translate_z(totalHeight - solderLayerHeight)
        linear_extrude(solderLayerHeight)
            difference() {
                rounded_square([size.x, size.y], fillet, center = true);
                displayHousingFrontCutouts(display_type);
                // additional cutouts to allow room for the soldering on the board
                componentPosition(display_type, "-button_6mm")
                    rounded_square([8, 14], 1, center = true);
                componentPosition(display_type, "-buzzer")
                    rounded_square([2, 14], 0.5, center = true);
                offsetX = 1;
                componentPosition(display_type, "-potentiometer")
                    translate([offsetX, 0, 0]) {
                        rounded_square([17 + 2*offsetX, 16], 1, center = true);
                        translate([7.5, 8]) {
                            rotate(90)
                                fillet(2);
                            translate([0, -16])
                                rotate(180)
                                    fillet(2);
                            }
                        }
                    }
}

module displayHousingSides(display_type, sideSizeZ, fillet=2) {
    assert(is_list(display_type));

    size = displayHousingSize(display_type);
    pcbSize = pcb_size(display_pcb(display_type));

    uSDPos = pcb_component_position(display_pcb(display_type), "uSD");
    usb_APos = pcb_component_position(display_pcb(display_type), "usb_A");

    translate_z(display_thickness(display_type))
        render(convexity = 2) difference() {
            linear_extrude(sideSizeZ)
                difference() {
                    rounded_square([size.x, size.y], fillet, center = true);
                    rounded_square([pcbSize.x + fillet, pcbSize.y + fillet], fillet, center = true);
                    displayHousingHolePositions(display_type)
                        poly_circle(r = M3_clearance_radius);
                }

            // cutout for the SD card
            translate([0, uSDPos.y, sideSizeZ/2 + pcbSize.z]) {
                cutoutSize = [sideThickness + 2, 28, sideSizeZ];
                mirror([(uSDPos.x < 0 ? 0 : 1), 0, 0]) {
                    translate([-(pcbSize.x + cutoutSize.x)/2, 0, 0]) {
                        cube(cutoutSize, center=true);
                        if (uSDPos.x < 0) // cut out the sliver between the uSD and the USB
                            translate([0, -cutoutSize.y/2, 0])
                                cube([sideThickness + 2, 10, sideSizeZ], center = true);
                    }

                    translate([-size.x/2, -cutoutSize.y/2, 0]) {
                        rotate(-90)
                            fillet(1, sideSizeZ, center = true);
                        translate([sideThickness - 0.6, 0, 0])
                            rotate(180)
                                fillet(1, sideSizeZ, center = true);
                    }

                    translate([-size.x/2, cutoutSize.y/2, 0]) {
                        fillet(1, sideSizeZ, center = true);
                        translate([sideThickness - 0.6, 0, 0])
                            rotate(90)
                                fillet(1, sideSizeZ, center = true);
                    }
/*
                    translate([-sideThickness - pcbSize.x/2, -cutoutSize.y/2, 0])
                        rotate(-90)
                            fillet(1, sideSizeZ, center = true);
                    translate([-sideThickness - pcbSize.x + (size.x - fillet)/2, -cutoutSize.y/2, 0])
                        rotate(180)
                            fillet(1, sideSizeZ, center = true);

                    translate([-sideThickness - pcbSize.x/2, cutoutSize.y/2, 0])
                        rotate(0)
                            fillet(1, sideSizeZ, center = true);
                    translate([-sideThickness - pcbSize.x + (size.x - fillet)/2, cutoutSize.y/2, 0])
                        rotate(90)
                            fillet(1, sideSizeZ, center = true);
*/
                }
            }

            // cutout for USB
            translate([0, usb_APos.y, sideSizeZ/2 + pcbSize.z]) {
                cutoutSize = [sideThickness + 2, 22, sideSizeZ];
                translate([-(pcbSize.x + cutoutSize.x)/2, 0, 0])
                    cube(cutoutSize, center=true);

                translate([-size.x/2, -cutoutSize.y/2, 0]) {
                    rotate(-90)
                        fillet(1, sideSizeZ, center = true);
                    translate([sideThickness - 0.6, 0, 0])
                        rotate(180)
                            fillet(1, sideSizeZ, center = true);
                }

                translate([-size.x/2, cutoutSize.y/2, 0]) {
                    fillet(1, sideSizeZ, center = true);
                    translate([sideThickness - 0.6, 0, 0])
                        rotate(90)
                            fillet(1, sideSizeZ, center = true);
                }
/*
                translate([-sideThickness - pcbSize.x/2, -cutoutSize.y/2, 0])
                    rotate(-90)
                        fillet(1, sideSizeZ, center = true);
                translate([-sideThickness - pcbSize.x + (size.x - fillet)/2, -cutoutSize.y/2, 0])
                    rotate(180)
                        fillet(1, sideSizeZ, center = true);

                translate([-sideThickness - pcbSize.x/2, cutoutSize.y/2, 0])
                    rotate(0)
                        fillet(1, sideSizeZ, center = true);
                translate([-sideThickness - pcbSize.x + (size.x - fillet)/2, cutoutSize.y/2, 0])
                    rotate(90)
                        fillet(1, sideSizeZ, center = true);
*/
            }
        }
}

module displayBracketHolePositions(display_type, displayBracketBackThickness=5, angle=45) {
    assert(is_list(display_type));

    dhSize = displayHousingSize(display_type);

    triangleSize = [dhSize.y*sin(angle), dhSize.y*cos(angle), (dhSize.x - displayHousingInnerWidth(display_type))/2 + 2];

    for (x = [-dhSize.x/2 + triangleSize.z/2, dhSize.x/2 - triangleSize.z/2],
        z = [5, 38]) // lower the top bolt so it does not interfere with the display bolts
        translate([x, displayBracketBackThickness, z])
            rotate([90, 0, 0])
                children();
}

module displayBracketHolePositionsCNC(display_type, angle=45) {
    assert(is_list(display_type));

    dhSize = displayHousingSize(display_type);

    triangleSize = [dhSize.y*sin(angle), dhSize.y*cos(angle), (dhSize.x - displayHousingInnerWidth(display_type))/2 + 2];

    for (x = [-dhSize.x/2 + triangleSize.z/2, dhSize.x/2 - triangleSize.z/2],
        y = [5, 38]) // lower the top bolt so it does not interfere with the display bolts
        translate([x, y])
            children();
}

/*function displayHousingBracketBaseSize(display_type, angle) =
    let(dhSize = displayHousingSize(display_type),
        triangleSize = [dhSize.y*sin(angle), dhSize.y*cos(angle), (dhSize.x - displayHousingInnerWidth(display_type))/2 + 2])
    [dhSize.x, triangleSize.y + displayBracketBackThickness, 5];
*/

module displayHousingBracket(display_type, displayBracketBackThickness, angle, sideSizeZ=10, enclosed=false, legHeight=0) {
    assert(is_list(display_type));
    dhSize = displayHousingSize(display_type);
    fillet = legHeight == 0 ? 0 : 1;

    triangleSize = [dhSize.y*sin(angle), dhSize.y*cos(angle), (dhSize.x - displayHousingInnerWidth(display_type))/2 + 2];
    baseSize = [dhSize.x, triangleSize.y + displayBracketBackThickness, 5];
    backSize = [baseSize.x, displayBracketBackThickness, triangleSize.x];
    difference() {
        union() {
            translate([-baseSize.x/2, -triangleSize.y, -baseSize.z]) {
                translate_z(-legHeight)
                    rounded_cube_xz(baseSize, fillet);
                if (enclosed)
                    translate([0, baseSize.y - 5, baseSize.z])
                        cube([backSize.x, 5, backSize.z]);
                offsetY = 1.5;
                if (legHeight == 0) {
                    translate([0, offsetY/tan(angle), baseSize.z]) {
                        cube([baseSize.x, baseSize.y - offsetY, offsetY]);
                        rotate([90, -90, 90])
                            right_triangle(offsetY, offsetY/tan(angle), baseSize.x, center=false);
                    }
                } else {
                    for (x = [0, baseSize.x - triangleSize.z])
                        translate([x, 0, -legHeight + baseSize.z - 2*fillet])
                            cube([triangleSize.z, baseSize.y, legHeight + 2*fillet]);
                }
                cubeSize = [backSize.x, backSize.y, backSize.y/tan(angle)];
                translate([0, baseSize.y - backSize.y, backSize.z + baseSize.z - cubeSize.z]) {
                    //#cube([baseSize.x, baseSize.z, displayBracketBackThickness]);
                    cube(cubeSize);
                    offsetZ = offsetY*tan(angle);
                    translate([0, -offsetY, 0])
                        cube([cubeSize.x, offsetY, cubeSize.z - offsetZ]);
                    rotate([90, -90, 90])
                        right_triangle(cubeSize.z, cubeSize.z/tan(angle), cubeSize.x, center=false);
                }
            }
            for (x = [-dhSize.x/2 + triangleSize.z/2, dhSize.x/2 - triangleSize.z/2])
                translate([x, 0, 0])
                    rotate([0, -90, 180]) {
                        right_triangle(triangleSize.x, triangleSize.y, triangleSize.z);
                        cubeSize = [triangleSize.x, backSize.y, triangleSize.z];
                        translate([0, -cubeSize.y, -cubeSize.z/2])
                            cube(cubeSize);
                    }
        }
        // bolt holes for the display housing
        displayHousingLocate(dhSize, angle, sideSizeZ)
            displayHousingHolePositions(display_type)
                translate_z(dhSize.z + sideSizeZ)
                    boltHoleM3Tap(12);
        translate([-baseSize.x/2 - eps, 0, triangleSize.x + eps])
            rotate([angle-90, 0, 0])
                cube([baseSize.x + 2*eps, 2*displayBracketBackThickness, displayBracketBackThickness]);
        translate([-baseSize.x/2 - eps, -baseSize.y+baseSize.z*tan(angle)+displayBracketBackThickness + eps, -baseSize.z])
            rotate([angle, 0, 0]) {
                translate([0, -displayBracketBackThickness, -0*displayBracketBackThickness])
                    cube([baseSize.x + 2*eps, displayBracketBackThickness, 2*displayBracketBackThickness]);
                translate_z(-eps)
                    fillet(2, 2*displayBracketBackThickness + 2*eps);
                translate([baseSize.x + eps, 0, -eps])
                    rotate(90)
                        fillet(2, 2*displayBracketBackThickness + 2*eps);
            }
        translate([-baseSize.x/2, 0, triangleSize.x])
            rotate([angle - 180, 0, 0])
                translate_z(-eps)
                    fillet(2, 2*backSize.y*tan(angle));
        translate([baseSize.x/2, 0, triangleSize.x])
            rotate([angle - 180, 0, 0])
                rotate(90)
                    translate_z(-eps)
                        fillet(2, 2*backSize.y*tan(angle));
        translate([baseSize.x/2, backSize.y + eps, -baseSize.z])
            rotate([90, 270, 0])
                fillet(2, baseSize.y + 2*eps);
        translate([-baseSize.x/2, backSize.y + eps, -baseSize.z])
            rotate([90, 0, 0])
                fillet(2, baseSize.y + 2*eps);
    }
}
