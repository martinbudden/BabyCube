
include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/core_xy.scad>
use <NopSCADlib/utils/fillet.scad>
use <NopSCADlib/utils/hanging_hole.scad>
include <NopSCADlib/vitamins/belts.scad>
include <NopSCADlib/vitamins/rails.scad>
use <NopSCADlib/vitamins/pcb.scad>

include <../vitamins/bolts.scad>
include <../vitamins/pcbs.scad>


_useInsertsForXCarriage = false;


fillet = 1;

topThickness = xCarriageTopThickness();
baseThickness = xCarriageBaseThickness();
xCarriageFrontSize = [30, 4, 40.5];
railCarriageGap = 0.5;

function beltInsetBack(xCarriageType) = is_undef(xCarriageType) ? 4.5 : xCarriageType == MGN12H_carriage ? 6.5 : 4.5;

function xCarriageTopThickness() = 8;
function xCarriageBaseThickness() = 8;
//function xCarriageFrontSize(xCarriageType, beltWidth, clamps) =  [max(carriage_size(xCarriageType).x, xCarriageFrontSize.x), xCarriageFrontSize.y, (xCarriageType[0] == "MGN12H" ? 36 : xCarriageFrontSize.z) + carriage_height(xCarriageType) + topThickness + (!is_undef(beltWidth) && beltWidth == 9 ? 4.5 : 0)]; //has the belt tensioners
function xCarriageFrontSize(xCarriageType, beltWidth) =  [max(carriage_size(xCarriageType).x, xCarriageFrontSize.x), xCarriageFrontSize.y, 36 + carriage_height(xCarriageType) + topThickness + (!is_undef(beltWidth) && beltWidth == 9 ? 4.5 : 0)]; //has the belt tensioners
function xCarriageBackSize(xCarriageType, beltWidth) = [xCarriageFrontSize(xCarriageType, beltWidth).x, 5, xCarriageFrontSize(xCarriageType, beltWidth).z];
xCarriageFrontOffsetExtraY = 2;
function xCarriageFrontOffsetY(xCarriageType) = carriage_size(xCarriageType).y/2 + xCarriageFrontSize(xCarriageType).y + xCarriageFrontOffsetExtraY;
function xCarriageBackOffsetY(xCarriageType) = carriage_size(xCarriageType).y/2 + xCarriageBackSize(xCarriageType).y;
//function xCarriageTopHolePositions(xCarriageType, offset=4) = [offset, xCarriageFrontSize(xCarriageType).x - offset];
////function xCarriageBottomHolePositions(xCarriageType) = [xCarriageType == MGN9C_carriage? 4 : 10, xCarriageFrontSize(xCarriageType).x - 4];
//function xCarriageBottomHolePositions(xCarriageType, offset=4) = [offset, xCarriageFrontSize(xCarriageType).x - offset];

function xCarriageHolePositions(sizeX, spacing) = [(sizeX - spacing)/2, (sizeX + spacing)/2];
evaHoleSeparationTop = 34;
function xCarriageHoleSeparationTop(xCarriageType) = xCarriageType[0] == "MGN9C" ? 22 : evaHoleSeparationTop; //45.4 - 8
function xCarriageHoleSeparationBottom(xCarriageType) = xCarriageType[0] == "MGN9C" ? 22 : 38;//34;//37.4; //45.4 - 8
function xCarriageBeltAttachmentMGN9CExtraX() = 4;

module xCarriageTop(xCarriageType, xCarriageBackSize, holeSeparationTop, reflected=false, clamps=true, strainRelief=false, countersunk=4, topHoleOffset=0, holeOffset=0, accelerometerOffset=undef) {
    assert(is_list(xCarriageType));

    //extraY = xCarriageFrontOffsetY(xCarriageType) - carriage_size(xCarriageType).y/2 - xCarriageFrontSize(xCarriageType).y;
    carriageSize = carriage_size(xCarriageType);
    carriageOffsetY = carriageSize.y/2;
    size =  [xCarriageBackSize.x + (!clamps && carriageSize.z < 13 ? xCarriageBeltAttachmentMGN9CExtraX() : 0), xCarriageBackSize.y + (clamps ? xCarriageFrontOffsetExtraY + carriageSize.y : carriageSize.y/2), topThickness];

    difference() {
        translate([0, xCarriageBackSize.y - size.y, 0])
            rounded_cube_yz(size, fillet);
        // insert holes  to connect to the front
        holeSeparation = xCarriageHoleSeparationTop(xCarriageType);
        for (x = xCarriageHolePositions(size.x, holeSeparation))
        //for (x = xCarriageTopHolePositions(xCarriageType, holeOffset.x))
            translate([x + topHoleOffset, xCarriageBackSize.y - size.y, size.z/2 + holeOffset])
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
                            boltHoleM3Tap(8, horizontal=true, rotate=(reflected ? -90 : 90));
    }
    if (strainRelief) {
        tabSize = [15, carriageSize.y > 20 ? 5 : 4, 25]; // ensure room for bolt heads
        translate([reflected ? size.x - tabSize.x : 0, 0, size.z - 2*fillet])
            difference() {
                rounded_cube_yz(tabSize, fillet);
                for (x = [tabSize.x/2 - 4, tabSize.x/2 + 4], z = [5 + 2, 15 + 2])
                    translate([x - 1, -eps, z])
                        cube([2, tabSize.y + 2*eps, 4]);
            }
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

module xCarriageTopBolts(xCarriageType, countersunk = true, positions=undef) {
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

module xCarriageBottom(xCarriageType, size, holeSeparation, reflected=false, clamps=false) {
    assert(is_list(xCarriageType));

    //extraY = xCarriageFrontOffsetY(xCarriageType) - carriage_size(xCarriageType).y/2 - xCarriageFrontSize(xCarriageType).y;
    xCarriageBackSize = xCarriageBackSize(xCarriageType);
    //size =  [xCarriageBackSize.x, clamps ? xCarriageFrontOffsetExtraY + carriage_size(xCarriageType).y + xCarriageBackSize.y - beltInsetFront(xCarriageType) : 13.5, baseThickness];
    translate([0, -size.y + xCarriageBackSize.y, 0])
        difference() {
            rounded_cube_yz(size, fillet);
            // insert holes to connect to the front
            //holeSeparation = xCarriageHoleSeparationBottom(xCarriageType);
            for (x = xCarriageHolePositions(size.x, holeSeparation))
            //for (x = xCarriageBottomHolePositions(xCarriageType, holeOffset.x))
                translate([x, 0, size.z/2])
                    rotate([-90, -90, 0])
                        boltHoleM3TapOrInsert(xCarriageType[0] == clamps ? 14 : 12, horizontal=true, rotate=(reflected ? 180 : 0), chamfer_both_ends=false);
        }
}

module xCarriageBack(xCarriageType, size, beltWidth, beltOffsetZ, coreXYSeparationZ, toolheadHoles=false, reflected=false, clamps=false, strainRelief=false, countersunk=0, topHoleOffset=0, offsetT=0, accelerometerOffset=undef) {
    assert(is_list(xCarriageType));
    internalFillet = 1.5;
    carriageSize = carriage_size(xCarriageType);
    holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);
    isMGN12 = carriageSize.z >= 13;

    // the back has clamps for the two belts and attaches to the hotend
    baseSize = [size.x, carriageSize.y + size.y - 2*beltInsetBack(xCarriageType), baseThickness];
    //topSize =  [size.x, carriageSize.y + size.y - 2*beltInsetBack(xCarriageType) + xCarriageFrontSize(xCarriageType, beltWidth).y, topThickness];
    difference() {
        translate([-size.x/2, carriageSize.y/2, 0])
            union() {
                translate([0, railCarriageGap, baseSize.z - size.z])
                    rounded_cube_yz([size.x, size.y - railCarriageGap, size.z], fillet);
                translate([0, railCarriageGap, 0])
                    rotate([-90, 0, -90])
                        fillet(fillet, baseSize.x);
                if (clamps) {
                    translate([0, railCarriageGap - beltInsetBack(xCarriageType), -size.z + baseThickness]) {
                        rectSize1 = [size.x, 4.5 + 2*fillet, size.z - railCarriageGap - topThickness - carriageSize.z + carriage_clearance(xCarriageType)];
                        rectSize2 = [size.x, beltInsetBack(xCarriageType) + 2*fillet, size.z - railCarriageGap - topThickness - carriageSize.z + carriage_clearance(xCarriageType) - 10];
                        translate([0, beltInsetBack(xCarriageType)-4.5, 0])
                            rounded_cube_yz(rectSize1, fillet);
                        rounded_cube_yz(rectSize2, fillet);
                        translate_z(baseThickness)
                            rotate([-90, -90, -90])
                                fillet(internalFillet, baseSize.x);
                    }
                } else {
                        translate([0, railCarriageGap, -size.z + 2*baseThickness])
                            rotate([-90, -90, -90])
                                fillet(internalFillet, baseSize.x);
                }
                // top
                xCarriageTop(xCarriageType, size, holeSeparationTop, reflected, clamps, strainRelief, countersunk, topHoleOffset, offsetT, accelerometerOffset);
                // base
                xCarriageBottomSize =  [size.x, clamps ? xCarriageFrontOffsetExtraY + carriageSize.y + size.y - beltInsetFront(xCarriageType) : (carriageSize.z >= 13 ? 13.95 : 10.5), baseThickness];
                translate_z(-size.z + topThickness)
                    xCarriageBottom(xCarriageType, xCarriageBottomSize, holeSeparationBottom, reflected, clamps);
            } // end union
        if (clamps)
            translate([-size.x/2 - eps, carriageSize.y/2 - beltInsetBack(undef) + size.y, beltOffsetZ]) {
                for (z = [clampHoleSpacing(beltWidth)/2, -clampHoleSpacing(beltWidth)/2])
                    translate_z(z - coreXYSeparationZ/2)
                        rotate([90, 0, 90])
                            boltHoleM3TapOrInsert(10);
                translate([size.x + 2*eps, 0, 0])
                    for (z = [clampHoleSpacing(beltWidth)/2, -clampHoleSpacing(beltWidth)/2])
                        translate_z(z + coreXYSeparationZ/2)
                            rotate([90, 0, -90])
                                boltHoleM3TapOrInsert(10);
            }
        if (toolheadHoles) {
            // using large carriage, so can support XChange toolhead
            translate([0, carriageSize.y/2 + size.y + eps, topThickness - 20]) {
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


module xCarriageFrontBolts(xCarriageType, size, topBoltLength=10, holeSeparationTop, bottomBoltLength=12, holeSeparationBottom, countersunk=false, offsetT=0) {
    translate([-size.x/2, -xCarriageFrontOffsetY(xCarriageType), 0]) {
        // holes at the top to connect to the xCarriage
        for (x = xCarriageHolePositions(size.x, holeSeparationTop))
        //for (x = xCarriageTopHolePositions(xCarriageType, offsetT.x))
            translate([x, 0, xCarriageTopThickness()/2 + offsetT])
                rotate([90, 90, 0])
                    if (countersunk)
                        boltM3Countersunk(topBoltLength);
                    else
                        boltM3Buttonhead(topBoltLength);
        // holes at the bottom to connect to the xCarriage
        for (x = xCarriageHolePositions(size.x, xCarriageHoleSeparationBottom(xCarriageType)))
        //for (x = xCarriageBottomHolePositions(xCarriageType, offsetB.x))
            translate([x, 0, -size.z + xCarriageTopThickness() + xCarriageBaseThickness()/2])
                rotate([90, 90, 0])
                    if (countersunk)
                        boltM3Countersunk(bottomBoltLength);
                    else
                        boltM3Buttonhead(bottomBoltLength);
    }
}

module boltHoleM3TapOrInsert(length, useInsert=false, horizontal=false, rotate=0, chamfer=0.5, chamfer_both_ends=false, twist=undef) {
    if (useInsert)
        insert_hole(F1BM3, horizontal=horizontal);
    else
        boltHole(M3_tap_radius*2, length, horizontal, rotate, chamfer, chamfer_both_ends, twist=twist);
}
