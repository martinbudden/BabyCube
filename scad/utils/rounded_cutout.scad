use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/utils/core/global.scad>
X = 0;
Y = 1;
Z = 2;

module rounded_cutout_xyz(xyz, size, r = 0, xy_center = false, z_center = false) {
    if (xyz == 0)
        rounded_cutout_yz(size = size, r = r, xy_center = xy_center, z_center = z_center);
    else if (xyz == 1)
        rounded_cutout_xz(size = size, r = r, xy_center = xy_center, z_center = z_center);
    else if (xyz == 2)
        rounded_cutout_xy(size = size, r = r, xy_center = xy_center, z_center = z_center);
    else
        assert(false);
}
module rounded_cutout_xy(size, r = 0, xy_center = false, z_center = false) {
    translate([xy_center ? -size.x / 2 : 0, xy_center ? -size.y / 2 : 0, z_center ? -size.z / 2 : 0]) {
        translate([-eps, 0, 0])
            cube([size.x, size.y, size.z + 2*eps]);
    }
}

module rounded_cutout_xz(size, r = 0, xy_center = false, z_center = false) {
    translate([xy_center ? -size.x / 2 : 0, xy_center ? -size.y / 2 : 0, z_center ? -size.z / 2 : 0]) {
        translate([-eps, 0, 0])
            cube([size.x + 2*eps, size.y, size.z]);
    }
}

module rounded_cutout_yz(size, r = 0, xy_center = false, z_center = false) {
    translate([xy_center ? -size.x / 2 : 0, xy_center ? -size.y / 2 : 0, z_center ? -size.z / 2 : 0]) {
        translate([0, -eps, 0])
            cube([size.x, size.y + 2*eps, size.z]);
        rotate([0, 90, 0])
            fillet(r, size.x);
        translate([0, size.y, 0])
            rotate([90, 180, 90])
                fillet(r, size.x);
        translate([0, size.y, size.z])
            rotate([90, -90, 90])
                fillet(r, size.x);
        translate([0, 0, size.z])
            rotate([90, 0, 90])
                fillet(r, size.x);
    }
}
