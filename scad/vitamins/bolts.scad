include <NopSCADlib/core.scad>
use <NopSCADlib/utils/hanging_hole.scad>



// Utilities

//function _twist(radius, twist) = radius > M3_tap_radius || $preview ? 0 : is_undef(twist) ? 0 : twist;
function _twist(radius, twist) = $preview ? 0 : is_undef(twist) ? (radius > M3_tap_radius ? 0 : 3) : twist;


// bolt holes

module boltHole(diameter, length, horizontal = false, rotate = 0, chamfer = 0, twist = 0, chamfer_both_ends = true, cnc=false) {
    //echo(twist=twist);
    //echo(_twist=_twist(diameter/2, twist));
    translate_z(-eps)
        if (cnc)
            cylinder(r = diameter/2, h = length + 2*eps);
        else if (horizontal)
            rotate(rotate)
                teardrop(length + 2*eps, diameter/2, center=false, chamfer=chamfer, chamfer_both_ends = chamfer_both_ends);

        else
            poly_cylinder(r = diameter/2, h = length + 2*eps, twist = _twist(diameter/2, twist));
}

module boltHoleCounterbore(screw_type, length, boreDepth=undef, boltHeadTolerance=0, horizontal=false, cnc=false) {
    boltHole(2*screw_head_radius(screw_type) + boltHeadTolerance, is_undef(boreDepth) ? screw_head_height(screw_type) : boreDepth, horizontal=horizontal, cnc=cnc);
    boltHole(2*screw_clearance_radius(screw_type), length, horizontal=horizontal, cnc=cnc);
}

module boltHoleHangingCounterbore(screw_type, length, boreDepth = undef, boltHeadTolerance = 0) {
    hanging_hole(is_undef(boreDepth) ? screw_head_height(screw_type) : boreDepth, ir = screw_clearance_radius(screw_type), h = length)
        poly_circle(r = screw_head_radius(screw_type) + boltHeadTolerance);
}

module boltHoleHangingCounterboreTap(screw_type, length) {
    hanging_hole(screw_head_height(screw_type), ir = screw_pilot_hole(screw_type), h = length)
        poly_circle(r = screw_head_radius(screw_type));
}


// M2 bolt holes

module boltHoleM2(length, horizontal = false, rotate = 0, chamfer = 0.5, twist = undef, chamfer_both_ends = true) {
    boltHole(M2_clearance_radius*2, length, horizontal, rotate, chamfer, twist, chamfer_both_ends = chamfer_both_ends);
}

module boltHoleM2Tap(length, horizontal = false, rotate = 0, chamfer = 0.5, twist = undef, chamfer_both_ends = true, cnc=false) {
    boltHole(M2_tap_radius*2, length, horizontal, rotate, chamfer, twist, chamfer_both_ends = chamfer_both_ends, cnc=cnc);
}


// M2p5 bolt holes

module boltHoleM2p5(length, horizontal = false, rotate = 0, chamfer = 0.5, twist = undef, chamfer_both_ends = true) {
    boltHole(M2p5_clearance_radius*2, length, horizontal, rotate, chamfer, twist, chamfer_both_ends = chamfer_both_ends);
}

module boltHoleM2p5Tap(length, horizontal = false, rotate = 0, chamfer = 0.5, twist = undef, chamfer_both_ends = true, cnc=false) {
    boltHole(M2_tap_radius*2, length, horizontal, rotate, chamfer, twist, chamfer_both_ends = chamfer_both_ends, cnc = cnc);
}


// M3 bolt holes

module boltHoleM3(length, horizontal = false, rotate = 0, chamfer = 0.5, twist = undef, chamfer_both_ends = true) {
    boltHole(M3_clearance_radius*2, length, horizontal, rotate, chamfer, twist, chamfer_both_ends = chamfer_both_ends);
}

module boltHoleM3Tap(length, horizontal = false, rotate = 0, chamfer = 0.5, twist = undef, chamfer_both_ends = true, cnc=false) {
    boltHole(M3_tap_radius*2, length, horizontal, rotate, chamfer, twist, chamfer_both_ends = chamfer_both_ends, cnc = cnc);
}

module boltPolyholeM3Countersunk(length) {
    translate_z(layer_height)
        screw_polysink(M3_cs_cap_screw, 2*length + 2*eps);
}

module boltHoleM3Counterbore(length, boreDepth=undef, boltHeadTolerance = 0, horizontal=false, cnc=false) {
    boltHoleCounterbore(M3_cap_screw, length, boreDepth, boltHeadTolerance, horizontal=horizontal, cnc=cnc);
}

module boltHoleM3CounterboreButtonhead(length, boreDepth=undef, boltHeadTolerance = 0.4, horizontal=false, cnc=false) {
    boltHoleCounterbore(M3_dome_screw, length, boreDepth, boltHeadTolerance, horizontal=horizontal, cnc=cnc);
}

module boltHoleM3HangingCounterbore(length) {
    boltHoleHangingCounterbore(M3_cap_screw, length);
}

module boltHoleM3HangingCounterbore(length, boreDepth=undef, boltHeadTolerance = 0) {
    boltHoleHangingCounterbore(M3_cap_screw, length=length, boreDepth=boreDepth, boltHeadTolerance=boltHeadTolerance);
}

module boltHoleM3HangingCounterboreTap(length) {
    boltHoleHangingCounterboreTap(M3_cap_screw, length);
}


// M4 bolt holes

module boltHoleM4(length, horizontal = false, rotate = 0, chamfer = 0.5, twist = 0, chamfer_both_ends = true) {
    boltHole(M4_clearance_radius*2, length, horizontal, rotate, chamfer, twist, chamfer_both_ends = chamfer_both_ends);
}

module boltHoleM4Tap(length, horizontal = false, rotate = 0, chamfer = 0.5, twist = 0, chamfer_both_ends = true) {
    boltHole(M4_tap_radius*2, length, horizontal, rotate, chamfer, twist, chamfer_both_ends = chamfer_both_ends);
}

module boltPolyholeM4Countersunk(length, offset=0) {
    translate_z(offset) //offset should be a multiple of layer_height
        screw_polysink(M4_cs_cap_screw, 2*length + 2*eps);
}

module boltHoleM4CounterboreButtonhead(length, boreDepth=undef, boltHeadTolerance = 0.4, horizontal=false, cnc=false) {
    boltHoleCounterbore(M4_dome_screw, length=length, boreDepth=boreDepth, boltHeadTolerance=boltHeadTolerance, horizontal=horizontal, cnc=cnc);
}

module boltHoleM4HangingCounterboreButtonhead(length, boreDepth, boltHeadTolerance = 0.4) {
    boltHoleHangingCounterbore(M4_dome_screw, length=length, boreDepth=boreDepth, boltHeadTolerance=boltHeadTolerance);
}


// M5 bolt holes

module boltHoleM5(length, horizontal = false, rotate = 0, chamfer = 0.5, twist = 0, chamfer_both_ends = true) {
    boltHole(M5_clearance_radius*2, length, horizontal, rotate, chamfer, twist, chamfer_both_ends = chamfer_both_ends);
}

module boltHoleM5Tap(length, horizontal = false, rotate = 0, chamfer = 0.5, twist = 0, chamfer_both_ends = true) {
    boltHole(M5_tap_radius*2, length, horizontal, rotate, chamfer, twist, chamfer_both_ends = chamfer_both_ends);
}

module boltPolyholeM5Countersunk(length) {
    translate_z(layer_height)
        screw_polysink(M5_cs_cap_screw, 2*length + 2*eps);
}


// M6 bolt holes

module boltHoleM6(length, horizontal = false, rotate = 0, chamfer = 0.5, twist = 0, chamfer_both_ends = true) {
    boltHole(M6_clearance_radius*2, length=length, horizontal=horizontal, rotate=rotate, chamfer=chamfer, twist=twist, chamfer_both_ends = chamfer_both_ends);
}

module boltHoleM6Counterbore(length, boreDepth=undef, boltHeadTolerance = 0, cnc=false) {
    boltHoleCounterbore(M6_cap_screw, length=length, boreDepth=boreDepth, boltHeadTolerance=boltHeadTolerance, cnc=cnc);
}


// Bolts

module bolt(type, length) {
    if ($preview && (is_undef($hide_bolts) || $hide_bolts == false))
        screw(type, length);
}


module boltM2Caphead(length) {
    bolt(M2_cap_screw, length);
}


module boltM2p5Caphead(length) {
    bolt(M2p5_cap_screw, length);
}


module boltM3Caphead(length) {
    bolt(M3_cap_screw, length);
}

module boltM3Countersunk(length, boreDepth=undef) {
    translate_z(is_undef(boreDepth) ? 0 : boreDepth)
        bolt(M3_cs_cap_screw, length);
}

module boltM3Buttonhead(length) {
    bolt(M3_dome_screw, length);
}

module boltM3Panhead(length) {
    bolt(M3_pan_screw, length);
}


module boltM4Caphead(length) {
    bolt(M4_cap_screw, length);
}

module boltM4Countersunk(length, boreDepth=undef) {
    translate_z(is_undef(boreDepth) ? 0 : boreDepth)
        bolt(M4_cs_cap_screw, length);
}

module boltM4Buttonhead(length) {
    bolt(M4_dome_screw, length);
}


module boltM5Caphead(length) {
    bolt(M5_cap_screw, length);
}

module boltM5Countersunk(length, boreDepth=undef) {
    translate_z(is_undef(boreDepth)  ? 0 : boreDepth)
        bolt(M5_cs_cap_screw, length);
}

module boltM5Buttonhead(length) {
    bolt(M5_dome_screw, length);
}


module boltM6Caphead(length) {
    bolt(M6_cap_screw, length);
}

module boltM6Buttonhead(length) {
    bolt(M6_dome_screw, length);
}
