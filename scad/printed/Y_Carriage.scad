
include <../config/global_defs.scad>

use <NopSCADlib/utils/fillet.scad>

include <../vitamins/bolts.scad>

include <NopSCADlib/vitamins/ball_bearings.scad>
include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/vitamins/rails.scad>

include <../vitamins/inserts.scad>

M4_shim = ["M4_shim",          4,   9,   0.5, false,  undef,  undef, undef, undef];
M5_shim = ["M5_shim",          5,  10,   0.5, false,  undef,  undef, undef, undef];

function isMGN9C(carriageType) = carriageType[0] == MGN9C_carriage[0];

// When using standard belts the inside idler is plain and the outside idler is toothed.
// When using reversed belts the inside idler is toothed and the outside idler is plain.
function pulleyStackHeight(pulleyHeight, pulleyBore) = pulleyHeight + 2*washer_thickness(pulleyBore == 3 ? M3_washer : pulleyBore == 4 ? M4_shim : M5_shim);
function plainPulleyPos(left, pulleyHeight, pulleyBore, pulleyOffset, thickness, yCarriageBraceThickness) = [pulleyOffset.x + 12.15, pulleyOffset.y, thickness + pulleyStackHeight(pulleyHeight, pulleyBore)/2 + (left ? pulleyStackHeight(pulleyHeight, pulleyBore) + yCarriageBraceThickness : 0)];
function toothedPulleyPos(left, pulleyHeight, pulleyBore, pulleyOffset, thickness, yCarriageBraceThickness) = [pulleyOffset.x, pulleyOffset.y, thickness + pulleyStackHeight(pulleyHeight, pulleyBore)/2 + (left ? 0 : pulleyStackHeight(pulleyHeight, pulleyBore) + yCarriageBraceThickness)];

function railFirstHoleOffset(type, length) = (length - (rail_holes(type, length) - 1)*rail_pitch(type))/2;

// allow adjustment of counterbore to optimise bolt length
function counterBore(thickness) = screw_head_height(M3_cap_screw) + max(thickness - 9, 0);
function yCarriageBlockSizeX(yCarriageType) = carriage_width(yCarriageType) + 4;
function yCarriageExplodeFactor() = 5;
function yCarriageTongueThickness(yCarriageType, chamfer=0) = isMGN9C(yCarriageType) ? 6.5 - chamfer : 6.5;

function leftSupportLength(reversedBelts) = reversedBelts ? 10 : 17;
function boltOffsetMGN9(left, reversedBelts) = left ? leftSupportLength(reversedBelts) - 6.5 : 10;
function boltOffsetInnerMGN12(left, blockOffsetX) = blockOffsetX ? 29 : 21;
function boltOffsetOuterMGN12(left, blockOffsetX) = (blockOffsetX ? (left ? 2.5 : 5) : 3);


module yCarriageTongueBoltPositions(tongueOffset, xRailType, xRailLength, screws=2) {
    translate([tongueOffset + xRailLength/2, 0, 0])
        rail_hole_positions(xRailType, xRailLength, screws=screws, both_ends=false)
            children();
}

module Y_Carriage(yCarriageType, idlerHeight, pulleyBore, xRailType, xRailLength, thickness, chamfer, yCarriageBraceThickness, blockOffset, endStopOffsetX, tongueOffset, plainIdlerOffset, toothedIdlerOffset, topInset=0, inserts=false, reversedBelts=false, left=true, cnc=false) {
    assert(is_list(yCarriageType));
    assert(is_list(xRailType));
    assert(pulleyBore == 3 || pulleyBore == 4 || pulleyBore == 5);

    plainIdlerHeight = idlerHeight;
    toothedIdlerHeight = idlerHeight;

    fillet = isMGN9C(yCarriageType) ? 1.5 : 2.5;
    leftExtraClearance = isMGN9C(yCarriageType) ? 0 : 1;
    blockOffset =  is_list(blockOffset) ? blockOffset : [0, blockOffset];

    blockSize = [yCarriageBlockSizeX(yCarriageType) + blockOffset.x, carriage_length(yCarriageType) + 1 + 2*blockOffset.y, thickness];
    rightInset = topInset == 0 ? 0 : 2;
    railFirstHoleOffset = railFirstHoleOffset(xRailType, xRailLength);
    tongueSize = [tongueOffset + railFirstHoleOffset + rail_pitch(xRailType) + rail_width(xRailType)/2 + 0.5, rail_width(xRailType) + 2, yCarriageTongueThickness(yCarriageType, chamfer)];
    extraY = isMGN9C(yCarriageType) ? 0 : 2;

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

    module tongue(tongueSize, left, tFillet=4, endFillet=fillet) {
        // add rail_width/2 to tongueSize.x to give a bit of extra length to the tongue for wider rails
        translate([0, -tongueSize.y/2 - (left ? 0 : extraY), 0])
            chamfered_rounded_cube(tongueSize + [0, extraY, 0], endFillet, chamfer);

        //endStopSize = [tongueOffset + endStopOffsetX, tongueSize.y + (left ? 5.5 : 11), tongueSize.z];
        //translate([0, -(endStopSize.y - tongueSize.y), 0])
        //    rounded_cube_xy(endStopSize, fillet);
        fillet = isMGN9C(yCarriageType) ? 2 : tFillet;
        filletE = fillet;//endStopOffsetX == 0 ? fillet : 1;
        xPos = blockSize.x/2 - blockOffset.x/2;
        xPosE = endStopOffsetX == 0 ? xPos : tongueOffset + endStopOffsetX;
        if (left) {
            translate([xPosE, tongueSize.y/2 + extraY, chamfer])
                fillet(filletE, tongueSize.z - 2*chamfer);
            translate([xPos - leftExtraClearance, -tongueSize.y/2, chamfer])
                rotate(-90)
                    fillet(fillet, tongueSize.z - 2*chamfer);
        } else {
            translate([xPosE, -tongueSize.y/2 - extraY, chamfer])
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
            endstopX1 = tongueOffset - blockSize.x/2 + blockOffset.x/2 + (isMGN9C(yCarriageType) ? endStopOffsetX : 10.15);
            translate([-blockSize.x/2 - blockOffset.x/2, left ? blockOffset.y : -blockSize.y/2 - blockOffset.y, 0]) {
                // inset the block to avoid possible interference with the idler pulleys
                if (left) {
                    rounded_cube_xy([blockSize.x + endstopX1, blockSize.y/2, blockSize.z - (isMGN9C(yCarriageType) ? 1 : 0)], fillet);
                    *rounded_cube_xy([blockSize.x + endstopX, blockSize.y/2 - topInset, blockSize.z], fillet);
                    sizeY = blockSize.y/2 + tongueSize.y/2 + blockOffset.y - topInset;
                    translate([0, blockSize.y/2 - sizeY, 0]) {
                        rounded_cube_xy([blockSize.x + endstopX1, sizeY, blockSize.z], fillet);
                        rounded_cube_xy([blockSize.x + endstopX, sizeY, tongueSize.z], fillet);
                        translate([blockSize.x - leftExtraClearance, 0, 0])
                            rotate(270)
                                fillet(isMGN9C(yCarriageType) ? 2 : 4, blockSize.z);
                    }
                    translate([0, -blockSize.y/2, 0])
                        rounded_cube_xy([blockSize.x - leftExtraClearance, blockSize.y - topInset, blockSize.z], fillet);
                } else {
                    rounded_cube_xy([blockSize.x + endstopX, blockSize.y/2, blockSize.z], fillet);
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
                    size = [leftSupportLength(reversedBelts), 7, h];
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
                        size2 = [6, 9.5, h];
                        //translate([11.75 + 14 + 4.75 - size2.x, 3.5 - size.y/2, 0]) {
                        translate([18.5, 3.5 - size.y/2, 0]) {
                            rounded_cube_xy(size2, 1.5);
                            translate([-5.5, 0, 0])
                                cube([9, size2.y, thickness]);
                        }
                        translate([blockSize.x/2 - blockOffset.x/2 + endstopX, 3.5 -size.y/2, 0])
                            rotate(270)
                                fillet(1.5, thickness);
                    }
                }
            } else {
                if (left) {
                    // this cube needs to be small enough in y dimension to give clearance for plain side of belt
                    size = [18 + (reversedBelts ? -plainIdlerOffset.x - 1.5 : 0), 10 + (pulleyBore==4 ? 1.0 : 0), h];
                    translate([plainPulleyPos.x - (reversedBelts ? 4 : 5), reversedBelts ? -tongueSize.y/2 : tongueSize.y/2 - size.y, 0])
                        rounded_cube_xy(size, 1.5);
                    if (yCarriageBraceThickness) {
                        // outside cube to support brace
                        size2 = [6.5 + blockOffset.x, tongueSize.y, h];
                        translate([-blockSize.x/2 - blockOffset.x/2, -size2.y/2, 0])
                            rounded_cube_xy(size2, 1.5);
                    }
                } else {
                    size = [7.5 + plainIdlerOffset.x, tongueSize.y, h];
                    fillet = 1.5;
                    translate([toothedPulleyPos.x - 3.25, -size.y/2, 0])
                        rounded_cube_xy(size, fillet);
                    if (yCarriageBraceThickness) {
                        // this cube needs to be small enough in y dimension to give clearance for toothed side of belt
                        size2 = [6, 12, h];
                        translate([plainPulleyPos.x+7, reversedBelts ? -tongueSize.y/2 - extraY : tongueSize.y/2 - size2.y, 0])
                            rounded_cube_xy(size2, fillet);
                        tongue([size2.x + blockSize.x/2 - blockOffset.x/2 + 3.65 + plainIdlerOffset.x, tongueSize.y, thickness], left, endFillet=fillet);
                        size3 = [6.5 + blockOffset.x, tongueSize.y, h];
                        translate([-blockSize.x/2 - blockOffset.x/2, -size3.y/2, 0])
                            rounded_cube_xy(size3, fillet);
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
                    // cutout for clearance to allow insert to be inserted during assembly
                    boltHole(insert_outer_d(F1BM3) + 1, pulleyStackHeight(idlerHeight, pulleyBore) + thickness - tongueSize.z, cnc=true);
                }
            else
                boltHole(rail_hole(xRailType) < 3 ? 2*M2_tap_radius : 2*M3_tap_radius, thickness - 1, twist=4, cnc=cnc);
        translate_z(thickness - carriage_height(yCarriageType))
            rotate(90)
                carriage_hole_positions(yCarriageType)
                    vflip()
                        boltHoleM3Counterbore(thickness, counterBore(thickness), cnc=cnc);
        // use shoulder bolts for pulleyBore 4 and above
        // previously set holeDiameter as 2*M3_tap_radius for pulleyBore==4, using should bolts, but they did not have sufficient purchase for tightening
        holeDiameter = pulleyBore == 3 ? 2*M3_tap_radius : pulleyBore == 4 ? 2*M4_tap_radius : 2*M4_tap_radius;
        translate([left ? toothedPulleyPos.x : plainPulleyPos.x, left ? toothedPulleyPos.y : plainPulleyPos.y, 0]) {
            boltHole(holeDiameter, thickness, twist=4, cnc=cnc);
            if (pulleyBore == 4 && holeDiameter < 2*M4_tap_radius) {
                translate_z(thickness + 1.5 + pulleyStackHeight(idlerHeight, pulleyBore))
                    vflip()
                        boltHole(4, 12, twist=4, cnc=cnc);// use 12mm shoulder bolt for pulleyBore 4
            }
        }
        translate([left ? plainPulleyPos.x : toothedPulleyPos.x, left ? plainPulleyPos.y : toothedPulleyPos.y, 0]) {
            boltHole(holeDiameter, thickness + pulleyStackHeight(idlerHeight, pulleyBore), twist=4, cnc=cnc);
            if (pulleyBore == 4 && holeDiameter < 2*M4_tap_radius) {
                translate_z(thickness + 0.5 + 2*pulleyStackHeight(idlerHeight, pulleyBore))
                    rotate([180, 0, 22.5]) // rotate bolthole to maximise wall thickness
                        boltHole(4, 20, twist=0, cnc=cnc);// use 20mm shoulder bolt for pulleyBore 4
            }
        }
        translate_z(thickness + pulleyStackHeight(idlerHeight, pulleyBore))
            if (isMGN9C(yCarriageType))
                translate([plainPulleyPos.x + boltOffsetMGN9(left), 0, 0])
                    vflip()
                        boltHoleM3Tap(12, twist=4, cnc=cnc);
            else
                yCarriageBraceBoltPositionsMGN12(blockSize.x, blockOffset.x, left)
                    vflip()
                        boltHoleM3Tap(12, twist=4, cnc=cnc);
    } // end difference
}

module yCarriageBraceBoltPositionsMGN12(blockSizeX, blockOffsetX, left) {
    translate([-blockSizeX/2 + boltOffsetOuterMGN12(left, blockOffsetX), 0, 0])
        children();
    translate([boltOffsetInnerMGN12(left, blockOffsetX) + (left ? 0.5 : 0.75), left ? 0 : -1.5, 0])
        children();
}

module yCarriageBraceMGN9C(thickness, plainPulleyOffset, boltHoleRadius, reversedBelts, left) {
    difference() {
        if (left) {
            size = [leftSupportLength(reversedBelts) + 12.5, 7, thickness];
            translate([-4.5, -size.y/2, 0])
                rounded_cube_xy(size, 3);
        } else {
            size = [28.75, 9.5, thickness]; // was 32.5, so diff rom 32.25, saves 3.5
            translate([-4.25, -4, 0]) //was4.5
                rounded_cube_xy(size, 1.5);
        }
        for (x = [plainPulleyOffset.x, 11.15, 11.15 + boltOffsetMGN9(left)])
            translate([x, 0, 0])
                boltHole(boltHoleRadius*2, thickness, twist=4);
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
    function bearingStackHeight(bearingType=BBF623, washer=M3_washer) = 3*washer_thickness(washer) + 2*bb_width(bearingType);

    if (pulley[0] == "F623" || pulley[0] == "F684" || pulley[0] == "F694" || pulley[0] == "F695") {
        bearingType = pulley;
        pulleyBore = bb_bore(bearingType);
        washer = pulleyBore == 3 ? M3_washer : pulleyBore == 4 ? M4_shim : M5_shim;
        translate_z(-3*washer_thickness(washer)/2 - bb_width(bearingType)) {
            washer(washer);
            translate_z(washer_thickness(washer) + bb_width(bearingType)/2) {
                explode(explode)
                    ball_bearing(bearingType);
                explode(1.5*explode)
                    translate_z(bb_width(bearingType)/2)
                        washer(washer);
                explode(2*explode)
                    translate_z(bb_width(bearingType) + washer_thickness(washer))
                        vflip()
                            ball_bearing(bearingType);
            }
        }
        if ($children)
            translate_z(bearingStackHeight(bearingType, washer))
                children();
    } else {
        pulleyBore = pulley_bore(pulley);
        washer = pulleyBore == 3 ? M3_washer : pulleyBore == 4 ? M4_shim : M5_shim;
        translate_z(-washer_thickness(washer) - pulley_height(pulley)/2)
            washer(washer)
                explode(3*explode/2)
                    pulley(pulley);
        if ($children)
            translate_z(pulley_height(pulley)/2)
                children();
    }
}

module pulleyBolt(bolt, boltLength, washer, pulleyBore, explode) {
    if (pulleyBore==4)
        explode(explode, true)
            washer(washer)
                explode(explode, true)
                    washer(washer)
                        bolt(bolt, boltLength);
    else
        bolt(bolt, boltLength);
}

module yCarriagePulleys(yCarriageType, plainIdler, toothedIdler, thickness, yCarriageBraceThickness, plainIdlerOffset, toothedIdlerOffset, blockOffsetX, left) {
    isBearing = plainIdler[0] == "F623" || plainIdler[0] == "F684" || plainIdler[0] == "F694" || plainIdler[0] == "F695";
    pulleyBore = isBearing ? bb_bore(plainIdler) : pulley_bore(plainIdler);
    washer =  pulleyBore == 3 ? M3_washer : pulleyBore == 4 ? M4_shim : M5_shim;
    bolt = pulleyBore == 3 ? M3_cap_screw : pulleyBore == 4 ? M4_cap_screw : M5_cap_screw;
    explode = yCarriageExplodeFactor();

    plainIdlerHeight = isBearing ? 2*bb_width(plainIdler) + washer_thickness(washer) : pulley_height(plainIdler);
    toothedIdlerHeight = isBearing ? 2*bb_width(toothedIdler) + washer_thickness(washer)  : pulley_height(toothedIdler);

    translate(plainPulleyPos(left, plainIdlerHeight, pulleyBore, plainIdlerOffset, thickness, yCarriageBraceThickness)) {
        explode(left ? 6*explode : explode, true)
            pulleyStack(plainIdler, explode=explode);
        translate_z(plainIdlerHeight/2) {
            length = thickness + (left ? 2 : 1)*pulleyStackHeight(toothedIdlerHeight, pulleyBore) + yCarriageBraceThickness + washer_thickness(washer);
            boltLength = screw_shorter_than(length);
            if (left) {
                explode(8*explode, true)
                    pulleyBolt(bolt, boltLength, washer, pulleyBore, explode);
            } else {
                translate_z(yCarriageBraceThickness + washer_thickness(washer))
                    explode(5*explode, true)
                        pulleyBolt(bolt, boltLength, washer, pulleyBore, explode);
                if (yCarriageBraceThickness)
                    explode(4*explode)
                        washer(washer);
            }
        }
    }

    translate(toothedPulleyPos(left, toothedIdlerHeight, pulleyBore, toothedIdlerOffset, thickness, yCarriageBraceThickness)) {
        explode(left? explode : 6*explode, true)
            pulleyStack(toothedIdler, explode=explode);
        translate_z(plainIdlerHeight/2) {
            length = thickness + (left ? 1 : 2)*pulleyStackHeight(toothedIdlerHeight, pulleyBore) + yCarriageBraceThickness + washer_thickness(washer);
            boltLength = screw_shorter_than(length);
            if (left) {
                translate_z(yCarriageBraceThickness + washer_thickness(washer))
                    explode(5*explode, true)
                        pulleyBolt(bolt, boltLength, washer, pulleyBore, explode);
                if (yCarriageBraceThickness)
                    explode(4*explode)
                        washer(washer);
            } else {
                explode(8*explode, true)
                    pulleyBolt(bolt, boltLength, washer, pulleyBore, explode);
            }
        }
    }

    if (yCarriageBraceThickness) {
        plainPulleyPos = plainPulleyPos(left, plainIdlerHeight, pulleyBore, plainIdlerOffset, thickness, yCarriageBraceThickness);
        blockSizeX = yCarriageBlockSizeX(yCarriageType);
        translate_z(thickness + pulleyStackHeight(plainIdlerHeight, pulleyBore) + yCarriageBraceThickness)
            if (isMGN9C(yCarriageType))
                translate([plainPulleyPos.x + boltOffsetMGN9(left), 0, 0])
                    explode(4*explode, true)
                        boltM3Caphead(8);
            else
                yCarriageBraceBoltPositionsMGN12(blockSizeX, 0, left)
                    explode(4*explode, true)
                        boltM3Caphead(8);
    }
}

module Y_Carriage_hardware(yCarriageType, plainIdler, toothedIdler, thickness, yCarriageBraceThickness, plainIdlerOffset, toothedIdlerOffset, left) {
    assert(is_list(yCarriageType));

    yCarriagePulleys(yCarriageType, plainIdler, toothedIdler, thickness, yCarriageBraceThickness, plainIdlerOffset, toothedIdlerOffset, 0, left);
    explode(-5, show_line=false)
        yCarriageBolts(yCarriageType, thickness);
}

module Y_Carriage_inserts(yCarriageType, tongueOffset, xRailType, xRailLength, thickness) {
    yCarriageTongueBoltPositions(tongueOffset, xRailType, xRailLength)
        translate_z(thickness)
            _threadedInsertM3();
}
