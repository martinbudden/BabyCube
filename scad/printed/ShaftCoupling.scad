include <../global_defs.scad>

include <NopSCADlib/utils/core/core.scad>

include <../vitamins/bolts.scad>


module Shaft_Coupling_8x5_stl() {


    h1 = 15;
    h2 = 10;
    r1Tolerance = 0.1;
    r1 = 5 / 2 + r1Tolerance;
    r2 = 8 / 2;
    grubScrewLength = 6;
    or = r2 + grubScrewLength + 1; // wall thickness of 5, to give purchase to grub screws

    grub_length = or - r1 + 2;
    module grub_screw_positions(or, ir=r1) {
        grub_offset_z = 5;
        //for(z = [grub_offset_z, h1 + h2 - min(h2/2, grub_offset_z)])
        for (z = [h1 + h2 - min(h2/2, grub_offset_z)])
            translate_z(z)
                for (a = [0, 120, 240])
                    rotate([-90, 0, a])
                        translate_z(ir - 1)
                            children();
    }

    shaftCut = 0.45;
    stl("Shaft_Coupling_8x5")
    color(pp2_colour) {
        render(convexity=4)
            difference() {
                union() {
                    linear_extrude(h1)
                        difference() {
                            circle(r=or);
                            difference() {
                                poly_circle(r=r1);
                                cutSize = [2*r1, r1];
                                translate([0, cutSize.y/2 + r1 - shaftCut])
                                    square(cutSize, center=true);
                            }
                        }
                    translate_z(h1)
                        linear_extrude(h2)
                            difference() {
                                circle(r=or);
                                poly_circle(r=r2);
                            }
                }
                grub_screw_positions(or)
                    boltHoleM4Tap(grub_length, horizontal=true, chamfer=0, rotate=180);
                chamfer = 0.75;
                cylinder(r1=r1 + chamfer + 0.1, r2=r1 + 0.1, h=chamfer);
            }
        }

    *grub_screw_positions(or, 11)
        screw(M4_grub_screw, grubScrewLength);
}

module Z_Spacer_stl() {
    h = 10;

    stl("Z_Spacer")
        color(pp2_colour)
            linear_extrude(h)
                difference() {
                    circle(r=20.5/2);
                    poly_circle(r=12/2);
                }
}
