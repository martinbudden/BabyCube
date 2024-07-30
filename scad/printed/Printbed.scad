include <../global_defs.scad>

include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/vitamins/o_ring.scad>

include <../vitamins/bolts.scad>

use <Z_Carriage.scad>

include <../config/Parameters_Main.scad>


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
                    circle(r=holeRadius);
        }
}

module magneticBase(printBedSize, thickness, holeRadius=M3_clearance_radius) {
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
                cutoutSize = printBedSize == 120 ? 10 : 12;
                for (i = heatedBedHoles(printBedSize, printBedSize == 120 ? 4 : 2))
                    translate(i - [0, 0, eps])
                        rounded_cube_xy([cutoutSize, cutoutSize, size.z + 2*eps], 1, xy_center=true);
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
                            translate_z(2 + eps)
                                cylinder(d=6, h=4);
            }

    if ($children)
        translate_z(size.z)
            children();
}

module printbed(printBedSize) {
    size = heatedBedSize(printBedSize);

    levelingOffset = 1;
    // this is heated bed with leadscrew at [0, 0] and top of print surface at z=0
    translate([0, size.y/2 + heatedBedOffset(printBedSize).y, heatedBedOffset().z]) {
        explode(10, true)
            corkUnderlay([size.x + 5, size.y + 5, underlayThickness], printBedSize)
                translate_z(levelingOffset)
                    explode(10, true)
                        heatedBed(printBedSize)
                            explode(10, true)
                                magneticBase(printBedSize, magneticBaseThickness)
                                    explode(10)
                                        printSurface(printBedSize, printSurfaceThickness);
        oRingThickness = 2;
        washerThickness = washer_thickness(M3_washer);
        for (i = heatedBedHoles(printBedSize))
            translate(i) {
                translate_z((printBedSize==100 ?  levelingOffset + underlayThickness + magneticBaseThickness + printSurfaceThickness + 2*washerThickness: size.z + oRingThickness)) {
                    explode(60, true) {
                        boltM3Caphead(16);
                        translate_z(-washerThickness)
                            washer(M3_washer);
                    }
                    translate_z(-magneticBaseThickness - printSurfaceThickness - 2*washerThickness)
                        explode(10, true) {
                            translate_z(-oRingThickness/2)
                                color("firebrick")
                                    O_ring(4, oRingThickness);
                            explode(-5)
                                translate_z(-oRingThickness - washerThickness/2)
                                    washer(M3_washer);
                            explode(-10)
                            translate_z(-oRingThickness - 2*washerThickness)
                                color("firebrick")
                                    O_ring(4, oRingThickness);
                        }
                }
            }
    }
}

//! This is the standard variant of the print bed, using an OpenBuilds 100mm heated bed. There is also a version using
//! a 120 x 120 x 6 mm aluminium tooling plate, see [printbed 120](../../PRINTBED120/readme.md).
//!
//!1. Prepare the the cork underlay by cutting it to size, making a cutout for the heated bed wiring, and making cutouts
//!for the bolts and O-rings.
//!2. Prepare the magnetic base by drilling holes for the bolts.
//!3. Prepare the heated bed by soldering on the wires and sticking on the magnetic base. Drill bolt holes in the magnetic base.
//!4. Place the cork underlay on the **Z_Carriage** and place the heated bed on top.
//!5. Secure the heated bed to the **Z_Carriage**, using the bolts and O-rings. The O-rings allow for bed leveling and help
//!thermally insulate the heated bed from the **Z_Carriage**.
//!6. Secure the heated bed wiring to the underside of the printbed using zipties.
module Print_bed_assembly()
assembly("Print_bed") {

    printBedSize = 100;
    translate([eX/2 + eSizeX, eY + 2*eSizeY - _zLeadScrewOffset, 0]) // this moves it to the back face
        rotate(180)
            translate_z(-heatedBedSize(printBedSize).z - underlayThickness - printSurfaceThickness- magneticBaseThickness) {
                Z_Carriage_assembly();
                printbed(printBedSize);
                if (!exploded())
                    Z_Carriage_cable_ties(printBedSize);
            }
}
