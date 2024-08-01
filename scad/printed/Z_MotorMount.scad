include <../config/global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/utils/fillet.scad>
use <NopSCADlib/utils/rounded_triangle.scad>
include <NopSCADlib/vitamins/shaft_couplings.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
use <NopSCADlib/vitamins/wire.scad>

include <../utils/HolePositions.scad>
include <../utils/motorTypes.scad>

include <../vitamins/bolts.scad>
include <../vitamins/CorkDamper.scad>
include <../vitamins/leadscrew.scad>

include <../config/Parameters_Main.scad>


//                                              corner  body    boss    boss          shaft
//                                side  length  radius  radius  radius  depth  shaft  length       holes  cap heights
NEMA17_20 =     ["NEMA17_20",     42.3,   20,   53.6/2, 25,     11,     2,     5,     20.5,        31,    [10,    8], 3,     false, false, 0,       0];
NEMA17_34L150 = ["NEMA17_34L150", 42.3,   34,   53.6/2, 25,     11,     2,     8,     [150, 8, 2], 31,    [8,     8], 3,     false, false, 0,       0];
NEMA17_34L200 = ["NEMA17_34L200", 42.3,   34,   53.6/2, 25,     11,     2,     8,     [200, 8, 2], 31,    [8,     8], 3,     false, false, 0,       0];
NEMA17_40L150 = ["NEMA17_40L150", 42.3,   40,   53.6/2, 25,     11,     2,     8,     [150, 8, 2], 31,    [8,     8], 3,     false, false, 0,       0];
NEMA14_L150 =   ["NEMA14_L150",   35.2,   36,   46.4/2, 21,     11,     2,     5,     [150, 5, 2], 26,    [8,     8], 3,     false, false, 0,       0];


function zMotorType() = motorType(_zMotorDescriptor);

function NEMA17_34L() = NEMA17_34L;
function NEMA17_40L() = NEMA17_40L;


module Z_Motor_Mount_stl() {
    stl("Z_Motor_Mount")
        color(pp2_colour)
            vflip()
                Z_MotorMount(zMotorType(), cf=true);
}

/*
module NEMA_MotorWithIntegratedLeadScrew(NEMA_type, leadScrewLength, leadScrewDiameter=8) {
    vitamin(str("NEMA_MotorWithIntegratedLeadScrew(", NEMA_type, "): Stepper motor NEMA14 with integrated ", leadScrewLength, "mm lead screw"));

    assert(isNEMAType(NEMA_type));

    not_on_bom()
        if (is_list(NEMA_shaft_length(NEMA_type)))
            NEMA(NEMA_type, jst_connector=true);
        else
            no_explode() {
                NEMA(NEMA_type, jst_connector=true);
                translate_z(leadScrewLength/2)
                    leadscrewX(leadScrewDiameter, leadScrewLength);
            }
}
*/

zMotorMountTopPlateThickness = 5;
braceWidth = 4.5;
backHoleOffset = 8;

function Z_MotorMountSize(NEMA_type, braceWidth=5, topPlateThickness=zMotorMountTopPlateThickness) = [
    NEMA_width(NEMA_type)/2 + _zLeadScrewOffset,
    NEMA_width(NEMA_type) + 2*braceWidth + 1,
    topPlateThickness
];

function Z_MotorMountHeightX(NEMA_type, topPlateThickness=zMotorMountTopPlateThickness) = NEMA_length(NEMA_type) + 1.0 + topPlateThickness;
function Z_MotorMountHeight(NEMA_type, topPlateThickness=zMotorMountTopPlateThickness) = NEMA_length(NEMA_type) + 1.0 + topPlateThickness + _corkDamperThickness;

module Z_MotorMountHolePositions(NEMA_type) {
    height = Z_MotorMountHeight(NEMA_type) - zMotorMountTopPlateThickness/2;
    size = Z_MotorMountSize(NEMA_type, braceWidth, zMotorMountTopPlateThickness);

    for (x = [(size.y - backHoleOffset)/2, -(size.y - backHoleOffset)/2])
        translate([eX/2 + eSizeX + x, height])
            children();
}

module Z_MotorMount(NEMA_type, topPlateThickness = zMotorMountTopPlateThickness, corkDamperThickness=_corkDamperThickness, cf=false) {
    assert(isNEMAType(NEMA_type));

    NEMA_width = NEMA_width(NEMA_type);

    size = Z_MotorMountSize(NEMA_type, braceWidth, topPlateThickness);
    backThickness = NEMA_width > 40 ? 0 : 3;
    fillet = _fillet;

    height = Z_MotorMountHeight(NEMA_type) - topPlateThickness;

    translate_z(height) {
        difference() {
            union() {
                translate([-size.x + NEMA_width/2, -size.y/2])
                    union() {
                        if (cf)
                            rounded_cube_xy(size, fillet);
                        else
                            rounded_cube_yz(size, fillet);
                        if (backThickness)
                            translate_z(-height)
                                cube([backThickness, size.y, height + size.z], center=false);
                    }
                // braces
                for (y = [size.y/2 - braceWidth/2, -size.y/2 + braceWidth/2])
                    translate([-size.x + backThickness + NEMA_width/2, y, 2*fillet])
                        rotate([-90, 0, 0]) {
                            rounded_right_triangle(size.x - backThickness - 2*fillet, height, braceWidth, fillet);
                            translate_z(-braceWidth/2)
                                if (cf)
                                    rounded_cube_xz([8, height + 2*fillet, braceWidth], fillet);
                                else
                                    rounded_cube_yz([8, height + 2*fillet, braceWidth], fillet);
                        }
            }// end union

            translate_z(-eps)
                rotate(-90)
                    if (cf)
                        poly_cylinder(h=topPlateThickness + 2*eps, r=NEMA_boss_radius(NEMA_type) + 1.0);
                    else
                        teardrop(topPlateThickness + 2*eps, NEMA_boss_radius(NEMA_type) + 1.0, center=false, chamfer=0.5);
            translate_z(topPlateThickness)
                NEMA_screw_positions(NEMA_type)
                    rotate([180, 0, 90])
                        if (cf)
                            boltHoleM3Countersunk(topPlateThickness);
                        else
                            boltHoleM3(topPlateThickness, chamfer=0.5, horizontal=true);

            // boltHoles to connect to the base
            for (y = [size.y/2 - braceWidth/2, -size.y/2 + braceWidth/2])
                translate([-size.x + backThickness + NEMA_width/2 +baseBackHoleOffset().y, y, -height])
                    boltHoleM3Tap(10, horizontal=!cf, rotate=270, chamfer_both_ends=false);

            // boltHoles to connect to the back
            if (cf)
                for (y = [(size.y - backHoleOffset)/2, -(size.y - backHoleOffset)/2])
                    translate([-size.x + NEMA_width(NEMA_type)/2, y, zMotorMountTopPlateThickness/2])
                        rotate([0, 90, 0])
                            boltHoleM3Tap(12, horizontal=true, chamfer_both_ends=false, rotate=270);
        }// end difference
    }// end translate
}

module Z_MotorMountHardware(NEMA_type, topPlateThickness=zMotorMountTopPlateThickness, corkDamperThickness=_corkDamperThickness, cnc=false) {
    height = Z_MotorMountHeightX(NEMA_type) - topPlateThickness;

    translate_z(height)
        rotate(0)
            explode(-200, true) {
                if (corkDamperThickness)
                    explode(25)
                        corkDamper(NEMA_type, corkDamperThickness);
                shaft_length = NEMA_shaft_length(NEMA_type);
                if (is_list(shaft_length)) {
                    // integrated lead screw, so set shaft length to zero and use leadscrewX rather than NopSCADlib leadscrew
                    NEMA_no_shaft = [ for (i = [0 : len(NEMA_type) - 1]) i==8 ? [1, shaft_length[1], shaft_length[2]] : NEMA_type[i] ];
                    no_explode() {
                        not_on_bom()
                            NEMA(NEMA_no_shaft, jst_connector=true);
                        vitamin(str("NEMA(", NEMA_type[0], "): Stepper motor NEMA", round(NEMA_width(NEMA_type) / 2.54), " x ", NEMA_length(NEMA_type), "mm, ", shaft_length[0], "mm integrated leadscrew"));
                        translate_z(eps)
                            not_on_bom()
                            //if ($preview && is_undef($show_threads))
                                leadscrewX(shaft_length[1], shaft_length[0], shaft_length[2], center=false);
                            //else
                            //    leadscrew(d=shaft_length[1], l=shaft_length[0], lead=shaft_length[2], starts=1, center=false);
                    }
                } else {
                    // no integrated lead screw, so add lead screw and coupling
                    NEMA(NEMA_type, jst_connector=true);
                    translate_z(NEMA_shaft_length(NEMA_type)) {
                        explode(80)
                            shaft_coupling(SC_5x8_rigid, colour=grey(30));
                        //if ($preview && is_undef($show_threads))
                            leadscrewX(_zLeadScrewDiameter, _zLeadScrewLength, center=false);
                        //else
                        //    leadscrew(d=_zLeadScrewDiameter, l=_zLeadScrewLength, lead=2, starts=1, center=false);
                    }
                }
            }

    //echo(topPlateScrewLength=screw_shorter_than(5+topPlateThickness));
    translate_z(Z_MotorMountHeight(NEMA_type, topPlateThickness))
        NEMA_screw_positions(NEMA_type)
            if (cnc)
                boltM3Countersunk(screw_shorter_than(5 + topPlateThickness + 0*corkDamperThickness));
            else
                boltM3Buttonhead(screw_shorter_than(5 + topPlateThickness + 0*corkDamperThickness));
}
