include <../config/global_defs.scad>

include <../vitamins/bolts.scad>
include <NopSCADlib/utils/core/core.scad>

module handleCrossSection(size, fillet, angle) {
    module teardrop(r, angle) {
        hull() {
            circle4n(r);
            if (angle > 0) {
                square_size = [2*r*(sin(angle) - (1 - cos(angle))/tan(angle)), r];
                translate([0, square_size.y / 2])
                    square(square_size, center = true);
            }
        }
    }

    hull() {
        for (x = [fillet, size.y - fillet]) {
            translate([x, fillet])
                rotate(180)
                    teardrop(fillet, angle);
            translate([x, size.x - fillet])
                teardrop(fillet, angle);
        }
    }
}

module handle(size, gripSizeY=15, holeCount=2, extended=true) {
    internalRadius = 10;
    fillet = 4;
    filletAngle = 55;
    baseHeight = 5;
    //size = [gripSize.x, length2, height2];
    gripSize = [size.x, gripSizeY];

    module top() {
        translate_z(gripSize.y + internalRadius)
            linear_extrude(size.y - 2*internalRadius)
                handleCrossSection(gripSize, fillet, filletAngle);
    }

    module topCorner(angle=90) {
        translate([-internalRadius, gripSize.x/2, gripSize.y + internalRadius])
            rotate([-90, angle==90 ? 0 : angle, 0])
                rotate_extrude(angle=angle == 90 ? 90 : eps, convexity=2, $fn = r2sides4n(internalRadius))
                    translate([internalRadius, -gripSize.x/2])
                        handleCrossSection(gripSize, fillet, filletAngle);
    }

    module side(length) {
        translate([-size.z + gripSize.y, 0, 0])
            rotate([0, 90, 0])
                linear_extrude(length)
                    handleCrossSection(gripSize, fillet, filletAngle);
    }

    module corner() {
        difference() {
            union() {
                topCorner();
                hull() {
                    translate_z(gripSize.y)
                        side(size.z - gripSize.y - internalRadius);
                    if (extended)
                        side(eps);
                }
                if (extended) {
                    hull() {
                        topCorner(angle=45);
                        translate_z(-gripSize.y/2)
                            side(baseHeight);
                        side(eps);
                    }
                } else {
                    hull() {
                        topCorner(angle=81);
                        translate_z(gripSize.y - 2.5)
                            side(3);
                    }
                    translate([-size.z + gripSize.y, 0, gripSize.y/2])
                        cube([3, gripSize.x, size.y]);
                }
            }
            translate([gripSize.y, gripSize.x/2, gripSize.y/2])
                rotate([0, -90, 0]) {
                    if (holeCount == 2) {
                        boltHoleM4CounterboreButtonhead(size.z, boreDepth=size.z - baseHeight, horizontal=true, chamfer=0);
                    } else if (holeCount == 1) {
                        boreDepth=size.z - baseHeight - 2;
                        boltHoleCounterbore(M4_cs_cap_screw, size.z, boreDepth = boreDepth, boltHeadTolerance=0.5, horizontal=true, chamfer=0);
                        translate_z(boreDepth)
                            boltHole(4.6, 7, horizontal=true, chamfer=3.9, chamfer_both_ends=false);
                    }
                }
            if (extended && holeCount == 2) {
                h = 20;
                translate([gripSize.y - size.z + h, gripSize.x/2, gripSize.y/2 - 20])
                    rotate([0, -90, 0])
                        boltHoleM4CounterboreButtonhead(h, boreDepth=size.z - h - baseHeight, horizontal=true);
            }
        }
    }

    translate([size.z - gripSize.y, gripSize.y + size.y/2, -gripSize.x/2])
        rotate([90, 0, 0]) {
            top();
            corner();
            translate_z(size.y + 2*gripSize.y)
                mirror([0, 0, 1])
                    corner();
        }
}

