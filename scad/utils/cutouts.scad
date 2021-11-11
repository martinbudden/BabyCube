use <NopSCADlib/utils/dogbones.scad>
use <NopSCADlib/utils/fillet.scad>
include <NopSCADlib/vitamins/rails.scad>

include <../Parameters_Main.scad>


module edgeCutout_x(size, cnc=false, center=false, xy_center=true, fillet=1, tolerance=_tabTolerance) {
    dogboneSize = size + [tolerance, 0, size.z == 0 ? 0 : 2*eps];

    translate_z(size.z == 0 ? 0 : -eps)
        dogbone_rectangle_x(dogboneSize, r=cnc ? cnc_bit_r : 0, center=center, xy_center=xy_center);
    if (!cnc) {
        h = size.z ? size.z + 2*eps : 0;
        z = size.z ? -eps : 0;
        translate([0, dogboneSize.y/2, z])
            fillet(fillet, h);
        translate([0, dogboneSize.y/2, z])
            rotate(90)
                fillet(fillet, h);
        translate([0, -dogboneSize.y/2, z])
            rotate(180)
                fillet(fillet, h);
        translate([0, -dogboneSize.y/2, z])
            rotate(-90)
                fillet(fillet, h);
    }
}

module edgeCutout_y(size, cnc=false, center=false, xy_center=true, fillet=1, tolerance=_tabTolerance) {
    dogboneSize = size + [tolerance, 0, size.z == 0 ? 0 : 2*eps];

    translate_z(size.z == 0 ? 0 : -eps)
        dogbone_rectangle_y(dogboneSize, r=cnc ? cnc_bit_r : 0, center=center, xy_center=xy_center);
    if (!cnc) {
        h = size.z ? size.z + 2*eps : 0;
        z = size.z ? -eps : 0;
        translate([dogboneSize.x/2, 0, z])
            fillet(fillet, h);
        translate([dogboneSize.x/2, 0, z])
            rotate(-90)
                fillet(fillet, h);
        translate([-dogboneSize.x/2, 0, z])
            rotate(180)
                fillet(fillet, h);
        translate([-dogboneSize.x/2, 0, z])
            rotate(90)
                fillet(fillet, h);
    }
}

module topFaceSideDogbones(cnc=false, plateThickness=_sidePlateThickness) {
    yStep = 20;
    dogboneSize = [plateThickness*2, yStep];

    for (x = [0],
         y = [-4 : yStep*2 : eY + 2*eSizeY])
            translate([x, y])
                edgeCutout_x(dogboneSize, cnc);
}

module topFaceBackDogbones(cnc=false, plateThickness=_backPlateThickness, yRailOffset) {
    xStep = 20;
    dogboneSize = [xStep, plateThickness*2];

    for (x = [cnc? xStep*2 : 0 : xStep*2 : cnc ? eX - xStep*2 : eX],
         y = [0])
        translate([x - eps + dogboneSize.x/2, y])
            edgeCutout_y(dogboneSize, cnc);
    endDogboneSize = [yRailOffset, plateThickness*2];
    if (cnc)
        for (x = [0, eX + 2*eSizeX - endDogboneSize.x])
            translate([x - eps + endDogboneSize.x/2, 0])
                edgeCutout_y(endDogboneSize, cnc);
}

module sideFaceTopDogbones(cnc=false, plateThickness=_topPlateThickness) {
    xStep = 20;
    dogboneSize = [xStep, plateThickness*2, 0];

    for (x = [xStep : xStep*2 : eY + 2*eSizeY],
         y = [eZ])
            translate([x, y, 0])
                edgeCutout_y(dogboneSize, cnc);
}

module sideFaceBackDogBones(cnc=true, plateThickness=_sidePlateThickness) {
    yStep = 20;
    dogboneSize = [3*2, yStep - _tabTolerance];

    x = eY + 2*eSizeY;
    for (y = [yStep : yStep*2 : eZ])
        translate([x, y])
            edgeCutout_x(dogboneSize, cnc);
}


module translate_a(v) {
    translate([v.x, v.y, v.z])
        rotate(v[3])
            children();
}

module backFaceSideCutouts(cnc=false, plateThickness=3, dogBoneThickness=3) {
    yStep = 20;
    dogboneSize = [plateThickness*2, yStep + _tabTolerance, dogBoneThickness];

    for (y = [0 : yStep*2 : eZ],
        x = [0, eX + 2*eSizeX])
            translate([x, y, -dogBoneThickness])
                edgeCutout_x(dogboneSize, cnc);

    if (dogBoneThickness > 0)
        for (v = [  [plateThickness, 0, 0, 0], [plateThickness, eZ, 0, -90],
                    [eX + 2*eSizeX - plateThickness, 0, 0, 90], [eX + 2*eSizeX - plateThickness, eZ, 0, 180]
                ])
            translate_z(-plateThickness - eps)
                translate_a(v)
                    fillet(1, plateThickness + 2*eps);
}

module backFaceTopCutouts(cnc=false, plateThickness=_topPlateThickness, dogBoneThickness=3) {
    xStep = 20;
    dogboneSize = [xStep, plateThickness*2, dogBoneThickness];

    for (x = [xStep/2 + eSizeZ : xStep*2 : eX],
         y = [eZ])
        translate([x + dogboneSize.x/2, y, -dogBoneThickness])
            edgeCutout_y(dogboneSize, cnc);
}

module sideFaceBackTabs() {
    yStep = 20;
    fillet = _fillet;
    tabSize = [3*2, yStep - _tabTolerance];

    x = eY + 2*eSizeY;
    translate([x - tabSize.x/2, 0])
        square([tabSize.x/2, eZ]);
    for (y = [yStep*2 : yStep*2 : eZ - yStep*2])
        translate([x, y])
            rounded_square(tabSize, fillet);
    for (y = [tabSize.y/4, eZ - tabSize.y/4])
        translate([x, y])
            rounded_square([tabSize.x, tabSize.y/2], fillet);
}

/*!!TODO remove unused code
module sideFaceSideDogbones(cnc=false, plateThickness=_sidePlateThickness) {
    dogboneSize = [plateThickness*2, 20+_tabTolerance, 3 + 2*eps];
    yStep = 20;

    if (_sideTabs)
        for (x = [eSizeY + dogboneSize.x/2],
             y = [yStep : yStep*2 : eZ])
                translate([x, y, 0])
                    dogbone_rectangle_x(dogboneSize, xy_center=true, r=cnc ? cnc_bit_r : 0);
}
*/

module railsCutout(NEMA_width, railOffset, cnc=false) {
    // add a cutout for the Y rail, since sometimes they are cut a bit long
    yRailType = railType(_yCarriageDescriptor);
    filletX = cnc ? 1.5 : 1;
    filletY = cnc ? 0.5 : 1;
    heightExtra = 10;
    railCutoutSize = [rail_width(yRailType) + 2*filletX, rail_height(yRailType) + 2*filletY + heightExtra, _backPlateThickness - 1];
    for (x = [railOffset.x, eX + 2*eSizeX - railOffset.x])
        if (cnc)
            translate([x - railCutoutSize.x/2, railOffset.z - railCutoutSize.y + heightExtra])
                rounded_square([railCutoutSize.x, railCutoutSize.y], filletX, center=false);
        else
            translate([x, railOffset.z - rail_height(yRailType)/2 + heightExtra/2, -railCutoutSize.z + eps])
                rounded_cube_xy(railCutoutSize, filletX, xy_center=true);
}
