include <NopSCADlib/core.scad>
use <NopSCADlib/utils/core_xy.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/rails.scad>

use <X_Carriage.scad>

use <../vitamins/bolts.scad>
include <../vitamins/pcbs.scad>


function xCarriageBeltTensionerSize(sizeX=0) = [sizeX, 10, 7.2];

function xCarriageBottomOffsetZ() = 40.8;
function xCarriageHoleOffsetTop() = [5.65, -1]; // for alignment with EVA
//function xCarriageHoleOffsetTop() = [4, 0];
//function xCarriageHoleOffsetBottom() = [9.7, 4.5]; // for alignment with EVA
//function xCarriageHoleOffsetBottom() = [9.7, 0];
function xCarriageHoleOffsetBottom() = [4, 0];
evaHoleOffsetBottom = 9.7;
evaHoleSeparationBottom = 26;
function xCarriageBeltAttachmentSize(sizeZ=0) = [24, 18, sizeZ];
// actual dimensions for belt are thickness:1.4, toothHeight:0.75
toothHeight = 0.8;//0.75;
function xCarriageBeltClampHoleSeparation() = 12;


module GT2Teeth(sizeZ, toothCount, horizontal=false) {
    fillet = 0.35;
    size = [1, toothHeight];
    linear_extrude(sizeZ)
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

module xCarriageBeltTensioner(sizeX) {
    size = xCarriageBeltTensionerSize(sizeX);
    fillet = 1;
    offsetX = 3.5;
    toothOffsetX = 3.93125;
    offsetY = 5;
    beltThickness = 1.65;//- 4.5 + 2.83118; actual belt thickness is 1.4
    offsetYT = offsetY - beltThickness;
    offsetY2 = 2.25;

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
        boltOffsetY = 7.25; // was (size.y + offsetY)/2
        translate([0, boltOffsetY, size.z/2]) {
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

module X_Carriage_Belt_Tensioner_hardware(offset=0) {
    size = xCarriageBeltTensionerSize();
    offsetY = 4.5;
    translate([offset + 22.7, (size.y + offsetY)/2, size.z/2])
        rotate([90, 0, 90])
            explode(10, true)
                washer(M3_washer)
                    boltM3Caphead(40);
}

module xCarriageBeltClampPositions(sizeZ) {
    rotate([90, 90, 0])
        for (y = [3*sizeZ/10, 7*sizeZ/10])
            translate([-xCarriageBeltAttachmentSize().x, y, 18.5])
                children();
}

module X_Carriage_Belt_Clamp_hardware() {
    size = [xCarriageBeltAttachmentSize().x - 0.5, 6, 4.5];

    for (x = [0, xCarriageBeltClampHoleSeparation()])
        translate([x + 3.2, 0, 0])
            vflip()
                boltM3Buttonhead(10);
}

module xCarriageBeltAttachment(sizeZ, endCube=true) {
    size = xCarriageBeltAttachmentSize(sizeZ) - [0, toothHeight, 0];
    cutoutSize = [xCarriageBeltTensionerSize().z + 0.55, xCarriageBeltTensionerSize().y + 0.75];
    assert(cutoutSize==[7.75, 10.75]);
    endCubeSize = [9, 8, 12];
    toothCount = floor(size.z/2) - 1;

    difference() {
        union() {
            rotate([-90, 180, 0])
                linear_extrude(size.z)
                    difference() {
                        square([size.x, size.y]);
                        for (y = [0, 9.25])
                            translate([y + 0.5, 0.5])
                                hull() {
                                    square([cutoutSize.x, cutoutSize.y - 1]);
                                    translate([1, 0])
                                        square([cutoutSize.x - 2, cutoutSize.y]);
                                }
                    }
            translate([0, size.z/2 + toothCount + 0.5, size.y])
                rotate([90, 0, -90])
                    GT2Teeth(8*2 + 2.5, toothCount, horizontal=true);
            translate([-size.x, 0, size.y])
                cube([xCarriageBeltAttachmentSize().x - 18, size.z, toothHeight]);
            translate([-8.8 - 3/2, 0, size.y])
                cube([3, size.z, toothHeight]);
            if (endCube) {
                translate([-9, 0, 0])
                    cube(endCubeSize);
                translate([-18.5, size.z - endCubeSize.y, 0])
                    cube(endCubeSize);
            }
        }
        for (x = [0, -xCarriageBeltClampHoleSeparation()], y = [3*size.z/10, 7*size.z/10])
            translate([x - 8.8, y, size.y + toothHeight])
                vflip()
                    boltHoleM3Tap(6);
        translate([-4.2, 0, 3.3]) {
            rotate([-90, 180, 0])
                boltHoleM3(endCubeSize.y, horizontal=true);
            translate([-9.2, size.z, 0])
                rotate([90, 0, 0])
                    boltHoleM3(endCubeSize.y, horizontal=true);
        }
    }
}

module xCarriageFrontBeltAttachment(xCarriageType, beltWidth, beltOffsetZ, coreXYSeparationZ, accelerometerOffset=undef) {
    assert(is_list(xCarriageType));

    size = xCarriageFrontSize(xCarriageType, beltWidth, clamps=false);
    carriageSize = carriage_size(xCarriageType);
    sizeExtra = [0, (carriageSize.z >= 13 ? 1 : -1), 0];
    tolerance = 0.05;
    topSize = [size.x, size.y + carriageSize.y/2 + 2 - tolerance, xCarriageTopThickness()];
    baseThickness = xCarriageBaseThickness();
    baseOffset = size.z - topSize.z;
    railCarriageGap = 0.5;
    fillet = 1;
    beltAttachmentSizeY = xCarriageBeltAttachmentSize().y + xCarriageFrontOffsetY(xCarriageType) - 13;

    translate([-size.x/2, -xCarriageFrontOffsetY(xCarriageType), 0]) {
        difference () {
            translate_z(-baseOffset)
                union() {
                    translate([size.x, xCarriageFrontOffsetY(xCarriageType) - 13, size.z - 49])//-size.z + 20.5 + baseOffset])
                        rotate([0, 90, 90])
                            xCarriageBeltAttachment(size.x);
                    rounded_cube_xz(size + sizeExtra, fillet);
                    translate([0, 0, size.z - topSize.z])
                        rounded_cube_xz(topSize, fillet);
                    insetHeight = 8 + 2*fillet;//size.z - railCarriageGap - topSize.z - carriage_size(xCarriageType).z + carriage_clearance(xCarriageType);
                    rounded_cube_xz([size.x, beltAttachmentSizeY, baseThickness], fillet);
                    translate_z(fillet + 0.25)
                        cube([size.x, beltAttachmentSizeY, baseThickness - fillet], fillet);
                    if (size.x > 30)
                        rounded_cube_xz([size.x, size.y + 2.6, baseThickness + xCarriageBeltAttachmentSize().x], fillet);
                } // end union
            translate([0, size.y + sizeExtra.y, -49 + topSize.z + xCarriageBeltAttachmentSize().x]) {
                rotate([-90, 0, 0])
                    fillet(1, 20.5 - sizeExtra.y + eps);
                translate([size.x, 0, 0])
                    rotate([-90, 90, 0])
                        fillet(1, 20.5 - sizeExtra.y + eps);
            }
            // bolt holes to connect to to the MGN carriage
            translate([size.x/2, xCarriageFrontOffsetY(xCarriageType), -carriage_height(xCarriageType)]) {
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
            // holes at the top to connect to the printhead
            for (x = xCarriageHolePositions(size.x, xCarriageHoleSeparationTop(xCarriageType)))
                translate([x, 0, -baseOffset + size.z - topSize.z/2 + xCarriageHoleOffsetTop().y])
                    rotate([-90, 0, 0])
                        boltPolyholeM3Countersunk(topSize.y);
            /*for (x = xCarriageTopHolePositions(xCarriageType, xCarriageHoleOffsetTop().x))
                translate([x, 0, -baseOffset + size.z - topSize.z/2 + xCarriageHoleOffsetTop().y])
                    rotate([-90, 0, 0])
                        boltPolyholeM3Countersunk(topSize.y);
                        //boltHoleM3(topSize.y, twist=4);*/
            // holes at the bottom to connect to the printhead
            for (x = xCarriageHolePositions(size.x, xCarriageHoleSeparationBottom(xCarriageType)))
               translate([x, 0, -baseOffset + baseThickness/2 + xCarriageHoleOffsetBottom().y])
                    rotate([-90, 0, 0])
                        boltPolyholeM3Countersunk(beltAttachmentSizeY);
            /*for (x = xCarriageBottomHolePositions(xCarriageType, xCarriageHoleOffsetBottom().x))
                translate([x, 0, -baseOffset + baseThickness/2 + xCarriageHoleOffsetBottom().y])
                    rotate([-90, 0, 0])
                        boltPolyholeM3Countersunk(beltAttachmentSizeY);
                        //boltHoleM3(size.y + beltInsetFront(xCarriageType), twist=4,cnc=true);*/
            if (carriageSize.z >= 13) {
                // EVA compatible boltholes
                for (x = xCarriageHolePositions(size.x, evaHoleSeparationBottom))
                    translate([x, 0, -baseOffset + baseThickness/2])
                        rotate([-90, 0, 0])
                            boltHoleM3Tap(8, twist=4);
                // add bolt holes to allow tooling to be attached, eg second printhead
                translate([size.x/2, -6.5 + xCarriageFrontOffsetY(xCarriageType), topSize.z - size.z/2])
                    rotate([90, 0, 0])
                        carriage_hole_positions(MGN12H_carriage)
                            vflip()
                                boltHoleM3Tap(6, twist=4);
            }
        } // end difference
    }
}

module xCarriageFrontBeltAttachmentPositions(xCarriageType, beltWidth) {
    size = xCarriageFrontSize(xCarriageType, beltWidth, clamps=false);
    translate([-size.x/2, size.z/2, -xCarriageBottomOffsetZ()])
        explode([0, 10, 0], true)
            xCarriageBeltClampPositions(size.x)
                children();
}
