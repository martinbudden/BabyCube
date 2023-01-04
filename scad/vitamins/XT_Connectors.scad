include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/tube.scad>

boltColorBrass = "#B5A642";

XT60Size = [8.1, 16.3, 15];
function XT60SizeFn() = XT60Size;
XT60BevelSize = [2.5, 3];
xt60Width = XT60Size.x;
xt60Height = XT60Size.y;
XT60MaleCutoutSize = [8.1, 15.6, 11.5];
XT60FemaleCutoutSize = [9.25, 16.5, 3];
/*xt60bevelHeight = 3;
xt60bevelWidth = 2.5;
xt60Polygon = [
    [0, 0],
    [XT60Size.x, 0],
    [XT60Size.x, XT60Size.y-xt60bevelHeight],
    [XT60Size.x-xt60bevelWidth, XT60Size.y],
    [xt60bevelWidth, XT60Size.y],
    [0, XT60Size.y-xt60bevelHeight]
];*/

xt60Polygon = [
    [ 0, 0 ],
    [ XT60Size.x, 0 ],
    [ XT60Size.x, XT60Size.y - XT60BevelSize.y ],
    [ XT60Size.x - XT60BevelSize.x, XT60Size.y ],
    [ XT60BevelSize.x, XT60Size.y ],
    [ 0, XT60Size.y - XT60BevelSize.y ]
];

//XT60Female();
module XT60Female() {
    vitamin(str("XT60Female(): XT60 Connector Female"));

    cOffset = 3.5;
    ir = 3.5/2;
    or = ir + 0.5;
    sizeZ = XT60Size.z;
    color("#ffb800") {
        linear_extrude(sizeZ/2) difference() {
            translate([-xt60Width/2, -xt60Height/2, 0]) polygon(xt60Polygon);
            for (i=[-cOffset, cOffset])
                translate([0, i, 0])
                    circle(r=or);
            //scale([0.8, 0.9]) translate([-xt60Width/2, -xt60Height/2, 0]) polygon(xt60Polygon);
        }
        translate_z(sizeZ/2) linear_extrude(sizeZ/2) difference() {
            scale([0.8, 0.9]) translate([-xt60Width/2, -xt60Height/2, 0]) polygon(xt60Polygon);
            for (i=[-cOffset, cOffset])
                translate([0, i, 0])
                    circle(r=or);
        }
    }
    for (i=[-cOffset, cOffset])
        color(boltColorBrass)
            translate([0, i, sizeZ/2])
                tube(or=or, ir=ir, h=sizeZ);
    color("Red")
        translate([0, -cOffset, sizeZ/2])
            vflip()
                cylinder(r=ir, h=30);
    color(grey(25))
        translate([0, cOffset, sizeZ/2])
            vflip()
                cylinder(r=ir, h=30);
}

//!XT60Male();
module XT60Male() {
    vitamin(str("XT60Male(): XT60 Connector Male"));

    cOffset = 3.5;
    cRadius = 3.5/2;
    sizeZ = 19;
    if ($preview) {
        color("#ffb800") {
            linear_extrude(11) difference() {
                translate([-xt60Width/2, -xt60Height/2, 0]) polygon(xt60Polygon);
                scale([0.8, 0.9]) translate([-xt60Width/2, -xt60Height/2, 0]) polygon(xt60Polygon);
            }
            translate_z(11)
                hull() {
                    translate([-xt60Width/2, -xt60Height/2, 0])
                        linear_extrude(0.1)
                            polygon(xt60Polygon);
                    translate_z(3)
                        scale(0.8)
                            translate([-xt60Width/2, -xt60Height/2, 0])
                                linear_extrude(0.1)
                                    polygon(xt60Polygon);
                }
        }
        color(boltColorBrass)
            for (i=[-cOffset, cOffset])
                translate([0, i, 0.5]) {
                    difference() {
                        union() {
                            sphere(r=cRadius);
                            cylinder(r=cRadius, h=sizeZ-0.5);
                        }
                        h = 10;
                        translate_z(-cRadius+h/2) {
                            cube([2*cRadius + 1, 0.25, h], center=true);
                            cube([0.25, 2*cRadius + 1, h], center=true);
                        }
                    }
                }
    }
    color("red")
        translate([0, -cOffset, sizeZ])
            cylinder(r=cRadius, h=20);
    color(grey(25))
        translate([0, cOffset, sizeZ])
            cylinder(r=cRadius, h=20);
}

//rotate([0, -90, 0]) XT60Holder();
module XT60MaleHolder() {
    // cutout for XT60 connector
    // position given by center

    // XT60 shell
    size = XT60MaleHolderSize();
    coverThickness = 1;
    tolerance = [0.3, 0.45];
    linear_extrude(size.z - coverThickness) difference() {
        square([size.x, size.y], center=true);
        //scale([1.4, 1.2]) translate([-xt60Width/2, -xt60Height/2, 0]) polygon(xt60Polygon);
        //translate([-xt60Width/2, -xt60Height/2, 0])polygon(xt60Polygon);
        square([XT60MaleCutoutSize.x, XT60MaleCutoutSize.y] + tolerance, center=true);
    }
    // add a cover to stop the XT60 pushing through
    translate_z(size.z-coverThickness) linear_extrude(coverThickness) difference() {
        square([size.x, size.y], center=true);
        //scale([1.4, 1.2]) translate([-xt60Width/2, -xt60Height/2, 0]) polygon(xt60Polygon);
        scale([0.8, 0.9]) translate([-xt60Width/2, -xt60Height/2, 0]) polygon(xt60Polygon);
    }
}

module XT60FemaleHolder() {
    // cutout for XT60 connector
    // position given by center

    // XT60 shell
    size = XT60FemaleHolderSize();
    coverThickness = 1;
    tolerance = [0.3, 0.45];
    render(convexity=2) difference() {
        linear_extrude(size.z - coverThickness) difference() {
            square([size.x, size.y], center=true);
            //scale([1.4, 1.2]) translate([-xt60Width/2, -xt60Height/2, 0]) polygon(xt60Polygon);
            //translate([-xt60Width/2, -xt60Height/2, 0])polygon(xt60Polygon);
            square([XT60MaleCutoutSize.x, XT60MaleCutoutSize.y] + tolerance, center=true);
        }
        translate_z(XT60FemaleCutoutSize.z*0)
            rounded_cube_xy([XT60FemaleCutoutSize.x, XT60FemaleCutoutSize.y, 9.5 - coverThickness-XT60FemaleCutoutSize.z]+[tolerance.x, tolerance.y, 0], xy_center=true);
    }
    // add a cover to stop the XT60 pushing through
    translate_z(size.z-coverThickness) linear_extrude(coverThickness) difference() {
        square([size.x, size.y], center=true);
        //scale([1.4, 1.2]) translate([-xt60Width/2, -xt60Height/2, 0]) polygon(xt60Polygon);
        scale([0.8, 0.9]) translate([-xt60Width/2, -xt60Height/2, 0]) polygon(xt60Polygon);
    }
}
function XT60FemaleHolderSize() = [12, 20, 9.5];
function XT60MaleHolderSize() = [12, 20, 13.5];
//function XT60HolderSizeFn() = [8.1, 16.3, 9.5];

//XT60HolderCutout();
module XT60HolderCutout() {
    //hull() XT60Holder();
    translate([0, 0, 8]) linear_extrude(5) {
        scale([0.8, 0.9]) translate([-xt60Width/2, -xt60Height/2, 0]) polygon(xt60Polygon);
    }
}
