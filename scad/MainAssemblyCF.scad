include <global_defs.scad>

include <vitamins/bolts.scad>

use <printed/BackFace.scad>
use <printed/BackFaceAssemblies.scad>
use <printed/Base.scad>
use <printed/DisplayHousingAssemblies.scad>
include <printed/Extras.scad>
use <printed/FrontFace.scad>
use <printed/LeftAndRightFaceAssemblies.scad>
use <printed/LeftAndRightFaceAssembliesCF.scad>
use <printed/PrintheadAssemblies.scad>
use <printed/PrintheadAssembliesE3DRevo.scad>
use <printed/TopFaceAssemblies.scad>
use <printed/X_CarriageAssemblies.scad>
use <printed/XY_IdlerBracket.scad>

include <utils/CoreXYBelts.scad>
include <utils/HolePositions.scad>

use <Parameters_Positions.scad>
use <Parameters_CoreXY.scad>


staged_assembly = true; // set this to false for faster builds during development

module staged_assembly(name, big, ngb) {
    if (staged_assembly)
        assembly(name, big, ngb)
            children();
    else
        children();
}

module staged_explode(z=0, show_line=true) {
    if (staged_assembly)
        children();
    else
        translate_z(exploded() ? z : 0)
            explode(eps, false, show_line=show_line)
                children();
}

//! Bolt the **Back_Face_CF_assembly** to the **Base_CF_assembly**.
//
module Stage_1_CF_assembly()
staged_assembly("Stage_1_CF", big=true, ngb=true) {

    translate_z(-eps)
        staged_explode()
            Base_CF_assembly();

    explode([0, 200, 0], true) {
        Back_Face_CF_assembly();
        translate([0, eY + 2*eSizeY, 0])
            rotate([90, 0, 0]) {
                *backFaceAllHolePositions(-_backPlateCFThickness, cf=true)
                    vflip()
                        explode(50)
                            boltM3Buttonhead(10);
                backFaceBracketHolePositions(-_backPlateCFThickness, cnc=true) // bolt back face to base bracket
                    vflip()
                        explode(50)
                            boltM3Buttonhead(10);
            }
            baseBackHolePositions(-_backPlateCFThickness) // bolt back face to base
                vflip()
                    boltM3Buttonhead(10);
    }
}

//! Bolt the **Right_Face_CF_assembly** to the **Base_CF_assembly** and the **Back_Face_CF_assembly**.
//
module Stage_2_CF_assembly()
staged_assembly("Stage_2_CF", big=true, ngb=true) {

    Stage_1_CF_assembly();

    explode([100, 50, 0], true, show_line=false) {
        Right_Face_CF_assembly();

        translate([eX + 2 * eSizeX + eps, 0, 0])
            rotate([90, 0, 90]) {
                lowerSideJoinerHolePositions(left=false) // bolt right face to base
                    explode(10, true)
                        boltM3Buttonhead(8);
                        //boltM3Buttonhead(screw_shorter_than(topBoltHolderSize().z + _sidePlateThickness));
                frontSideJoinerHolePositions(bolts=true) // bolt right face to base front extension
                    explode(10, true)
                        boltM3Buttonhead(10);
                backSideJoinerHolePositions() // bolt right face to back
                    explode(10, true)
                        boltM3Buttonhead(10);
            }
    }
}

//! Bolt the **Left_Face_CF** to the **Base_CF_assembly** and the **Back_Face_CF_assembly**.
//
module Stage_3_CF_assembly()
staged_assembly("Stage_3_CF", big=true, ngb=true) {

    Stage_2_CF_assembly();

    explode([-100, 0, 25], true) {
        translate([-eps, 0, 0])
            rotate([90, 0, 90]) {
                Left_Face_CF();
                lowerSideJoinerHolePositions(left=true) // bolt left face to base
                    vflip()
                        explode(10, true)
                            boltM3Buttonhead(8);
                frontSideJoinerHolePositions(bolts=true) // bolt left face to base front extension
                    vflip()
                        explode(10, true)
                            boltM3Buttonhead(10);
                backSideJoinerHolePositions() // bolt left face to back
                    vflip()
                        explode(10, true)
                            boltM3Buttonhead(10);
            }
    }
}

//! Add the **Top_Face_CF_assembly**.
//
module Stage_4_CF_assembly()
staged_assembly("Stage_4_CF", big=true, ngb=true) {

    Stage_3_CF_assembly();

    explode(100)
        Top_Face_CF_assembly();
    translate([-eps, 0, 0])
        rotate([90, 0, 90]) {
            upperSideJoinerHolePositions() // bolt left face to top
                vflip()
                    explode(10, true)
                        boltM3Buttonhead(8);
            xyMotorMountSideHolePositions()
                vflip()
                    explode(10, true)
                        boltM3Buttonhead(10);
            xyIdlerBracketHolePositions(_xyNEMA_width)
                vflip()
                    explode(10, true)
                        boltM3Buttonhead(10);
        }
    translate([eX + 2*eSizeX + eps, 0, 0]) {
        rotate([90, 0, 90]) {
            upperSideJoinerHolePositions() // bolt right face to top
                explode(10, true)
                    boltM3Buttonhead(8);
            xyMotorMountSideHolePositions()
                explode(10, true)
                    boltM3Buttonhead(10);
            xyIdlerBracketHolePositions(_xyNEMA_width)
                explode(10, true)
                    boltM3Buttonhead(10);
        }
    }
    rotate([90, 0, 0])
        backFaceCFTopHolePositions(-eY - 2*eSizeY - _backPlateCFThickness) // bolt back face to top
            vflip()
                explode(50, true)
                    boltM3Buttonhead(10);
    rotate([90, 0, 0])
        for (left = [true, false])
            xyMotorMountBackHolePositions(left=left, z= -eY - 2*eSizeY - _backPlateCFThickness) // bolt back face to motor mounts
                vflip()
                    boltM3Buttonhead(10);
}

//! Bolt the **Front_Face_CF_** to the base and the top, left, and right faces.
//
module Stage_5_CF_assembly()
staged_assembly("Stage_5_CF", big=true, ngb=true) {

    Stage_4_CF_assembly();

    explode([0, -100, 0], true) {
        rotate([90, 0, 0]) {
            frontFaceSideHolePositions()
                boltM3Buttonhead(10);
            frontFaceLowerHolePositions()
                boltM3Buttonhead(10);
        }
        rotate([90, 0, 0])
            Front_Face_CF();
    }
    rotate([90, 0, 0])
        explode(20, true, show_line=false) {
            stl_colour(grey(30))
                Nameplate_stl();
            nameplateText();
            frontFaceUpperHolePositions(3)
                boltM3Buttonhead(12);
        }
}

module CF_FinalAssembly() {
    translate([-(eX + 2*eSizeX)/2, - (eY + 2*eSizeY)/2, -eZ/2]) {
        Stage_5_CF_assembly();

        explode(100, true)
            printheadHotendSideE3DRevo();
        explode([100, 0, 100])
            faceRightSpoolHolder(cf=true);
        if (!exploded()) {
            printheadWiring(carriagePosition(), "E3DRevo");
            explode(150)
                bowdenTube(carriagePosition(), "E3DRevo");
            explode([150, 0, 0])
                faceRightSpool(cf=true);
        }
    }
}


module CF_DebugAssembly() {
    translate([-(eX + 2*eSizeX)/2, - (eY + 2*eSizeY)/2, -eZ/2]) {
        explode = 100;
        explode(explode + 25) {
            Top_Face_CF_assembly();
            printheadHotendSideE3DRevo();
        }
        explode([0, explode, 0])
            Back_Face_CF_assembly();
        explode([0, -explode, 0])
            rotate([90, 0, 0])
                Front_Face_CF();
        explode([-explode, 0, 0])
            translate([-eps, 0, 0])
                rotate([90, 0, 90])
                    Left_Face_CF();
        explode([explode, 0, 0])
            Right_Face_CF_assembly();
        explode(-eps)
            translate_z(-eps)
                Base_CF_assembly();
        if (!exploded()) {
            printheadWiring(carriagePosition(), "E3DRevo");
            explode(150)
                bowdenTube(carriagePosition(), "E3DRevo");
        }
    }
}
