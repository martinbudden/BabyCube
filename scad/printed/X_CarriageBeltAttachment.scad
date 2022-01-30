use <NopSCADlib/utils/core_xy.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/rails.scad>
use <NopSCADlib/vitamins/pcb.scad>

use <X_Carriage.scad>

include <../vitamins/bolts.scad>
include <../vitamins/pcbs.scad>


function xCarriageBeltTensionerSize(beltWidth, sizeX=0) = [sizeX, 10, beltWidth + 1.2];
function xCarriageBeltTensionerBoltOffset(sizeX=0) = [sizeX, 7.25, -0.6];

function xCarriageBottomOffsetZ() = 40.8;
//function xCarriageBeltAttachmentSize(beltWidth, beltSeparation, sizeZ=0) = [20+beltSeparation-4.5, 18.5, sizeZ];
function xCarriageBeltAttachmentSize(beltWidth, beltSeparation, sizeZ=0) = [(beltWidth + 1)*2 + beltSeparation + 1.5, 18.5, sizeZ];
// actual dimensions for belt are thickness:1.4, toothHeight:0.75
toothHeight = 0.8;//0.75;
function xCarriageBeltClampHoleSeparation() = 16;


module GT2Teeth(toothLength, toothCount, horizontal=false) {
    fillet = 0.35;
    size = [1, toothHeight];
    linear_extrude(toothLength)
        for (x = [0 : 2 : 2*toothCount])
            translate([x, 0]) {
                //if (x != 0)
                    rotate(90)
                        fillet(fillet);
                translate([size.x, 0])
                    fillet(fillet);
                difference() {
                    square(size);
                    *if (!horizontal) {
                        translate([0, size.y])
                            rotate(270)
                                fillet(fillet);
                        translate([size.x, size.y])
                            rotate(180)
                                fillet(fillet);
                    }
                }
            }
}

module xCarriageBeltTensioner(size) {
    fillet = 1;
    offsetX = 3.5;
    toothOffsetX = 3.93125;
    offsetY = 5;
    beltThickness = 1.65;//- 4.5 + 2.83118; actual belt thickness is 1.4
    offsetYT = offsetY - beltThickness;
    offsetY2 = 2.25;
    baseSizeZ = xCarriageBeltTensionerSize(0).z;

    translate_z(-baseSizeZ - (size.z - baseSizeZ)/2)
    difference() {
        union() {
            translate([offsetX, 0, 0])
                rounded_cube_xy([size.x - offsetX, size.y, 1], fillet);
            translate([0, offsetY2, 0])
                rounded_cube_xy([size.x, size.y - offsetY2, 1], fillet);
            translate([offsetX, 0, 0])
                rounded_cube_xy([size.x - offsetX - fillet, offsetYT, size.z], 0.5);
            //translate([toothOffsetX, 2.83118, 0])
            translate([toothOffsetX, offsetY, 0])
                mirror([0, 1, 0])
                    GT2Teeth(size.z, floor((size.x - 10)/2) + 1);
            *translate([toothOffsetX, offsetYT, 0])
                GT2Teeth(size.z, floor((size.x - 10)/2) + 1);
            translate([0, offsetY, 0])
                rounded_cube_xy([size.x, size.y - offsetY, size.z], fillet);
            translate([offsetX, offsetY2,0])
                rotate(180)
                    fillet(1, 1);
            translate([0, offsetY2, 0])
                rounded_cube_xy([2.5, size.y - offsetY2, size.z], 0.5);
            translate([2.5, offsetY, 0])
                rotate(270)
                    fillet(1, size.z);
            endSizeX = 4.5;
            translate([size.x - endSizeX, 0, 0])
                rounded_cube_xy([endSizeX, size.y, size.z], fillet);
        }
        //translate([0, 4.35, size.z/2])
        threadLength = 8;
        translate([0, xCarriageBeltTensionerBoltOffset().y, size.z/2]) {
            rotate([90, 0, 90])
                boltHoleM3(size.x - threadLength, horizontal=true, chamfer_both_ends=false);
            translate([size.x, 0, 0])
                rotate([90, 0, -90])
                    boltHoleM3Tap(threadLength, horizontal=true);
        }
        translate([0, -eps, -eps])
            rotate([90, 0, 90])
                right_triangle(fillet, fillet, size.x + 2*eps, center=false);
        translate([size.x, -eps, size.z + eps])
            rotate([-90, 0, 90])
                right_triangle(fillet, fillet, size.x + 2*eps, center=false);
    }
}

module X_Carriage_Belt_Tensioner_hardware(size, boltLength=40, offset=0) {
    translate(xCarriageBeltTensionerBoltOffset(offset))
        rotate([90, 0, 90])
            explode(10, true)
                washer(M3_washer)
                    boltM3Caphead(boltLength);
}

module xCarriageBeltClamp(size, offset=0, holeSeparation=xCarriageBeltClampHoleSeparation(), countersunk=false) {
    difference() {
        fillet = 1;
        translate([-size.x/2, -size.y/2 - offset, 0])
            rounded_cube_xy(size, fillet);
        for (x = [-holeSeparation/2, holeSeparation/2])
            translate([x, 0, 0])
                if (countersunk)
                    translate_z(size.z)
                        boltPolyholeM3Countersunk(size.z);
                else
                    boltHoleM3(size.z, twist=4);
    }
}

module X_Carriage_Belt_Clamp_hardware(size, offset=0, boltLength=10, countersunk=false) {
    for (x = [-xCarriageBeltClampHoleSeparation()/2, xCarriageBeltClampHoleSeparation()/2])
        translate([x, offset, size.z])
            if (countersunk)
                boltM3Countersunk(boltLength);
            else
                boltM3Buttonhead(boltLength);
}

module xCarriageBeltAttachment(size, beltWidth, beltSeparation, cutoutOffsetY=0, cutoutOffsetZ=0, boltCutout=false, boltCutoutOffset=0, reversedBelts=false, endCube=true) {
    size = size - [0, toothHeight, 0];
    offsetZ = 0;//18.5 - size.y - toothHeight;
    toothCount = floor(size.z/2) - 1;
    endCubeSize = [4, 9, 12];
    beltTensionerSize = xCarriageBeltTensionerSize(beltWidth);
    gapX = 0.6;
    cutoutSize = [beltTensionerSize.z + gapX, beltTensionerSize.y + 0.65];
    //assert(cutoutSize==[7.75, 10.75]);
    y1 = cutoutOffsetY + 0.75 - gapX/2;
    y2 = cutoutOffsetY - 0.45 - gapX/2;
    gap = beltWidth + beltSeparation - cutoutSize.x - y1 + y2;
    midOffsetY = y1 + cutoutSize.x + gap/2;
    //midOffsetY2 = (beltWidth + beltSeparation + cutoutSize.x + y1 + y2)/2;

    translate([0, -midOffsetY, 0])
    difference() {
        union() {
            rotate([90, 0, 90])
            //rotate([-90, 180, 0])
                linear_extrude(size.z, convexity=4)
                    difference() {
                        square([size.x, size.y]);
                        for (y = [y1, beltWidth + beltSeparation + y2])
                            translate([y, cutoutOffsetZ - offsetZ])
                                hull() {
                                    square([cutoutSize.x, cutoutSize.y - 1]);
                                    translate([1, 0])
                                        square([cutoutSize.x - 2, cutoutSize.y]);
                                }
                    }
            //translate([0, size.z/2 + toothCount + 0.5, size.y])
            //translate([-8.4 + (size.z - toothCount*2)/2, size.x, size.y])
            teeth = true;
            if (teeth) {
                translate([-0.5 + (size.z - toothCount*2)/2, size.x, size.y])
                    rotate([90, 0, 0])
                        GT2Teeth(size.x, toothCount, horizontal=true);
                //translate([-size.x, 0, size.y])
                // top flat part
                translate([0, size.x - 2, size.y])
                    cube([size.z, 2, toothHeight]);
                //translate([-8.8 - 3/2, 0, size.y])
                // middle flat part
                translate([0, midOffsetY - (beltSeparation - 1)/2, size.y])
                    cube([size.z, beltSeparation - 1, toothHeight]);
            }
            if (endCube) {// optionally hide endCube for debugging
                translate([reversedBelts ? size.z - endCubeSize.x : 0, cutoutOffsetY, cutoutOffsetZ - offsetZ])
                    cube(endCubeSize);
                    //translate([18.5, size.z - endCubeSize.y, 0])
                translate([reversedBelts ? 0 : size.z - endCubeSize.x, cutoutOffsetY + beltWidth + beltSeparation - 1.25, cutoutOffsetZ - offsetZ])
                    cube(endCubeSize);
            }
        } // end union
        boltCutoutWidth =  2.5;
        if (boltCutout) {
            //translate([-size.x - eps, -eps, size.y - 3.7 - boltCutoutWidth/2])
            depth = 1;
            translate([-eps, size.x - depth, size.y - 3.7 - boltCutoutWidth/2 - boltCutoutOffset])
                hull() {
                    cube([size.z + 2*eps, depth, boltCutoutWidth]);
                    translate([0, depth, -depth])
                        cube([size.z + 2*eps, eps, boltCutoutWidth + 2*depth]);
                }
        }
        for (x = [(size.z - xCarriageBeltClampHoleSeparation())/2, (size.z + xCarriageBeltClampHoleSeparation())/2])
            translate([x, midOffsetY, size.y + toothHeight])
                vflip()
                    boltHoleM3Tap(6);
        translate([0, cutoutOffsetY + 4.35, 3.35 - 0.5 - offsetZ + cutoutOffsetZ]) {
            translate([0, reversedBelts ? beltWidth + beltSeparation - (beltTensionerSize.z - beltWidth) + 0.3: 0, 0])
                rotate([90, 0, 90])
                    boltHoleM3(endCubeSize.x, horizontal=true);
            translate([size.z, reversedBelts ? 0.1 : beltWidth + beltSeparation - (beltTensionerSize.z - beltWidth), 0])
                rotate([90, 0, -90])
                    boltHoleM3(endCubeSize.x, horizontal=true);
        }
    } // end difference
}

function beltAttachmentOffsetY() = 14;

module xCarriageBeltSide(xCarriageType, size, beltsCenterZOffset, beltWidth, beltSeparation, holeSeparationTop, holeSeparationBottom, accelerometerOffset=undef, topHoleOffset=0, offsetT=0, countersunk=true, halfCarriage=false, reversedBelts=false, pulley25=false, endCube=true) {
    assert(is_list(xCarriageType));

    carriageSize = carriage_size(xCarriageType);
    isMGN12 = carriageSize.z >= 13;
    sizeExtraY = (isMGN12 ? 2 : 1.5) + (pulley25 ? 2 : 0);
    cutoutOffsetY = isMGN12 ? 1 : 2;
    cutoutOffsetZ = isMGN12 ? 5.5 : 2.25;
    tolerance = 0.05;
    offsetY25 = pulley25 ? 2.6 : 0;
    topSize = [size.x,
                halfCarriage ? size.y + carriageSize.y/2 + 2 - tolerance : size.y + carriageSize.y + 2*(pulley25 ? offsetY25 : 1.25) - tolerance,
                xCarriageTopThickness()];
    baseThickness = xCarriageBaseThickness();
    baseOffset = size.z - topSize.z;
    fillet = 1;
    beltAttachmentSize = xCarriageBeltAttachmentSize(beltWidth, beltSeparation, size.x) + [1, 2*offsetY25 + cutoutOffsetZ, 0];
    //offsetZ = 18.5 + offsetY25 - beltAttachmentSize.y;

    xCarriageBeltSideOffsetY = xCarriageBeltSideOffsetY(xCarriageType, size.y);
    //beltAttachmentOffsetY = xCarriageBeltSideOffsetY - beltAttachmentOffsetY();
    //beltAttachmentPlusOffsetSizeY = beltAttachmentSize.y + beltAttachmentOffsetY;
    beltAttachmentPlusOffsetSizeY = beltAttachmentSize.y + xCarriageBeltSideOffsetY - beltAttachmentOffsetY();

    translate([-size.x/2, -xCarriageBeltSideOffsetY, 0]) {
        difference () {
            translate_z(-baseOffset)
                union() {
                    //translate([size.x, beltAttachmentOffsetY, size.z - (isMGN12 ? 49: 45) - beltSeparation + 4.5])//-size.z + 20.5 + baseOffset])
                    translate([size.x, 0, baseOffset + beltsCenterZOffset])//-size.z + 20.5 + baseOffset])
                        rotate([-90, 180, 0])
                            //translate([0, size.x, 0]) mirror([0, 1, 0])
                            xCarriageBeltAttachment(beltAttachmentSize, beltWidth, beltSeparation, cutoutOffsetY, cutoutOffsetZ, boltCutout=true, boltCutoutOffset=offsetY25, reversedBelts=reversedBelts, endCube=endCube);
                    translate_z(baseThickness + beltAttachmentSize.x - fillet)
                        cube([size.x, size.y + sizeExtraY, size.z - beltAttachmentSize.x - baseThickness]);
                    translate_z(fillet + 0.25 + (reversedBelts ? 1 : 0))
                        cube([size.x, beltAttachmentSize.y, baseThickness - fillet + (isMGN12 ? 0 : 1)], fillet);
                    //if (pulley25)
                    translate([0, 0, size.z - topSize.z])
                        rounded_cube_xz(topSize, fillet);
                    if (pulley25 || !halfCarriage)
                        rounded_cube_xz(topSize, fillet);
                    rounded_cube_xz([size.x, halfCarriage ? beltAttachmentSize.x : beltAttachmentPlusOffsetSizeY, baseThickness], fillet);
                    /*if (isMGN12) {
                        rounded_cube_xz([size.x, beltAttachmentOffsetY, baseThickness + beltAttachmentSize.x], fillet);
                        if (pulley25)
                            translate_z(baseThickness + beltAttachmentSize.x - 2*fillet)
                                rounded_cube_xz([size.x, size.y + 4, size.z - baseThickness - beltAttachmentSize.x + 2*fillet], fillet);
                    } else {
                        offsetZ = 26.5;
                        translate_z(offsetZ)
                            rounded_cube_xz([size.x, size.y + 1.5, size.z - offsetZ], fillet);
                    }*/

                } // end union
            offsetY = size.y + sizeExtraY;
            translate([0, offsetY, baseThickness + beltAttachmentSize.x - baseOffset - 1]) {
                rotate([-90, 0, 0])
                    fillet(1, beltAttachmentSize.y - offsetY + eps);
                translate([size.x, 0, 0])
                    rotate([-90, 90, 0])
                        fillet(1, beltAttachmentSize.y - offsetY + eps);
            }

            // bolt holes to connect to to the MGN carriage
            translate([size.x/2 + topHoleOffset, xCarriageBeltSideOffsetY + offsetY25, -carriage_height(xCarriageType)]) {
                carriage_hole_positions(xCarriageType) {
                    boltHoleM3(topSize.z, horizontal=true);
                    // cut the countersink
                    translate_z(topSize.z)
                        hflip()
                            boltHoleM3(topSize.z, horizontal=true, chamfer=3.2, chamfer_both_ends=false);
                }
                if (is_list(accelerometerOffset))
                    translate(accelerometerOffset + [0, 0, carriage_height(xCarriageType)])
                        rotate(180)
                            pcb_hole_positions(ADXL345)
                                vflip()
                                    boltHoleM3Tap(8, horizontal=true);
            }
            // holes at the top to connect to the hotend side
            for (x = xCarriageHolePositions(size.x, holeSeparationTop))
                translate([x + topHoleOffset, 0, -baseOffset + size.z - topSize.z/2 + offsetT])
                    rotate([-90, 0, 0])
                        if (countersunk)
                            boltPolyholeM3Countersunk(topSize.y, sink=(pulley25 ? 1 : 0.2));
                        else
                            boltHoleM3(topSize.y);
            /*for (x = xCarriageTopHolePositions(xCarriageType, xCarriageHoleOffsetTop().x))
                translate([x, 0, -baseOffset + size.z - topSize.z/2 + xCarriageHoleOffsetTop().y])
                    rotate([-90, 0, 0])
                        boltPolyholeM3Countersunk(topSize.y);
                        //boltHoleM3(topSize.y, twist=4);*/
            // holes at the bottom to connect to the hotend side
            for (x = xCarriageHolePositions(size.x, holeSeparationBottom))
               translate([x + topHoleOffset, 0, -baseOffset + baseThickness/2])
                    rotate([-90, 0, 0])
                        if (countersunk)
                            boltPolyholeM3Countersunk(pulley25 || !halfCarriage ? topSize.y : beltAttachmentPlusOffsetSizeY, sink=(pulley25 ? 1 : 0.2));
                        else
                            boltHoleM3(pulley25 || !halfCarriage ? topSize.y : beltAttachmentPlusOffsetSizeY);
            /*for (x = xCarriageBottomHolePositions(xCarriageType, xCarriageHoleOffsetBottom().x))
                translate([x, 0, -baseOffset + baseThickness/2 + xCarriageHoleOffsetBottom().y])
                    rotate([-90, 0, 0])
                        boltPolyholeM3Countersunk(beltAttachmentPlusOffsetSizeY);
                        //boltHoleM3(size.y + beltInsetFront(xCarriageType), twist=4, cnc=true);*/
            if (isMGN12) {
                // EVA compatible boltholes
                //for (x = xCarriageHolePositions(size.x, evaHoleSeparationBottom))
                //    translate([x, 0, -baseOffset + baseThickness/2])
                //        rotate([-90, 0, 0])
                //            boltHoleM3Tap(8);
                translate([size.x/2, -6.5 + xCarriageBeltSideOffsetY, topSize.z - size.z/2])
                    rotate([90, 0, 0])
                        carriage_hole_positions(MGN12H_carriage)
                            vflip()
                                boltHoleM3Tap(6);
            } else {
                // extra bolt holes to allow something to be attached to the carriage
                for (z = [baseThickness/2, size.z - topSize.z/2])
                    translate([size.x/2 + topHoleOffset, 0, z -baseOffset])
                        rotate([-90, 0, 0])
                            boltHoleM3Tap(8);
            }
        } // end difference
    }
}
