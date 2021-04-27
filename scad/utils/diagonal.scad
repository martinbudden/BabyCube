include <NopSCADlib/core.scad>

module diagonalDown(rectSize, width, fillet, extend=false) {
    h = sqrt(rectSize.x * rectSize.x + rectSize.y * rectSize.y);
    offset = [
        fillet * (rectSize.x + h)/ rectSize.y + width *h / rectSize.x,
        fillet * (rectSize.y + h)/ rectSize.x + width *h / (2 * rectSize.x)
    ];
    linear_extrude(rectSize.z) {
        difference() {
            square([rectSize.x, rectSize.y + (extend ? offset.y - fillet : 0)]);
            hull() {
                translate([0, 0])
                    square([fillet, fillet]);
                translate([fillet, rectSize.y - offset.y])
                    circle(r = fillet);
                translate([rectSize.x - offset.x, fillet])
                    circle(r = fillet);
            }
            hull() {
                translate([rectSize.x-fillet, rectSize.y - fillet + (extend ? offset.y : 0)])
                    square([fillet, fillet]);
                translate([rectSize.x-fillet, offset.y])
                    circle(r = fillet);
                if (extend)
                    translate([fillet, rectSize.y - fillet + offset.y])
                        circle(r = fillet);
                else
                    translate([offset.x, rectSize.y - fillet])
                        circle(r = fillet);
            }
        }
    }
}

module diagonal(rectSize, width, fillet, extend = false) {
    translate([rectSize.x, 0, 0])
        mirror([1, 0, 0])
            diagonalDown(rectSize, width, fillet, extend);
}

module diagonalFromTo(from, to, height, width, fillet) {
    translate(from)
        diagonal([to.x - from.x, to.y - from.y, height], width, fillet);
}
