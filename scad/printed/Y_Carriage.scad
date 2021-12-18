
include <../global_defs.scad>

use <NopSCADlib/utils/fillet.scad>

include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/pulleys.scad>

include <../vitamins/bolts.scad>
include <../vitamins/inserts.scad>


function isMGN9C(carriageType) = carriageType[0] == MGN9C_carriage[0];

function pulleyStackHeight(pulleyHeight, pulleyBore) = pulleyHeight + 2*washer_thickness(pulleyBore == 3 ? M3_washer : pulleyBore == 4 ? M4_washer : M5_washer);
function plainPulleyPos(left, pulleyHeight, pulleyBore, pulleyOffset, thickness, yCarriageBraceThickness) = [pulleyOffset.x + 12.15, 0, thickness + pulleyStackHeight(pulleyHeight, pulleyBore)/2 + (left ? pulleyStackHeight(pulleyHeight, pulleyBore) + yCarriageBraceThickness : 0)];
function toothedPulleyPos(left, pulleyHeight, pulleyBore, pulleyOffset, thickness, yCarriageBraceThickness) = [pulleyOffset.x, 0, thickness + pulleyStackHeight(pulleyHeight, pulleyBore)/2 + (left ? 0 : pulleyStackHeight(pulleyHeight, pulleyBore) + yCarriageBraceThickness)];

function railFirstHoleOffset(type, length) = (length - (rail_holes(type, length) - 1)*rail_pitch(type))/2;

// allow adjustment of counterbore to optimise bolt length
function counterBore(thickness) = screw_head_height(M3_cap_screw) + max(thickness - 9, 0);
function yCarriageBlockSizeX(yCarriageType) = carriage_width(yCarriageType) + 4;
function yCarriageExplodeFactor() = 5;
function yCarriageTongueThickness(yCarriageType, chamfer=0) = isMGN9C(yCarriageType) ? 6.5 - chamfer : 7;

function boltOffsetMGN9(left) = 13.5;
function boltOffsetInnerMGN12(left, blockOffsetX) = blockOffsetX ? 29 : 22;
function boltOffsetOuterMGN12(left, blockOffsetX) = (blockOffsetX ? (left ? 2.5 : 3) : 4);

leftSupportLength = 20;

module yCarriageTongueBoltPositions(tongueOffset, xRailType, xRailLength, screws=2) {
    translate([tongueOffset + xRailLength/2, 0, 0])
        rail_hole_positions(xRailType, xRailLength, screws=screws, both_ends=false)
            children();
}

module Y_Carriage(yCarriageType, idlerHeight, pulleyBore, xRailType, xRailLength, thickness, chamfer, yCarriageBraceThickness, blockOffset, endStopOffsetX, tongueOffset, plainIdlerOffset, toothedIdlerOffset, topInset=0, inserts=false, left=true, cnc=false) {
    assert(is_list(yCarriageType));
    assert(is_list(xRailType));
    assert(pulleyBore == 3 || pulleyBore == 4 || pulleyBore == 5);

    plainIdlerHeight = idlerHeight;
    toothedIdlerHeight = idlerHeight;

    fillet = isMGN9C(yCarriageType) ? 1.5 : 2.5;
    pulley25 = is_list(blockOffset);
    blockOffset =  is_list(blockOffset) ? blockOffset : [0, blockOffset];

    blockSize = [yCarriageBlockSizeX(yCarriageType) + blockOffset.x, carriage_length(yCarriageType) + 1 + 2*blockOffset.y, thickness];
    rightInset = topInset == 0 ? 0 : 2;
    railFirstHoleOffset = railFirstHoleOffset(xRailType, xRailLength);
    tongueSize = [tongueOffset + railFirstHoleOffset + rail_pitch(xRailType) + rail_width(xRailType)/2 + 0.5, rail_width(xRailType) + 2, yCarriageTongueThickness(yCarriageType, chamfer)];

    module chamfered_rounded_cube(size, fillet, chamfer) {
        hull() {
            if (chamfer) {
                translate([chamfer, chamfer, 0])
                    rounded_cube_xy([size.x - 2*chamfer, size.y - 2*chamfer, chamfer], fillet);
                translate([chamfer, chamfer, size.z - chamfer])
                    rounded_cube_xy([size.x - 2*chamfer, size.y - 2*chamfer, chamfer], fillet);
            }
            translate_z(chamfer)
                rounded_cube_xy([size.x, size.y, size.z - 2*chamfer], fillet);
        }
    }

    module tongue(tongueSize, left, tFillet=4) {
        // add rail_width/2 to tongueSize.x to give a bit of extra length to the tongue for wider rails
        translate([0, -tongueSize.y/2, 0])
            chamfered_rounded_cube(tongueSize, fillet, chamfer);

        //endStopSize = [tongueOffset + endStopOffsetX, tongueSize.y + (left ? 5.5 : 11), tongueSize.z];
        //translate([0, -(endStopSize.y - tongueSize.y), 0])
        //    rounded_cube_xy(endStopSize, fillet);
        fillet = isMGN9C(yCarriageType) ? 2 : tFillet;
        filletE = endStopOffsetX == 0 ? fillet : 1;
        xPos = blockSize.x/2 - blockOffset.x/2;
        xPosE = endStopOffsetX == 0 ? xPos : tongueOffset + endStopOffsetX;
        if (left) {
            translate([xPosE, tongueSize.y/2, chamfer])
                fillet(filletE, tongueSize.z - 2*chamfer);
            translate([xPos, -tongueSize.y/2, chamfer])
                rotate(-90)
                    fillet(fillet, tongueSize.z - 2*chamfer);
        } else {
            translate([xPosE, -tongueSize.y/2, chamfer])
                rotate(-90)
                    fillet(filletE, tongueSize.z - 2*chamfer);
            translate([xPos, tongueSize.y/2, chamfer])
                fillet(fillet, tongueSize.z - 2*chamfer);
        }

        /*if (blockSize.x/2 + blockOffset.x < tongueOffset) {
            translate([blockSize.x/2 + blockOffset.x, tongueSize.y, 0])
                fillet(left ? 1 : 3 - rightInset, tongueSize.z);
            translate([blockSize.x/2 + blockOffset.x, -(endStopSize.y - tongueSize.y), 0])
                rotate(-90)
                    fillet(left ? 2 : 1, tongueSize.z);
        } else {
            translate([blockSize.x/2 + blockOffset.x, tongueSize.y/2, 0])
                fillet(4, tongueSize.z);
            translate([blockSize.x/2 + blockOffset.x, -tongueSize.y/2, 0])
                rotate(-90)
                    fillet(4, tongueSize.z);
        }*/
    }

    difference() {
        plainPulleyPos = plainPulleyPos(left, plainIdlerHeight, pulleyBore, plainIdlerOffset, thickness, yCarriageBraceThickness);
        toothedPulleyPos = toothedPulleyPos(left, toothedIdlerHeight, pulleyBore, toothedIdlerOffset, thickness, yCarriageBraceThickness);
        union() {
            endstopX = tongueOffset - blockSize.x/2 + blockOffset.x/2 + endStopOffsetX;
            translate([-blockSize.x/2 - blockOffset.x/2, left ? blockOffset.y : -blockSize.y/2 - blockOffset.y, 0]) {
                // inset the block to avoid possible interference with the idler pulleys
                rounded_cube_xy([blockSize.x + endstopX, blockSize.y/2, blockSize.z - 1], fillet);
                if (left) {
                    *rounded_cube_xy([blockSize.x + endstopX, blockSize.y/2 - topInset, blockSize.z], fillet);
                    sizeY = blockSize.y/2 + tongueSize.y/2 + blockOffset.y - topInset;
                    translate([0, blockSize.y/2 - sizeY, 0]) {
                        rounded_cube_xy([blockSize.x + endstopX, sizeY, blockSize.z], fillet);
                        translate([blockSize.x, 0, 0])
                            rotate(270)
                                fillet(isMGN9C(yCarriageType) ? 2 : 4, blockSize.z);
                    }
                    translate([0, -blockSize.y/2, 0])
                        rounded_cube_xy([blockSize.x, blockSize.y - topInset, blockSize.z], fillet);
                } else {
                    translate([0, topInset, 0]) {
                        sizeY = blockSize.y/2 + tongueSize.y/2 + blockOffset.y - topInset;
                        difference() {
                            rounded_cube_xy([blockSize.x, blockSize.y - topInset, blockSize.z], fillet);
                            if (!isMGN9C(yCarriageType))
                                translate([blockSize.x, blockSize.y, -eps])
                                    rotate(180)
                                        fillet(5, blockSize.z + 2*eps);
                        }
                        *rounded_cube_xy([blockSize.x + endstopX, blockSize.y/2 - topInset, blockSize.z], fillet);
                        rounded_cube_xy([blockSize.x + endstopX, sizeY, blockSize.z], fillet);
                        if (isMGN9C(yCarriageType))
                            translate([blockSize.x, sizeY, 0])
                                fillet(2, blockSize.z);
                    }
                }
            }
            tongue(tongueSize, left);
            h = thickness + pulleyStackHeight(plainIdlerHeight, pulleyBore);
            if (isMGN9C(yCarriageType)) {
                if (left) {
                    size = [leftSupportLength, 7, h];
                    translate([plainPulleyPos.x - 3.25, -size.y/2, 0])
                        rounded_cube_xy(size, 3);
                    translate([blockSize.x/2 - blockOffset.x/2 + endstopX, size.y/2, 0])
                        fillet(1.5, thickness);
                    translate([blockSize.x/2 - blockOffset.x/2, -size.y/2, 0])
                        rotate(270)
                            fillet(1.5, thickness);
                } else {
                    size = [8.5, 15, h];
                    translate([toothedPulleyPos.x - 3.25, -size.y/2, 0])
                        rounded_cube_xy(size, 1.5);
                    if (yCarriageBraceThickness) {
                        size2 = [9, 9.5, h];
                        //translate([11.75 + 14 + 4.75 - size2.x, 3.5 - size.y/2, 0]) {
                        translate([19, 3.5 - size.y/2, 0]) {
                            rounded_cube_xy(size2, 1.5);
                            translate([-7.5, 0, 0])
                                cube([9, size2.y, thickness]);
                        }
                        translate([blockSize.x/2 - blockOffset.x/2 + endstopX, 3.5 -size.y/2, 0])
                            rotate(270)
                                fillet(1.5, thickness);
                    }
                }
            } else {
                if (left) {
                    size = pulley25 ? [22, 12.5, h] : [18, 10, h];
                    translate([plainPulleyPos.x - (pulley25 ? 4.5 : 5), tongueSize.y/2 - size.y, 0])
                        rounded_cube_xy(size, 1.5);
                    if (yCarriageBraceThickness) {
                        size2 = [7.5 + blockOffset.x - (pulley25 ? 2.5 : 0), tongueSize.y, h];
                        translate([-blockSize.x/2 - blockOffset.x/2, -size2.y/2, 0])
                            rounded_cube_xy(size2, 1.5);
                        if (pulley25)
                            tongue([size2.x + blockSize.x/2 - 3*blockOffset.x/2 + 12.15, tongueSize.y, thickness], left, 1.5);
                    }
                } else {
                    size = [pulley25 ? 9 : 8.5, tongueSize.y, h];
                    translate([toothedPulleyPos.x - (pulley25 ? 4.5 : 3.25), -size.y/2, 0])
                        rounded_cube_xy(size, 1.5);
                    if (yCarriageBraceThickness) {
                        size2 = [6.5, pulley25 ? 12 : 10.25, h];
                        translate([plainPulleyPos.x + (pulley25 ? 10.75 : 7), tongueSize.y/2 - size2.y, 0])
                            rounded_cube_xy(size2, 1.5);
                        tongue([size2.x + blockSize.x/2 - blockOffset.x/2 + (pulley25 ? 10.40 : 3.65), tongueSize.y, thickness], left, 1.5);
                        size3 = [8.5 + blockOffset.x - (pulley25 ? 2.5 : 0), tongueSize.y, h];
                        translate([-blockSize.x/2 - blockOffset.x/2, -size3.y/2, 0])
                            rounded_cube_xy(size3, 1.5);
                    }
                }
                /*size = [8.5, tongueSize.y, h];
                translate([toothedPulleyPos.x - 3.25, -size.y/2, 0])
                    rounded_cube_xy(size, 1.5);
                if (yCarriageBraceThickness) {
                    size3 = [12.1, 10.25, h];
                    translate([plainPulleyPos.x + 7, -3.25, 0])
                        rounded_cube_xy(size3, 1.5);
                    size2 = [8.5, size.y, h];
                    translate([-blockSize.x/2, -size2.y/2, 0])
                        rounded_cube_xy(size2, 1.5);
                }*/
            }
        } // end union
        yCarriageTongueBoltPositions(tongueOffset, xRailType, xRailLength)
            if (inserts)
                translate_z(tongueSize.z) {
                    vflip()
                        insertHoleM3(tongueSize.z);
                    boltHole(insert_outer_d(F1BM3), insert_length(F1BM3) + 0.2);
                }
            else
                boltHole(rail_hole(xRailType) < 3 ? 2*M2_tap_radius : 2*M3_tap_radius, thickness + (left ? 4 : 0), twist=4, cnc=cnc);
        if (inserts && left && pulley25)
            yCarriageTongueBoltPositions(tongueOffset, xRailType, xRailLength, 1)
                insertHoleM3(tongueSize.z);
        translate_z(thickness - carriage_height(yCarriageType))
            rotate(90)
                carriage_hole_positions(yCarriageType)
                    vflip()
                        boltHoleM3Counterbore(thickness, counterBore(thickness), cnc=cnc);
        holeDiameter = pulleyBore == 3 ? 2*M3_tap_radius : pulleyBore == 4 ? 2*M4_tap_radius : 2*M5_tap_radius;
        translate([left ? toothedPulleyPos.x : plainPulleyPos.x, toothedPulleyPos.y, 0])
            boltHole(holeDiameter, thickness, twist=4, cnc=cnc);
        translate([left ? plainPulleyPos.x : toothedPulleyPos.x, 0, 0])
            boltHole(holeDiameter, thickness + pulleyStackHeight(idlerHeight, pulleyBore), twist=4, cnc=cnc);
        if (isMGN9C(yCarriageType))
            for (x = [plainPulleyPos.x + boltOffsetMGN9(left)])
                translate([x, 0, thickness + pulleyStackHeight(idlerHeight, pulleyBore)])
                    vflip()
                        boltHole(holeDiameter, 12, twist=4, cnc=cnc);
        else
            for (x = left ? [-blockSize.x/2 + boltOffsetOuterMGN12(left, blockOffset.x), boltOffsetInnerMGN12(left, blockOffset.x), plainPulleyPos.x]
                          : [-blockSize.x/2 + boltOffsetOuterMGN12(left, blockOffset.x), boltOffsetInnerMGN12(left, blockOffset.x)])
                translate([x, 0, thickness + pulleyStackHeight(idlerHeight, pulleyBore)])
                    vflip()
                        boltHole(holeDiameter, 12, twist=4, cnc=cnc);
    } // end difference
}

module yCarriageBrace(yCarriageType, thickness, pulleyOffset, holeRadius, blockOffsetX=undef, left) {
    if (isMGN9C(yCarriageType)) {
        size = [leftSupportLength + 12.5, left ? 7 : 9.5, thickness];
        difference() {
            translate([-4.5, left ? -size.y/2 : -4, 0])
                rounded_cube_xy(size, left ? 3 : 1.5);
            for (x = [pulleyOffset.x, 11.15, 11.15 + boltOffsetMGN9(left)])
                translate([x, 0, 0])
                    boltHole(holeRadius*2, size.z, twist=4);
        }
    } else {
        size = left ? (is_undef(blockOffsetX) ? [40.65, 12, thickness] : [48.15 + blockOffsetX, 12.5, thickness])
                    : (is_undef(blockOffsetX) ? [41.15, 14, thickness] : [48.15 + blockOffsetX, 14, thickness]);
        blockSizeX = yCarriageBlockSizeX(yCarriageType);
        difference() {
            blockOffsetX = is_undef(blockOffsetX) ? 0 : blockOffsetX;
            translate([-blockSizeX/2 - blockOffsetX, left ? (blockOffsetX ? -5.5 : -5) : -size.y/2, 0])
                rounded_cube_xy(size, 1.5);
            for (x = [  0,
                        12.25 + pulleyOffset.x,
                        -blockSizeX/2 - blockOffsetX/2 + boltOffsetOuterMGN12(left, blockOffsetX),
                        boltOffsetInnerMGN12(left, blockOffsetX)
                    ])
                translate([x, 0, 0])
                    boltHole(holeRadius*2, size.z, twist=4);
        }
    }
}

module yCarriageBolts(yCarriageType, thickness) {
    assert(is_list(yCarriageType));

    // depth of holes in MGN9 and MGN12 carriages is approx 5mm. so 4.5mm leaves room for error
    carriageHoleDepth = 4.5;
    counterBore = counterBore(thickness);
    boltLength = screw_shorter_than(thickness - counterBore + carriageHoleDepth);
    //echo(boltLength=boltLength, counterBore=counterBore, cap=screw_head_height(M3_cap_screw),protrudes=boltLength-thickness+counterBore);

    rotate(90)
        translate_z(thickness - carriage_height(yCarriageType) - counterBore)
            carriage_hole_positions(yCarriageType)
                boltM3Caphead(boltLength);
}

module pulleyStack(pulley, explode=0) {
    washer = pulley_bore(pulley) == 3 ? M3_washer : pulley_bore(pulley) == 4 ? M4_washer : M5_washer;
    translate_z(-washer_thickness(washer) - pulley_height(pulley)/2)
        washer(washer)
            explode(explode)
                pulley(pulley);
    if ($children)
        translate_z(pulley_height(pulley)/2)
            children();
}

module yCarriagePulleys(yCarriageType, plainIdler, toothedIdler, thickness, yCarriageBraceThickness, plainIdlerOffset, toothedIdlerOffset, blockOffsetX, left) {
    pulleyBore = pulley_bore(plainIdler);
    washer =  pulleyBore == 3 ? M3_washer : pulleyBore == 4 ? M4_washer : M5_washer;
    bolt = pulleyBore == 3 ? M3_cap_screw : pulleyBore == 4 ? M4_cap_screw : M5_cap_screw;
    explode = yCarriageExplodeFactor();

    plainIdlerHeight = pulley_height(plainIdler);
    toothedIdlerHeight = pulley_height(toothedIdler);

    translate(plainPulleyPos(left, plainIdlerHeight, pulleyBore, plainIdlerOffset, thickness, yCarriageBraceThickness)) {
        explode(left ? 5*explode : explode, true)
            pulleyStack(plainIdler, explode=explode);
        translate_z(pulley_height(plainIdler)/2)
            if (left) {
                explode(6*explode, true)
                    bolt(bolt, screw_shorter_than(thickness + 2*pulleyStackHeight(plainIdlerHeight, pulleyBore) + yCarriageBraceThickness));
            } else {
                translate_z(yCarriageBraceThickness + washer_thickness(washer))
                    explode(4*explode, true)
                        bolt(bolt, screw_shorter_than(thickness + pulleyStackHeight(plainIdlerHeight, pulleyBore) + yCarriageBraceThickness));
                if (yCarriageBraceThickness)
                    explode(3*explode)
                        washer(washer);
            }
    }

    translate(toothedPulleyPos(left, toothedIdlerHeight, pulleyBore, toothedIdlerOffset, thickness, yCarriageBraceThickness)) {
        explode(left? explode : 5*explode, true)
            pulleyStack(toothedIdler, explode=explode);
        translate_z(pulley_height(plainIdler)/2)
            if (left) {
                translate_z(yCarriageBraceThickness + washer_thickness(washer))
                    explode(4*explode, true)
                        bolt(bolt, screw_shorter_than(thickness + pulleyStackHeight(toothedIdlerHeight, pulleyBore) + yCarriageBraceThickness));
                if (yCarriageBraceThickness)
                    explode(3*explode)
                        washer(washer);
            } else {
                explode(6*explode, true)
                    bolt(bolt, screw_shorter_than(thickness + 2*pulleyStackHeight(toothedIdlerHeight, pulleyBore) + yCarriageBraceThickness));
            }
    }

    if (yCarriageBraceThickness) {
        plainPulleyPos = plainPulleyPos(left, plainIdlerHeight, pulleyBore, plainIdlerOffset, thickness, yCarriageBraceThickness);
        blockSizeX = yCarriageBlockSizeX(yCarriageType);
        boltXPositions = isMGN9C(yCarriageType)
            ? [plainPulleyPos.x + boltOffsetMGN9(left)]
            : [-blockSizeX/2 - blockOffsetX/2 + boltOffsetOuterMGN12(left, blockOffsetX), boltOffsetInnerMGN12(left, blockOffsetX)];
        for (x = boltXPositions)
            translate([x, 0, thickness + pulleyStackHeight(plainIdlerHeight, pulleyBore) + yCarriageBraceThickness])
                explode(4*explode, true)
                    boltM3Caphead(10);
    }
}

module Y_Carriage_hardware(yCarriageType, plainIdler, toothedIdler, thickness, yCarriageBraceThickness, plainIdlerOffset, toothedIdlerOffset, left) {
    assert(is_list(yCarriageType));

    yCarriagePulleys(yCarriageType, plainIdler, toothedIdler, thickness, yCarriageBraceThickness, plainIdlerOffset, toothedIdlerOffset, 0, left);
    explode(15)
        yCarriageBolts(yCarriageType, thickness);
}

module Y_Carriage_inserts(yCarriageType, tongueOffset, xRailType, xRailLength, thickness) {
    yCarriageTongueBoltPositions(tongueOffset, xRailType, xRailLength)
        translate_z(thickness)
            _threadedInsertM3();
}
