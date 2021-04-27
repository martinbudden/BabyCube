include <../global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/wire.scad>
use <NopSCADlib/utils/fillet.scad>

use <../vitamins/bolts.scad>
use <../vitamins/XT_Connectors.scad>

use <LeftAndRightFaces.scad>
use <XY_IdlerBracket.scad>

include <../Parameters_Main.scad>
use <../Parameters_CoreXY.scad>


module wire_swg(colour, length, swg)   //! Add SWG wire to the BOM
    vitamin(str(": Wire ", colour, " ", swg, "SWG, length ", length, "mm"));


XT60HolderOffsetY = 3;
XT60_offset = eSizeZ + XT60HolderOffsetY + 1 + 2*XT60FemaleHolderSize().x;
insideThickness = 3;

function switchShroudSize() = [60, 85, idlerBracketSize(coreXYPosBL(_xyNEMA_width)).z];

//!1. Place the XT60 connectors through the Switch_Shroud and use the Switch_Shroud_Clamp to keep them in place.
module Switch_Shroud_assembly()
    assembly("Switch_Shroud", ngb = true) {

    translate([0, eps, 0])
        rotate([90, 0, 90]) {
            hflip() {
                stl_colour(pp2_colour)
                    Switch_Shroud_stl();
                Switch_Shroud_hardware();
            }
            stl_colour(pp1_colour)
                Switch_Shroud_Clamp_stl();
            Switch_Shroud_Clamp_hardware();
        }
}

module Switch_Shroud_stl() {

    size = switchShroudSize() - [frontReinforcementThickness(), 0, _webThickness];
    sizeN = switchShroudSize();
    fillet = 0;
    sideThickness = 5;
    frontCutoutHeight = 50;
    topThickness = 8;

    stl("Switch_Shroud")
    color(pp2_colour)
    hflip()
        render(convexity=4)
        difference() {
            union() {
                translate([frontReinforcementThickness(), 0, 0]) {
                    // inside plate
                    translate_z(size.z - insideThickness + _webThickness)
                        rounded_cube_xy([size.x, size.y, insideThickness], 0);
                    *translate([size.x-sideThickness, 0, eSizeXBase])
                        rounded_cube_xy([sideThickness, eSizeZ+fillet, size.z-eSizeXBase+_webThickness], fillet);
                    translate([size.x - sideThickness, XT60_offset-fillet-1, _webThickness])
                        rounded_cube_xy([sideThickness, size.y - XT60_offset+1, size.z], fillet);
                    translate([size.x - XT60FemaleHolderSize().z, eSizeZ, _webThickness])
                        cube([XT60FemaleHolderSize().z, XT60_offset - eSizeZ, 2]);
                    translate([size.x - XT60MaleHolderSize().z, eSizeZ, _webThickness])
                        cube([XT60MaleHolderSize().z, XT60MaleHolderSize().x + XT60HolderOffsetY, 2]);
                }
                // top
                translate([frontReinforcementThickness(), size.y -topThickness, eSizeX])
                        rounded_cube_xy([size.x, topThickness, size.z - _webThickness], fillet);
                translate([eSizeY, size.y - topThickness, _webThickness])
                    rounded_cube_xy([size.x-eSizeY, topThickness, eSizeX - _webThickness], fillet);
                // bottom
                translate([eSizeXBase, 0, eSizeY])
                    cube([size.x + frontReinforcementThickness() - eSizeXBase, eSizeZ, size.z + _webThickness - eSizeY]);
                *translate([sizeN.x - XT60MaleHolderSize().z, eSizeZ, eSizeXBase])
                    rotate(90)
                        fillet(1, sizeN.z - eSizeXBase);
                *translate([sizeN.x-5, XT60_offset, _webThickness])
                    rotate(90)
                        fillet(1, sizeN.z-_webThickness);
                translate([sizeN.x - XT60FemaleHolderSize().z, XT60_offset - 1, _webThickness])
                    cube([XT60FemaleHolderSize().z, 1, sizeN.z-_webThickness]);
                translate([sizeN.x - XT60MaleHolderSize().z, eSizeZ, _webThickness])
                    cube([XT60MaleHolderSize().z, XT60HolderOffsetY, sizeN.z - _webThickness]);
                translate([sizeN.x - 5, sizeN.y - topThickness, _webThickness])
                    rotate(180)
                        fillet(2, sizeN.z - _webThickness);
                translate([size.x + frontReinforcementThickness(), eSizeZ + XT60FemaleHolderSize().x/2 + XT60HolderOffsetY, size.z/2 + _webThickness]) {
                    translate([-XT60MaleHolderSize().z, 0, 0])
                        rotate([90, 0, 90])
                            XT60MaleHolder();
                    translate([-XT60FemaleHolderSize().z, XT60FemaleHolderSize().x, 0])
                        rotate([90, 0, 90])
                            XT60FemaleHolder();
                }
            }
            cutoutFillet = 1;
            // inside plate cutout
            translate([0, -2*cutoutFillet, _webThickness+ size.z - insideThickness-eps])
                rounded_cube_xy([eSizeY, frontCutoutHeight + 2*cutoutFillet, insideThickness + 2*eps], cutoutFillet);
            switchShroudHolePositions()
                boltHoleM3Tap(sizeN.z - 4);
            translate_z(-eps) {
                fillet = 2;
                translate([eSizeY, 0])
                    fillet(fillet, sizeN.z + 2*eps);
                translate([eSizeY, eSizeZ, eps])
                    rotate(270)
                        fillet(fillet, sizeN.z - insideThickness);
                translate([sizeN.x - XT60FemaleHolderSize().z, XT60_offset, eps])
                    rotate(270)
                        fillet(1, sizeN.z - insideThickness);
                translate([frontReinforcementThickness(), size.y - topThickness, eps])
                    rotate(0)
                        fillet(fillet, sizeN.z - insideThickness);
                translate([frontReinforcementThickness(), frontCutoutHeight, eps])
                    rotate(0)
                        fillet(fillet, sizeN.z + 2*eps);
                translate([sizeN.x, 0])
                    rotate(90)
                        fillet(fillet, sizeN.z + 2*eps);
                translate([sizeN.x, sizeN.y])
                    rotate(180)
                        fillet(fillet, sizeN.z + 2*eps);
                translate([frontReinforcementThickness(), sizeN.y])
                    rotate(270)
                        fillet(fillet, sizeN.z + 2*eps);
                translate([frontReinforcementThickness()+ size.x - XT60MaleHolderSize().z, eSizeZ + XT60MaleHolderSize().x + XT60HolderOffsetY, -insideThickness+eps])
                    rotate(270)
                        fillet(1, sizeN.z);
                translate([sizeN.x-eSizeY - 10, eSizeZ+XT60HolderOffsetY+XT60MaleHolderSize().x, size.z])
                    hull()
                        for (x = [-3, 2])
                            translate([x, 0, 0])
                                boltHoleM3(5);
            }
        }
}

module Switch_Shroud_hardware() {
    size = switchShroudSize() - [frontReinforcementThickness(), 0, _webThickness];
    sizeN = switchShroudSize();

    hflip()
        translate([sizeN.x, eSizeZ + XT60HolderOffsetY + XT60FemaleHolderSize().x/2, (sizeN.z + _webThickness)/2]) {
            translate([-1, 0, 0])
                rotate([90, 0, -90])
                    XT60Male();
            translate([-8.5, XT60MaleHolderSize().x, 0])
                rotate([-90, 180, -90])
                    XT60Female();
        }
    wire_swg("black", 100, 12);
    wire_swg("black", 100, 12);
    wire_swg("red", 100, 12);
    wire_swg("red", 100, 12);
    hidden() XT60Male();
    hidden() XT60Female();
}

module Switch_Shroud_bolts() {
    rotate([90, 0, 90]) {
        switchShroudHolePositions(z=0, cutoff=-1)
            vflip()
                boltM3Countersunk(16);
        switchShroudHolePositions(z=0, cutoff=1)
            vflip()
                boltM3Countersunk(12);
    }
}

module switchShroudHolePositions(z = 0, cutoff = 0) {
    size = switchShroudSize() - [frontReinforcementThickness(), 0, _webThickness];

    inset = 5;
    insetTop = 4;
    for (i = [
            [7.5 + 3, inset],
            [3, size.y - insetTop],
            [size.x - inset - 1, inset],
            [size.x - inset - 1, size.y - insetTop]
            ]
        )
        if (cutoff == 0) {
            translate([i.x + frontReinforcementThickness(), i.y, z])
                children();
        } else if (cutoff > 0) {
            if (i.y > size.y/2)
                translate([i.x + frontReinforcementThickness(), i.y, z])
                    children();
        } else {
            if (i.y < size.y/2)
                translate([i.x + frontReinforcementThickness(), i.y, z])
                    children();
        }
}

module Switch_Shroud_Clamp_stl() {

    sizeN = switchShroudSize();
    sizeX = 10;

    cutoutSize = [20, 5.75, 20];
    fillet = 1;

    stl("Switch_Shroud_Clamp")
    translate([-4, 0, 0])
    difference() {
        translate([sizeN.x - XT60MaleHolderSize().z - sizeX, eSizeZ, _webThickness]) {
            rounded_cube_xy([sizeX, XT60FemaleHolderSize().x + XT60MaleHolderSize().x + XT60HolderOffsetY, XT60MaleHolderSize().y-1.5], fillet);
            translate([eSizeY-2*fillet, XT60MaleHolderSize().x + XT60HolderOffsetY, 0])
                rounded_cube_xy([XT60MaleHolderSize().z - XT60FemaleHolderSize().z + 2*fillet + 2, XT60FemaleHolderSize().x, XT60MaleHolderSize().y-1.5], fillet);
        }
        for (y = [0, XT60MaleHolderSize().x])
            translate([sizeN.x-eSizeY-cutoutSize.x + 3, y+eSizeZ+XT60HolderOffsetY+XT60MaleHolderSize().x/2-cutoutSize.y/2, _webThickness+5-1.5])
                cube(cutoutSize);

        translate([sizeN.x-eSizeY-4-4, eSizeZ+XT60HolderOffsetY+XT60MaleHolderSize().x, _webThickness+10])
            boltHoleM3Tap(10);
    }
}

module Switch_Shroud_Clamp_hardware() {
    sizeN = switchShroudSize();

    if ($preview) {
        translate([-4, 0, 0])
            translate([sizeN.x - eSizeY - 8, eSizeZ+XT60HolderOffsetY + XT60MaleHolderSize().x, sizeN.z])
                boltM3Buttonhead(10);
    }
}
