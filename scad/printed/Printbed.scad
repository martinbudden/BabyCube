include <../global_defs.scad>

include <NopSCADlib/core.scad>
use <NopSCADlib/vitamins/o_ring.scad>

use <../vitamins/bolts.scad>

use <Z_Carriage.scad>

include <../Parameters_Main.scad>


underlayThickness = 3;
heatingPadThickness = 2.5;
magneticBaseThickness = 0.75;
printSurfaceThickness = 1;

module drilledBed(size, printBedSize, holeRadius = M3_clearance_radius) {
    linear_extrude(size.z)
        difference() {
            rounded_square([size.x, size.y], 2, center=true);
            for (i = heatedBedHoles(printBedSize))
                translate(i)
                    circle(r = holeRadius);
        }
}

module magneticBase(printBedSize, thickness, holeRadius = M3_clearance_radius) {
    size = [heatedBedSize(printBedSize).x, heatedBedSize(printBedSize).y, thickness];
    vitamin(str("magneticBase(", size, "): Magnetic base ", size.x, "mm x ", size.y, "mm"));

    color(grey(40))
        drilledBed(size, printBedSize, holeRadius);

    if ($children)
        translate_z(thickness)
            children();
}

module printSurface(printBedSize, thickness) {
    size = [heatedBedSize(printBedSize).x, heatedBedSize(printBedSize).y, thickness];
    vitamin(str("printSurface", size, "): Print surface ", size.x, "mm x ", size.y, "mm"));

    color(grey(30))
        linear_extrude(size.z)
            difference() {
                rounded_square([size.x, size.y], 2, center=true);
                if (printBedSize == 100)
                    for (i = heatedBedHoles(printBedSize))
                        translate(i)
                            rounded_square([10, 10], 2, center=true);
            }
}


module corkUnderlay(size, printBedSize) {
    vitamin(str("corkUnderlay(", size, "): Cork underlay ", size.x, "mm x ", size.y, "mm x ", size.z, "mm"));
    color("Tan")
        render(convexity=2)
            difference() {
                drilledBed(size, printBedSize);
                if (printBedSize == 120)
                    for (i = heatedBedHoles(printBedSize, 4))
                        translate(i - [0, 0, eps])
                            rounded_cube_xy([10, 10, size.z + 2*eps], 1, xy_center=true);
            }

    if ($children)
        translate_z(size.z)
            children();
}

module heatingPad(size) {
    vitamin(str("heatingPad(", size, "): Heating pad ", size.x, "mm x ", size.y, "mm"));
    color("OrangeRed")
        rounded_cube_xy(size, 2, xy_center=true);

    if ($children)
        translate_z(size.z)
            children();
}


module heatedBed(printBedSize) {
    size = heatedBedSize(printBedSize);
    holeOffset = heatedBedHoleOffset(printBedSize);
        vitamin(str("heatedBed(", printBedSize, "): OpenBuilds mini heated bed ", size.x, "mm x ", size.y, "mm"));

    color(grey(30))
        render_if(printBedSize == 120)
            difference() {
                drilledBed(size, printBedSize);
                if (printBedSize == 120)
                    for (i = heatedBedHoles(printBedSize))
                        translate(i)
                            translate_z(2+eps)
                                cylinder(d=6, h=4);
            }

    if ($children)
        translate_z(size.z)
            children();
}

module printbed(printBedSize) {
    size = heatedBedSize(printBedSize);

    // this is heated bed with leadscrew at [0, 0] and top of print surface at z=0
    translate([0, size.y/2 + heatedBedOffset(printBedSize).y, heatedBedOffset().z]) {
        explode(10, true)
            corkUnderlay([size.x + 5, size.y + 5, underlayThickness], printBedSize)
                explode(10, true)
                    heatedBed(printBedSize)
                        explode(10, true)
                            magneticBase(printBedSize, magneticBaseThickness)
                                explode(10)
                                    printSurface(printBedSize, printSurfaceThickness);
        for (i = heatedBedHoles(printBedSize))
            translate(i) {
                translate_z(size.z + oRingThickness + (printBedSize==100 ? underlayThickness + magneticBaseThickness : 0)) {
                    explode(70)
                        boltM3Countersunk(16);
                    oRingThickness = 2;
                    translate_z(-oRingThickness/2)
                        explode(50)
                            color("firebrick")
                                O_ring(3, oRingThickness);
                }
            }
    }
}

//! This is the standard variant of the print bed, using an OpenBuilds 100mm heated bed. There is also a version using
//! a 120 x 120 x 6 mm aluminium tooling plate, see [printbed 120](../../PRINTBED120/readme.md).
//!
//!1. Prepare the the cork underlay by cutting it to size, making a cutout for the heated bed wiring, and drilling holes for the bolts.
//!2. Prepare the heated bed by soldering on the wires and sticking on the magnetic base. Drill bolt holes in the magnetic base.
//!3. Place the cork underlay on the Z_Carriage and place the heated bed on top.
//!4. Secure the heated bed to the Z_Carriage, using the bolts and O-rings. Note that the O-rings help thermally insulate the heated bed from the Z_Carriage.
module Print_bed_assembly()
assembly("Print_bed") {

    translate([eX/2 + eSizeX, eY + 2*eSizeY - _zLeadScrewOffset, 0]) // this moves it to the back face
        rotate(180)
            translate_z(-heatedBedSize(_printBedSize).z - underlayThickness - printSurfaceThickness- magneticBaseThickness){// ) {
                Z_Carriage_assembly();

                if (!exploded())
                    Z_Carriage_cable_ties(_printBedSize);
                    printbed(_printBedSize);
            }
}
