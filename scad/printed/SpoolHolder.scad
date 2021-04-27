include <NopSCADlib/core.scad>

use <NopSCADlib/utils/fillet.scad>


function spoolOffset() = [17.5, 0, 7];


module spoolHolderEndCap(height, length) {
    r = height*sin(45);
    x = r*sin(45);
    translate([0, -x, 0])
        linear_extrude(length)
            difference() {
                circle(r=r);
                translate([-r, -2*x])
                    square([2*r, 3*x]);
            }
}

module spoolHolderCap(width, length) {
    r = 26; // to match standard spool internal radius
    x = sqrt(r*r + width*width/4);
    linear_extrude(length)
        difference() {
            translate([0, -2*r + x])
                circle(r=r);
            translate([-r, -2*r])
                square([2*r, 2*r]);
        }
}

module spoolHolderBracket(size, bracketThickness, topThickness) {
    eSize = size.y;
    interference = 1/16;// so there is some interference fit, to hold the bracket on tighter
    difference() {
        thickness = bracketThickness + interference;
        cube([size.z, size.y, thickness]);
        translate([size.z, 0, 0])
            rotate([0, -90, 0])
                fillet(1, size.z);
        translate([0, 0, thickness])
            rotate([0, 90, 0])
                fillet(1, size.z);
    }
    translate_z(size.x + bracketThickness)
        difference() {
            cube([size.z, size.y, bracketThickness]);
            translate([size.z, 0, 0])
                rotate([0, -90, 0])
                    fillet(1, size.z);
    }
    translate([0, eSize, 0])
        difference() {
            cube([size.z, topThickness, size.x + 2*bracketThickness]);
            translate([-eps, topThickness, 0])
                rotate([0, -90, 180])
                    fillet(1, size.z + 2*eps);
            if (size.x < 20)
                translate_z(bracketThickness + interference)
                    fillet(5, size.x - interference); // fillet to match innerFillet on left face
        }
}

module spoolHolder(bracketSize, offsetX) {
    bracketThickness = 5;
    capPosX = offsetX - bracketThickness;
    size = [capPosX + 80, 20, 20];
    clampThickness = bracketSize.x;

    translate([0, -bracketSize.y, bracketSize.z/2])
        rotate([0, 90, 0]) {
            translate_z(-bracketSize.x - bracketThickness)
                spoolHolderBracket(bracketSize, bracketThickness, clampThickness);
            translate([0, bracketSize.y, 0])
                cube([size.z, bracketThickness, size.x]);
            translate([bracketSize.z/2, bracketSize.y + bracketThickness, capPosX])
                spoolHolderCap(size.z, size.x - capPosX);
            translate([0, bracketSize.y, 0]) {
                cube([size.z, clampThickness, capPosX]);
                translate([0, clampThickness, capPosX])
                    rotate([0, 90, 0])
                        fillet(2, size.z);
            }
            translate([0, bracketSize.y, bracketThickness])
                rotate([0, -90, 180])
                    right_triangle(size.x - bracketThickness, bracketSize.y, size.z, center=false);
            endHeight = 20;
            for (z = [capPosX, size.x - bracketThickness]) {
                translate([0, bracketSize.y + bracketThickness, z])
                    cube([size.z, endHeight, bracketThickness]);
                translate([size.z/2, bracketSize.y + bracketThickness + endHeight, z])
                    spoolHolderEndCap(size.z, bracketThickness);
            }
        }
}
