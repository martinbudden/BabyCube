include <NopSCADlib/utils/core/core.scad>

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

module spoolHolderCap(width, length, spoolInternalRadius=26, offset=false) {
    r = spoolInternalRadius; // to match standard spool internal radius
    x = sqrt(r*r + width*width/4);
    linear_extrude(length)
        difference() {
            translate(offset ? [width/2, -2*r + x + 8] : [0, -2*r + x + 0.5])
                circle(r=r);
            translate([-r + (offset ? width/2 : 0), -2*r])
                square([2*r, 2*r]);
            translate([width/2, 0])
                square([r, 10]);
            translate([-width/2 - r, 0])
                square([r, 10]);
        }
}

module spoolHolderBracket(size, bracketThickness, topThickness, innerFillet, catchRadius) {
    interference = 1/16;// so there is some interference fit, to hold the bracket on tighter
    thickness = bracketThickness + interference;
    linear_extrude(size.z) {
        difference() {
            square([thickness, size.y]);
            fillet(1);
            translate([thickness, 0])
                rotate(90)
                    fillet(1);
        }
        translate([size.x + bracketThickness, 0, 0])
            if (catchRadius > 0) {
                square([bracketThickness, size.y]);
                translate([0, catchRadius])
                    circle(r=catchRadius);
            } else {
                difference() {
                    square([bracketThickness, size.y]);
                    fillet(1);
                }
            }
    }
    difference() {
        linear_extrude(size.z)
            translate([0, size.y, 0])
                difference() {
                    square([size.x + bracketThickness, topThickness]);
                    translate([0, topThickness])
                        rotate(270)
                            fillet(1);
                }
        if (innerFillet)
            translate([thickness, size.y, size.z])
                rotate([0, 90, 0])
                    fillet(innerFillet, size.x - interference); // fillet to match innerFillet on left face
    }
}

module spoolHolder(bracketSize, offsetX, innerFillet, catchRadius=0, length=80, endHeight=20, spoolInternalRadius=26, capOffset=false) {
    bracketThickness = 5;
    capPosX = offsetX - bracketThickness;
    size = [capPosX + length, 20, bracketSize.z];
    clampThickness = 8;

    translate_z(-size.z/2) {
        translate([-bracketSize.x - bracketThickness, -bracketSize.y, 0])
            spoolHolderBracket(bracketSize, bracketThickness, clampThickness, innerFillet, catchRadius);
        cube([size.x, bracketThickness, size.z]);
        if (capPosX > 0)
            cube([capPosX, clampThickness, size.z]);
        translate([capPosX, bracketThickness, size.z/2])
            rotate([0, 90, 0])
                spoolHolderCap(size.z, size.x - capPosX, spoolInternalRadius, capOffset);
        translate([capPosX, clampThickness, 0])
            rotate(90)
                fillet(2, size.z);
        translate([bracketThickness, 0, size.z])
            rotate([180, 0, 0])
                right_triangle(size.x - bracketThickness, bracketSize.y, size.z, center=false);
        for (x = [capPosX, size.x - bracketThickness]) {
            translate([x, bracketThickness, 0]) {
                cube([bracketThickness, endHeight, size.z]);
                translate([0, endHeight, size.z/2])
                    rotate([0, 90, 0])
                        spoolHolderEndCap(size.z, bracketThickness);
            }
        }
    }
}
