include <../vitamins/bolts.scad>

use <NopSCADlib/utils/core_xy.scad>
use <NopSCADlib/utils/fillet.scad>
use <NopSCADlib/utils/hanging_hole.scad>
include <NopSCADlib/vitamins/belts.scad>
include <NopSCADlib/vitamins/rails.scad>
use <NopSCADlib/vitamins/pcb.scad>

include <../vitamins/pcbs.scad>


_useInsertsForXCarriage = false;


fillet = 1;

topThickness = xCarriageTopThickness();
baseThickness = xCarriageBaseThickness();
railCarriageGap = 0.5;

function beltInsetBack(xCarriageType) = is_undef(xCarriageType) ? 4.5 : xCarriageType == MGN12H_carriage ? 6.5 : 4.5;

function xCarriageTopThickness() = 8;
function xCarriageBaseThickness() = 8;
xCarriageFrontOffsetExtraY = 2;
function xCarriageBeltSideOffsetY(xCarriageType, xCarriageFrontSizeY) = carriage_size(xCarriageType).y/2 + xCarriageFrontSizeY + xCarriageFrontOffsetExtraY;

function xCarriageHolePositions(sizeX, spacing) = [(sizeX - spacing)/2, (sizeX + spacing)/2];
function xCarriageExtraBackThickness(xCarriageType) = xCarriageType[0] == "MGN9C" ? 0 : 1;

module xCarriageTop(xCarriageType, xCarriageBackSize, holeSeparation, extraX=0, reflected=false, countersunk=4, topHoleOffset=0, holeOffset=0, accelerometerOffset=undef) {
    assert(is_list(xCarriageType));

    carriageSize = carriage_size(xCarriageType);
    carriageOffsetY = carriageSize.y/2;
    size =  [xCarriageBackSize.x + extraX, xCarriageBackSize.y + carriageSize.y/2 + railCarriageGap, topThickness];

    difference() {
        translate([0, xCarriageBackSize.y - size.y + railCarriageGap, 0])
            rounded_cube_yz(size, fillet);
        // bolt holes to connect to the belt side
        for (x = xCarriageHolePositions(size.x, holeSeparation))
        //for (x = xCarriageTopHolePositions(xCarriageType, holeOffset.x))
            translate([x + topHoleOffset, xCarriageBackSize.y - size.y + railCarriageGap, size.z/2 + holeOffset])
                rotate([-90, -90, 0])
                    boltHoleM3TapOrInsert(12, horizontal=true, rotate=(reflected ? 180 : 0), chamfer_both_ends=false);
        // bolt holes to connect to to the MGN carriage
        translate([size.x/2 + topHoleOffset, -carriageSize.y/2, -carriage_height(xCarriageType)]) {
            carriage_hole_positions(xCarriageType) {
                boltHoleM3(size.z, horizontal=true, rotate=(reflected ? 90 : -90));
                if (countersunk == 4) // cut the countersink
                    translate_z(size.z)
                        vflip()
                            boltHoleM3(size.z, horizontal=true, rotate=(reflected ? 90 : -90), chamfer=3.2, chamfer_both_ends=false);
            }
            if (countersunk == 1)
                translate([carriage_pitch_x(xCarriageType) / 2, -carriage_pitch_y(xCarriageType) / 2, size.z + carriage_height(xCarriageType)])
                    vflip()
                        boltHoleM3(size.z, horizontal=true, rotate=(reflected ? 90 : -90), chamfer=3.2, chamfer_both_ends=false);
        }
        // bolt holes for accelerometer
        if (is_list(accelerometerOffset))
            translate([size.x/2, -carriage_size(xCarriageType).y/2, 0] + accelerometerOffset)
                rotate(180)
                    pcb_hole_positions(ADXL345)
                        vflip()
                            boltHoleM3Tap(8, horizontal=true, rotate=(reflected ? -90 : 90), chamfer_both_ends=false);
    }
}

module xCarriageStrainRelief(xCarriageType, xCarriageBackSize, topThickness, reflected=false) {
    carriageSize = carriage_size(xCarriageType);
    carriageOffsetY = carriageSize.y/2;
    size =  [xCarriageBackSize.x, xCarriageBackSize.y + carriageSize.y/2, topThickness];
    tabSize = [15, xCarriageBackSize.y, 25]; // ensure room for bolt heads

    translate([reflected ? size.x - tabSize.x : 0, 0, size.z - 2*fillet])
        difference() {
            rounded_cube_yz(tabSize, fillet);
            for (x = [tabSize.x/2 - 4, tabSize.x/2 + 4], z = [5 + 2, 15 + 2])
                translate([x - 1, -eps, z])
                    cube([2, tabSize.y + 2*eps, 4]);
        }
}

module MGNCarriageHolePositions(xCarriageType, positions=undef) {
    x_pitch = carriage_pitch_x(xCarriageType);
    y_pitch = carriage_pitch_y(xCarriageType);

    positions = is_undef(positions) ? [ [-1, -1], [-1, 1], [1, -1], [1, 1] ] : positions;
    for(i = positions)
        if(i.x < 0 || x_pitch)
            translate([i.x * x_pitch / 2, i.y * y_pitch / 2, carriage_height(xCarriageType)])
                children();
}

module xCarriageTopBolts(xCarriageType, countersunk=true, positions=undef) {
    assert(is_list(xCarriageType));

    // depth of holes in MGN9 and MGN12 carriages is approx 5mm. so 4.5mm leaves room for error
    carriageHoleDepth = 4.5;

    translate_z(topThickness - carriage_height(xCarriageType) + eps)
        MGNCarriageHolePositions(xCarriageType, positions)
            bolt(countersunk ? M3_cs_cap_screw : M3_dome_screw, screw_shorter_than(topThickness + carriageHoleDepth));

    if (_useInsertsForXCarriage)
        for (x = xCarriageTopHolePositions(xCarriageType))
            translate([x, -carriage_size(xCarriageType).y, topThickness.z/2])
                rotate([90, 90, 0])
                    _threadedInsertM3();
}

module xCarriageBottom(xCarriageType, xCarriageBackSize, holeSeparation, reflected=false) {
    assert(is_list(xCarriageType));

    size =  [xCarriageBackSize.x, carriage_size(xCarriageType).z >= 13 ? 14.45 : 10, baseThickness];
    translate([0, -size.y + xCarriageBackSize.y, 0])
        difference() {
            rounded_cube_yz(size, fillet);
            // bolt holes to connect to the belt side
            for (x = xCarriageHolePositions(size.x, holeSeparation))
                translate([x, 0, size.z/2])
                    rotate([-90, -90, 0])
                        boltHoleM3TapOrInsert(xCarriageType[0] == false ? 14 : 12, horizontal=true, rotate=(reflected ? 180 : 0), chamfer_both_ends=false);
        }
}

module xCarriageBack(xCarriageType, size, extraX=0, holeSeparationTop, holeSeparationBottom, toolheadHoles=false, halfCarriage=false, reflected=false, strainRelief=false, countersunk=0, topHoleOffset=0, offsetT=0, accelerometerOffset=undef) {
    assert(is_list(xCarriageType));
    internalFillet = 1.5;
    carriageSize = carriage_size(xCarriageType);
    isMGN12 = carriageSize.z >= 13;

    baseSize = [size.x, carriageSize.y + size.y - 2*beltInsetBack(xCarriageType), baseThickness];
    difference() {
        translate([-size.x/2, carriageSize.y/2 + railCarriageGap, 0])
            union() {
                translate_z(baseSize.z - size.z)
                    rounded_cube_yz([size.x, size.y, size.z], fillet);
                // top
                if (strainRelief)
                    xCarriageStrainRelief(xCarriageType, size, topThickness, reflected);
                if (halfCarriage) {
                    translate([0, -railCarriageGap, 0])
                        xCarriageTop(xCarriageType, size, holeSeparationTop, extraX, reflected, countersunk, topHoleOffset, offsetT, accelerometerOffset);
                    rotate([-90, 0, -90])
                        fillet(fillet, baseSize.x);
                    translate_z(-size.z + 2*baseThickness)
                        rotate([-90, -90, -90])
                            fillet(internalFillet, baseSize.x);
                    // base
                    translate_z(-size.z + topThickness)
                        xCarriageBottom(xCarriageType, size, holeSeparationBottom, reflected);
                }
            } // end union
        if (toolheadHoles) {
            // using large carriage, so can support XChange toolhead
            translate([0, carriageSize.y/2 + size.y + eps, topThickness - 20]) {
                rotate([90, 0, 0])
                    translate_z(-carriage_height(MGN12H_carriage))
                        carriage_hole_positions(MGN12H_carriage)
                            rotate(-90)
                                boltHoleM3(size.y + beltInsetBack(xCarriageType));
            }
        }
    } // end difference
}


module xCarriageBeltSideBolts(xCarriageType, size, topBoltLength=10, holeSeparationTop, holeSeparationBottom, bottomBoltLength=12, holeSeparationBottom, screwType=hs_cs_cap, boreDepth=0, offsetT=0, offsetB=0) {
    translate([-size.x/2, -xCarriageBeltSideOffsetY(xCarriageType, size.y) - xCarriageExtraBackThickness(xCarriageType), 0]) {
        // holes at the top to connect to the xCarriage
        for (x = xCarriageHolePositions(size.x, holeSeparationTop))
            translate([x, 0, xCarriageTopThickness()/2 + offsetT])
                rotate([90, 90, 0])
                    if (screwType==hs_cs_cap)
                        boltM3Countersunk(topBoltLength);
                    else if (screwType==hs_dome)
                        boltM3Buttonhead(topBoltLength);
                    else
                        translate_z(-boreDepth)
                            boltM3Caphead(topBoltLength);
        // holes at the bottom to connect to the xCarriage
        for (x = xCarriageHolePositions(size.x, holeSeparationBottom))
            translate([x, 0, -size.z + xCarriageTopThickness() + xCarriageBaseThickness()/2 + offsetB])
                rotate([90, 90, 0])
                    if (screwType==hs_cs_cap)
                        boltM3Countersunk(bottomBoltLength);
                    else if (screwType==hs_dome)
                        boltM3Buttonhead(bottomBoltLength);
                    else
                        translate_z(-boreDepth)
                            boltM3Caphead(bottomBoltLength);
    }
}

module boltHoleM3TapOrInsert(length, useInsert=false, horizontal=false, rotate=0, chamfer=0.5, chamfer_both_ends=false, twist=undef) {
    if (useInsert)
        insert_hole(F1BM3, horizontal=horizontal);
    else
        boltHole(M3_tap_radius*2, length, horizontal, rotate, chamfer, chamfer_both_ends, twist=twist);
}
