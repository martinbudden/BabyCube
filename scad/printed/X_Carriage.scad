
//include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/core_xy.scad>
use <NopSCADlib/utils/fillet.scad>
use <NopSCADlib/utils/hanging_hole.scad>
include <NopSCADlib/vitamins/belts.scad>
include <NopSCADlib/vitamins/rails.scad>

use <../vitamins/bolts.scad>


_useInsertsForXCarriage = false;


fillet = 1;

topThickness = xCarriageTopThickness();
baseThickness = xCarriageBaseThickness();
beltHoleWidth = 18;
xCarriageFrontSize = [30, 4, 40.5];
function cutoutSize(beltWidth, xCarriageType) = [beltHoleWidth, xCarriageFrontSize.y + beltInsetFront(xCarriageType) + 2*eps, beltWidth + 2.5];
railCarriageGap = 0.5;

function beltTensionerSize(beltWidth) = [beltHoleWidth - 10, xCarriageFrontSize.y + beltInsetBack() - 1, beltWidth + 1.75];
function clampHoleSpacing(beltWidth) = beltWidth*2;
function tidyHoleSpacing(beltWidth) = 2*clampHoleSpacing(beltWidth) + 1;
function beltClampOffsetX() = 3;
// belt inset from side of rail carriage
function beltInsetFront(xCarriageType) = is_undef(xCarriageType) ? 5.5 : xCarriageType == MGN12H_carriage ? 6.5 : 5.5;
function beltInsetBack(xCarriageType) = is_undef(xCarriageType) ? 4.5 : xCarriageType == MGN12H_carriage ? 6.5 : 4.5;

function xCarriageTopThickness() = 8;
function xCarriageBaseThickness() = 8;
function xCarriageFrontSize(xCarriageType, beltWidth) =  [max(carriage_size(xCarriageType).x, xCarriageFrontSize.x), xCarriageFrontSize.y, xCarriageFrontSize.z + carriage_height(xCarriageType) + topThickness + (!is_undef(beltWidth) && beltWidth == 9 ? 4.5 : 0)]; //has the belt tensioners
function xCarriageBackSize(xCarriageType, beltWidth) = [xCarriageFrontSize(xCarriageType, beltWidth).x, 5, xCarriageFrontSize(xCarriageType, beltWidth).z];
function xCarriageFrontOffsetY(xCarriageType) = carriage_size(xCarriageType).y/2 + xCarriageFrontSize(xCarriageType).y + 2;
function xCarriageBackOffsetY(xCarriageType) = carriage_size(xCarriageType).y/2 + xCarriageBackSize(xCarriageType).y;
function xCarriageTopHolePositions(xCarriageType) = [4, xCarriageFrontSize(xCarriageType).x - 4];
function xCarriageBottomHolePositions(xCarriageType) = [xCarriageType == MGN9C_carriage? 4 : 10, xCarriageFrontSize(xCarriageType).x - 4];


module xCarriageTop(xCarriageType, reflected=false, strainRelief=false) {
    assert(is_list(xCarriageType));

    extraY = xCarriageFrontOffsetY(xCarriageType) - carriage_size(xCarriageType).y/2 - xCarriageFrontSize(xCarriageType).y;
    carriageSize = carriage_size(xCarriageType);
    carriageOffsetY = carriageSize.y/2;
    size =  [xCarriageBackSize(xCarriageType).x, extraY + carriageSize.y + xCarriageBackSize(xCarriageType).y, topThickness];

    difference() {
        translate([0, -extraY - carriageSize.y, 0]) {
            rounded_cube_yz(size, fillet);
            tabSize = [15, 5, 25];
            if (strainRelief)
                translate([reflected ? size.x - tabSize.x : 0, size.y - tabSize.y, size.z - 2*fillet])
                    difference() {
                        rounded_cube_yz(tabSize, fillet);
                        for (x = [tabSize.x/2 - 4, tabSize.x/2 + 4], z = [5+2, 15+2])
                            translate([x-1, -eps, z])
                                cube([2, tabSize.y + 2*eps, 4]);
                    }
        }
        // insert holes  to connect to the front
        for (x = xCarriageTopHolePositions(xCarriageType))
            translate([x, -extraY - carriageSize.y, size.z/2])
                rotate([-90, -90, 0])
                    boltHoleM3TapOrInsert(8, horizontal=true, rotate=(reflected ? 180 : 0), chamfer_both_ends=false);
        // bolt holes to connect to to the rail carriage
        translate([size.x/2, -carriageOffsetY, -carriage_height(xCarriageType)])
            carriage_hole_positions(xCarriageType)
                boltHoleM3(size.z, horizontal=true, rotate=(reflected ? 90 : -90));
    }
}

module xCarriageTopBolts(xCarriageType) {
    assert(is_list(xCarriageType));

    // depth of holes in MGN9 and MGN12 carriages is approx 5mm. so 4.5mm leaves room for error
    carriageHoleDepth = 4.5;

    translate_z(topThickness - carriage_height(xCarriageType))
        carriage_hole_positions(xCarriageType)
            boltM3Buttonhead(screw_shorter_than(topThickness + carriageHoleDepth));

    if (_useInsertsForXCarriage)
        for (x = xCarriageTopHolePositions(xCarriageType))
            translate([x, -carriage_size(xCarriageType).y, topThickness.z/2])
                rotate([90, 90, 0])
                    _threadedInsertM3();
}

module xCarriageBottom(xCarriageType) {
    assert(is_list(xCarriageType));

    extraY = xCarriageFrontOffsetY(xCarriageType) - carriage_size(xCarriageType).y/2 - xCarriageFrontSize(xCarriageType).y;
    size =  [xCarriageBackSize(xCarriageType).x, extraY + carriage_size(xCarriageType).y + xCarriageBackSize(xCarriageType).y - beltInsetFront(xCarriageType), baseThickness];
    translate([0, -size.y + xCarriageBackSize(xCarriageType).y, 0])
        difference() {
            rounded_cube_yz(size, fillet);

            // insert holes to connect to the front
            for (x = xCarriageBottomHolePositions(xCarriageType))
                translate([x, 0, size.z/2])
                    rotate([-90, -90, 0])
                        boltHoleM3TapOrInsert(14, horizontal=true, chamfer_both_ends=false);
        }
    /*if ($preview && _useInsertsForXCarriage) {
        for (x = xCarriageBottomHolePositions(xCarriageType))
            translate([x, -carriage_size(xCarriageType).y + beltInsetBack(xCarriageType), size.z/2])
                rotate([90, 90, 0])
                    _threadedInsertM3();
    }*/
}

module xCarriageBack(xCarriageType, beltWidth, beltOffsetZ, coreXYSeparationZ, toolheadHoles=false, reflected=false, strainRelief=false) {
    assert(is_list(xCarriageType));

    size = xCarriageBackSize(xCarriageType, beltWidth);

    // the back has clamps for the two belts and attaches to the hotend
    baseSize = [size.x, carriage_size(xCarriageType).y + size.y - 2*beltInsetBack(xCarriageType), baseThickness];
    topSize =  [size.x, carriage_size(xCarriageType).y + size.y - 2*beltInsetBack(xCarriageType) + xCarriageFrontSize(xCarriageType, beltWidth).y, topThickness];
    difference() {
        translate([-size.x/2, carriage_size(xCarriageType).y/2, 0])
            union() {
                translate([0, railCarriageGap, baseSize.z - size.z])
                    rounded_cube_yz([size.x, size.y - railCarriageGap, size.z - baseSize.z + 2*fillet], fillet);
                translate([0, railCarriageGap - beltInsetBack(xCarriageType), -size.z + baseThickness]) {
                    rectSize1 = [size.x, 4.5 + 2*fillet, size.z - railCarriageGap - topThickness - carriage_size(xCarriageType).z + carriage_clearance(xCarriageType)];
                    rectSize2 = [size.x, beltInsetBack(xCarriageType) + 2*fillet, size.z - railCarriageGap - topThickness - carriage_size(xCarriageType).z + carriage_clearance(xCarriageType) - 10];
                    translate([0, beltInsetBack(xCarriageType)-4.5, 0])
                        rounded_cube_yz(rectSize1, fillet);
                    rounded_cube_yz(rectSize2, fillet);
                    translate_z(baseThickness)
                        rotate([-90, -90, -90])
                            fillet(fillet, baseSize.x);
                }
                // top
                xCarriageTop(xCarriageType, reflected, strainRelief);
                // base
                translate_z(-size.z + topThickness)
                    xCarriageBottom(xCarriageType);
            } // end union
            translate([-size.x/2 - eps, carriage_size(xCarriageType).y/2 - beltInsetBack(undef) + xCarriageBackSize(xCarriageType, beltWidth).y, beltOffsetZ]) {
                for (z = [clampHoleSpacing(beltWidth)/2, -clampHoleSpacing(beltWidth)/2])
                    translate_z(z - coreXYSeparationZ/2)
                        rotate([90, 0, 90])
                            boltHoleM3TapOrInsert(10);
                translate([size.x + 2*eps, 0, ])
                    for (z = [clampHoleSpacing(beltWidth)/2, -clampHoleSpacing(beltWidth)/2])
                        translate_z(z + coreXYSeparationZ/2)
                            rotate([90, 0, -90])
                                boltHoleM3TapOrInsert(10);
            }
            if (toolheadHoles) {
                // using large carriage, so can support XChange toolhead
                translate([0, carriage_size(xCarriageType).y/2 + size.y + eps, topThickness - 20]) {
                    rotate([90, 0, 0])
                        translate_z(-carriage_height(MGN12H_carriage))
                            carriage_hole_positions(MGN12H_carriage)
                                rotate(-90)
                                    boltHoleM3TapOrInsert(size.y + beltInsetBack(xCarriageType));
                }
            }
    } // end difference

    /*if ($preview && _useInsertsForXCarriage) {
        translate([-0*size.x/2, carriage_size(xCarriageType).y/2 - beltInsetBack(xCarriageType) - eps, beltOffsetZ])
            for (z = [0, clampHoleSpacing, -clampHoleSpacing])
                translate_z(z)
                    rotate([90, 0, 0])
                        _threadedInsertM3();
    }*/
}

module xCarriageFront(xCarriageType, beltWidth, beltOffsetZ, coreXYSeparationZ) {
    // this has the belt tensioners
    assert(is_list(xCarriageType));

    size = xCarriageFrontSize(xCarriageType, beltWidth);
    cutoutSize = cutoutSize(beltWidth, xCarriageType);
    baseOffset = size.z - topThickness;

    translate([-size.x/2, -xCarriageFrontOffsetY(xCarriageType), 0]) {
        difference () {
            //translate_z(-size.z + topThickness)
            translate_z(-baseOffset)
            union() {
                rounded_cube_yz(size, fillet);
                insetHeight = size.z - railCarriageGap - topThickness - carriage_size(xCarriageType).z + carriage_clearance(xCarriageType);
                rounded_cube_yz([size.x, size.y + beltInsetFront(xCarriageType), insetHeight], fillet);
            } // end union

            cutoutOffsetX = 6;
            // cutouts for the belt tensioners
            translate([cutoutOffsetX, -eps, beltOffsetZ - cutoutSize.z/2 - coreXYSeparationZ/2])
                cube(cutoutSize);
            // part of this cutout also done by hanging hole
            translate([size.x - cutoutSize.x - cutoutOffsetX, -eps, beltOffsetZ - cutoutSize.z/2 + coreXYSeparationZ/2])
                cube(cutoutSize);
            // holes for the belt tightening bolts
            translate([0, (size.y + beltInsetFront(xCarriageType))/2, beltOffsetZ - coreXYSeparationZ/2]) {
                rotate([0, 90, 0])
                    boltHoleM3TapOrInsert(8);
                translate([size.x - cutoutSize.x - cutoutOffsetX, 0, coreXYSeparationZ])
                    rotate([0, 90, 0])
                        rotate(-45)
                            hanging_hole(cutoutSize.x, _useInsertsForXCarriage? insert_hole_radius(F1BM3) : M3_tap_radius, h=(size.x - cutoutSize.x)/2 + 1)
                                rotate(45)
                                    square([beltWidth + 1, cutoutSize.y + eps], center=true);
            }

            // holes for the belt clamps
            for (i = [ [beltClampOffsetX(), 0, -coreXYSeparationZ/2], [size.x - beltClampOffsetX(), 0, coreXYSeparationZ/2] ],
                 z = [clampHoleSpacing(beltWidth)/2, -clampHoleSpacing(beltWidth)/2])
                translate(i + [0, 0, z + beltOffsetZ])
                    rotate([-90, -90, 0])
                        boltHoleM3TapOrInsert(size.y + beltInsetFront(xCarriageType), horizontal=true, chamfer_both_ends=true);
            // holes for the belt tidy
            for (z = [-tidyHoleSpacing(beltWidth)/2, tidyHoleSpacing(beltWidth)/2])
                translate([size.x/2, 0, z + beltOffsetZ])
                    rotate([-90, -90, 0])
                        boltHoleM3TapOrInsert(size.y + beltInsetFront(xCarriageType), horizontal=true, chamfer_both_ends=true);
            // holes at the top to connect to the printhead
            for (x = xCarriageTopHolePositions(xCarriageType))
                translate([x, size.y, -baseOffset + size.z - topThickness/2])
                    rotate([90, 90, 0])
                        boltHoleM3(size.y, horizontal=true);
            // holes at the bottom to connect to the printhead
            for (x = xCarriageBottomHolePositions(xCarriageType))
                translate([x, size.y + beltInsetFront(xCarriageType), -baseOffset + baseThickness/2])
                    rotate([90, 90, 0])
                        boltHoleM3(size.y + beltInsetFront(xCarriageType), horizontal=true);
        } // end difference

        /*if ($preview && _useInsertsForXCarriage) {
            // side inserts for the belt tensioners
            translate([0, size.y/2, beltOffsetZ + coreXYSeparationZ/2])
                rotate([0, -90, 0])
                    _threadedInsertM3();
            translate([size.x, size.y/2, beltOffsetZ - coreXYSeparationZ/2])
                rotate([0, 90, 0])
                    _threadedInsertM3();
            // inserts for the belt clamps
            translate([0, 0, beltOffsetZ])
                for (i= [[beltClampOffsetX(), 0, coreXYSeparationZ/2], [size.x - beltClampOffsetX(), 0, -coreXYSeparationZ/2] ],
                     z= [clampHoleSpacing(beltWidth)/2, -clampHoleSpacing(beltWidth)/2])
                    translate(i + [0, 0, z])
                        rotate([90, 90, 0])
                            _threadedInsertM3();
        }*/
    }
}



module beltFragment(xCarriageType, beltType, color) {

    beltWidth = belt_width(beltType);
    beltThickness = belt_thickness(beltType);
    extraX = 9.5;
    extraY = 0.75;
    size = [beltTensionerSize(beltWidth).x + extraX, xCarriageFrontSize(xCarriageType).y + 2*beltThickness + beltInsetFront(xCarriageType) + extraY, beltWidth];
    color(color)
        translate([-extraX/2 - 1, extraY/2, -size.z/2])
            linear_extrude(size.z)
                difference() {
                    union() {
                        translate([size.x/2, 0])
                            circle(d=size.y);
                        square([size.x, size.y], center=true);
                    }
                    translate([size.x/2, 0])
                        circle(d=size.y - 2*beltThickness);
                    square([size.x + beltThickness, size.y - 2*beltThickness], center=true);
                }
}

module xCarriageBeltFragments(xCarriageType, beltType, beltOffsetZ, coreXYSeparationZ, upperBeltColor, lowerBeltColor) {
    assert(is_list(xCarriageType));
    beltWidth = belt_width(beltType);
    size = xCarriageFrontSize(xCarriageType, beltWidth);

    translate([-size.x/2, size.y/2 - xCarriageFrontOffsetY(xCarriageType) + beltInsetFront(xCarriageType)/2, beltOffsetZ - coreXYSeparationZ/2])
        translate([beltHoleWidth - 6, 0, 0])
            beltFragment(xCarriageType, beltType, lowerBeltColor);

    translate([size.x/2, size.y/2 - xCarriageFrontOffsetY(xCarriageType) + beltInsetFront(xCarriageType)/2, beltOffsetZ + coreXYSeparationZ/2])
        hflip()
            translate([beltHoleWidth - 6, 0, 0])
                beltFragment(xCarriageType, beltType, upperBeltColor);
}

module boltHoleM3TapOrInsert(length, useInsert = false, horizontal = false, rotate = 0, chamfer = 0.5, twist = undef, chamfer_both_ends = false) {
    if (useInsert)
        insert_hole(F1BM3, horizontal = horizontal);
    else
        boltHole(M3_tap_radius*2, length, horizontal, rotate, chamfer, twist, chamfer_both_ends = chamfer_both_ends);
}
