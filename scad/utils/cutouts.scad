use <NopSCADlib/utils/dogbones.scad>
use <NopSCADlib/utils/fillet.scad>

use <translateRotate.scad>
include <../config/Parameters_Main.scad>

/*
See https://fractory.com/what-is-cutting-kerf/ for typical kerfs. Kerf is the width of the cut.
Laser cutting – 0.3 mm
Waterjet cutting – 0.9 mm
Oxy-fuel cutting – 1.1 mm
Plasma cutting – 3.8 mm
*/

// cutoutTypes
P3D = 0; // 3D printer
CNC = 1; // CNC mill
WJ = 2; // Waterjet

dogBoneCNCBitRadius = 1.5;
dogBoneWJRadius = 0.9;
cncTabTolerance = 0.05; // 0.05 each side gives 0.1 total tolerance
wjKerf = 0.9;


module edgeCutout_x(size, cuttingRadius, tolerance, kerf, fillet=1) {
    dogboneSize = size + [-kerf, tolerance - kerf, size.z == 0 ? 0 : 2*eps];

    translate_z(size.z == 0 ? 0 : -eps)
        dogbone_rectangle_x(dogboneSize, r=cuttingRadius, center=false, xy_center=true);
    if (cuttingRadius == 0) {
        h = size.z ? size.z + 2*eps : 0;
        z = size.z ? -eps : 0;
        translate([0, dogboneSize.y/2, z]) {
            fillet(fillet, h);
            rotate(90)
                fillet(fillet, h);
        }
        translate([0, -dogboneSize.y/2, z]) {
            rotate(180)
                fillet(fillet, h);
            rotate(-90)
                fillet(fillet, h);
        }
    }
}

module edgeCutout_y(size, cuttingRadius, tolerance, kerf, fillet=1) {
    dogboneSize = size + [tolerance - kerf, -kerf, size.z == 0 ? 0 : 2*eps];

    translate_z(size.z == 0 ? 0 : -eps)
        dogbone_rectangle_y(dogboneSize, r=cuttingRadius, center=false, xy_center=true);
    if (cuttingRadius == 0) {
        h = size.z ? size.z + 2*eps : 0;
        z = size.z ? -eps : 0;
        translate([dogboneSize.x/2, 0, z]) {
            fillet(fillet, h);
            rotate(-90)
                fillet(fillet, h);
        }
        translate([-dogboneSize.x/2, 0, z]) {
            rotate(180)
                fillet(fillet, h);
            rotate(90)
                fillet(fillet, h);
        }
    }
}

module topFaceSideDogbones(toolType=P3D, plateThickness) {
    cuttingRadius = toolType == P3D ? 0 : toolType == CNC ? dogBoneCNCBitRadius : dogBoneWJRadius;
    tolerance = toolType == P3D ? 0 : cncTabTolerance;
    kerf = toolType == WJ ? wjKerf : 0;
    yStep = 20;
    dogboneSize = [plateThickness*2, yStep, 0];
    sizeY = eY + 2*eSizeY;

    start = sizeY == 200 ? -4 : sizeY == 220 ? yStep/2 - 4 : 5*yStep/2 - 4;
    end = sizeY == 220 ? sizeY - yStep*2 : sizeY;
    for (y = [start : yStep*2 : end])
        translate([0, y])
            edgeCutout_x(dogboneSize, cuttingRadius, tolerance, kerf);
    if (sizeY == 220) {
        endDogboneSize = [plateThickness*2, 2*yStep, 0];
        translate([0, start + sizeY - yStep/2])
            edgeCutout_x(endDogboneSize, cuttingRadius, tolerance, kerf);
    } else if (sizeY == 250) {
        startDogboneSize = [plateThickness*2, 2*yStep, 0];
        translate([0, start - 5*yStep/2])
            edgeCutout_x(startDogboneSize, cuttingRadius, tolerance, kerf);
    }
}

module topFaceFrontAndBackDogbones(toolType=P3D, plateThickness, yRailOffset) {
    cuttingRadius = toolType == P3D ? 0 : toolType == CNC ? dogBoneCNCBitRadius : dogBoneWJRadius;
    tolerance = toolType == P3D ? 0 : cncTabTolerance;
    kerf = toolType == WJ ? wjKerf : 0;
    xStep = 20;
    dogboneSize = [xStep, plateThickness*2, 0];
    sizeX = eX + 2*eSizeX;

    if (toolType==P3D) {
        for (x = [0 : xStep*2 : eX])
            translate([x - eps + dogboneSize.x/2, 0])
                edgeCutout_y(dogboneSize, cuttingRadius, tolerance, kerf);
    } else {
        //start = eX == 200 ? 3*xStep : eX == 220 ? 30 : xStep + 5;
        start = sizeX == 220 ? xStep*2 : xStep + 5;
        for (x = [start : xStep*2 : eX - start])
            translate([x - eps + dogboneSize.x/2, 0])
                edgeCutout_y(dogboneSize, cuttingRadius, tolerance, kerf);
        if (sizeX == 220) {
            sizeY = eY + 2*eSizeY; // no cutouts for yRails if sizeY == 220, so need dogbone
            endDogboneSize = sizeY == 220 ? [xStep, plateThickness*2, 0] : [yRailOffset, plateThickness*2, 0];
            for (x = [0, sizeX - endDogboneSize.x])
                translate([x - eps + endDogboneSize.x/2, 0])
                    edgeCutout_y(endDogboneSize, cuttingRadius, tolerance, kerf);
        }
    }
}

module sideFaceTopDogbones(toolType=P3D, plateThickness) {
    cuttingRadius = toolType == P3D ? 0 : toolType == CNC ? dogBoneCNCBitRadius : dogBoneWJRadius;
    tolerance = toolType == P3D ? 0 : cncTabTolerance;
    kerf = toolType == WJ ? wjKerf : 0;
    xStep = 20;
    dogboneSize = [xStep, plateThickness*2, 0];

    start = eY == 180 ? xStep : 3*xStep/2;
    for (x = [start : xStep*2 : eY + 2*eSizeY],
         y = [eZ])
            translate([x, y, 0])
                edgeCutout_y(dogboneSize, cuttingRadius, tolerance, kerf);
}

module sideFaceBackDogBones(toolType=P3D, plateThickness) {
    cuttingRadius = toolType == P3D ? 0 : toolType == CNC ? dogBoneCNCBitRadius : dogBoneWJRadius;
    tolerance = toolType == P3D ? 0 : cncTabTolerance;
    kerf = toolType == WJ ? wjKerf : 0;
    yStep = 20;
    dogboneSize = [plateThickness*2, yStep, 0];

    start = eZ == 200 ? yStep : 3*yStep/2;
    x = eY + 2*eSizeY;
    for (y = [start : yStep*2 : eZ])
        translate([x, y, 0])
            edgeCutout_x(dogboneSize, cuttingRadius, tolerance, kerf);
}

module backFaceSideCutouts(toolType=P3D, plateThickness, dogBoneThickness) {
    cuttingRadius = toolType == P3D ? 0 : toolType == CNC ? dogBoneCNCBitRadius : dogBoneWJRadius;
    tolerance = toolType == P3D ? 0 : cncTabTolerance;
    kerf = toolType == WJ ? wjKerf : 0;
    yStep = 20;
    dogboneSize = [plateThickness*2, yStep, dogBoneThickness];

    start = eZ == 200 ? 0 : 5*yStep/2;
    end = eZ == 200 ? eZ : eZ - yStep;
    for (y = [start : yStep*2 : end],
        x = [0, eX + 2*eSizeX])
            translate([x, y, -dogBoneThickness])
                edgeCutout_x(dogboneSize, cuttingRadius, tolerance, kerf);
    if (eZ != 200) {
        endDogboneSize = [plateThickness*2, 2*yStep, dogBoneThickness];
        for (y = [0, eZ == 220 ? eZ : eZ + yStep/2],
            x = [0, eX + 2*eSizeX])
                translate([x, y, -dogBoneThickness])
                    edgeCutout_x(endDogboneSize, cuttingRadius, tolerance, kerf);
    }

    if (dogBoneThickness > 0)
        for (v = [  [plateThickness, 0, 0, 0], [plateThickness, eZ, 0, -90],
                    [eX + 2*eSizeX - plateThickness, 0, 0, 90], [eX + 2*eSizeX - plateThickness, eZ, 0, 180]
                ])
            translate_z(-plateThickness - eps)
                translate_r(v)
                    fillet(1, plateThickness + 2*eps);
}

module backFaceTopCutouts(toolType=P3D, plateThickness, dogBoneThickness, yRailOffset) {
    cuttingRadius = toolType == P3D ? 0 : toolType == CNC ? dogBoneCNCBitRadius : dogBoneWJRadius;
    tolerance = toolType == P3D ? 0 : cncTabTolerance;
    kerf = toolType == WJ ? wjKerf : 0;
    xStep = 20;
    dogboneSize = [xStep, plateThickness*2, dogBoneThickness];
    sizeX = eX + 2*eSizeX;

    start = sizeX == 220 ? xStep/2 + eSizeZ : 2*xStep + 5;
    end = sizeX == 220 ? sizeX : sizeX - 2*xStep;
    for (x = [start : xStep*2 : end])
        translate([x + dogboneSize.x/2, eZ, -dogBoneThickness])
            edgeCutout_y(dogboneSize, cuttingRadius, tolerance, kerf);
    /*if (cnc)
    if (sizeX == 220) {
        endDogboneSize = [3*xStep/2 - yRailOffset, plateThickness*2, dogBoneThickness];
        for (x = [yRailOffset, eX + 2*eSizeX - endDogboneSize.x - yRailOffset])
            translate([x - eps + endDogboneSize.x/2, eZ])
                edgeCutout_y(endDogboneSize, cuttingRadius, tolerance, kerf);*/
    if (sizeX == 270) {
        endDogboneSize = [xStep + 5, plateThickness*2, dogBoneThickness];
        for (x = [0, sizeX - endDogboneSize.x])
            translate([x - eps + endDogboneSize.x/2, eZ])
                edgeCutout_y(endDogboneSize, cuttingRadius, tolerance, kerf);
    }
}

module sideFaceBackTabs() {
    yStep = 20;
    fillet = _fillet;
    tabSize = [3*2, yStep];

    x = eY + 2*eSizeY;
    translate([x - tabSize.x/2, 0])
        square([tabSize.x/2, eZ]);
    start = eZ - floor(eZ/20) * 20;
    // middle tabs
    for (y = [start + yStep*2 : yStep*2 : eZ - yStep*2 + start])
        translate([x, y])
            rounded_square(tabSize, fillet);
    // bottom tab
    for (y = [(tabSize.y/2 + start)/2])
        translate([x, y])
            rounded_square([tabSize.x, tabSize.y/2 + start], fillet);
    // top tab
    for (y = [eZ - tabSize.y/4])
        translate([x, y])
            rounded_square([tabSize.x, tabSize.y/2], fillet);
}

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

module zipTieCutout() {
    cutoutSize = [5, 4, 2];
    cutoutDepth = cutoutSize.x/2;

    translate([0, -cutoutSize.y/2, - cutoutSize.z - cutoutDepth]) {
        difference() {
            union() {
                translate([-eps, 0, 0])
                    cube(cutoutSize + [eps, 0, 0]);
                translate([cutoutSize.x - cutoutSize.z, 0, 0])
                    cube([cutoutSize.z, cutoutSize.y, cutoutSize.z + cutoutDepth + 2*eps]);
                translate([cutoutSize.x - cutoutSize.z + eps, -eps, cutoutSize.y - cutoutSize.z - eps])
                    rotate([90, 0, 180])
                        right_triangle(1.5, 1.5, cutoutSize.y + 2*eps, center=false);
            }
            // add a fillet to make it easier to insert the ziptie
            translate([cutoutSize.x + eps, -eps, -eps])
                rotate([90, 0, 180])
                    fillet(3, cutoutSize.y + 2*eps); // rounded fillet seems to work better than triangular one
                    //right_triangle(1, 1, cutoutSize.y + 2*eps, center=false);
        }
    }
}


