include <global_defs.scad>

include <NopSCADlib/utils/core/core.scad>

use <printed/BackFace.scad>
use <printed/BackFaceAssemblies.scad>
use <printed/Base.scad>
use <printed/DisplayHousingAssemblies.scad>
include <printed/Extras.scad>
use <printed/FrontFace.scad>
use <printed/LeftAndRightFaceAssemblies.scad>
use <printed/LeftAndRightFaceAssembliesCF.scad>
use <printed/PrintheadAssemblies.scad>
use <printed/TopFaceAssemblies.scad>
use <printed/X_CarriageAssemblies.scad>

include <utils/CoreXYBelts.scad>
include <utils/HolePositions.scad>

use <Parameters_Positions.scad>


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

//! Bolt the **Right_Face_CF_assembly** to the **BaseCF_assembly**
//
module Stage_1_CF_assembly()
staged_assembly("Stage_1_CF", big=true, ngb=true) {

    translate_z(-eps)
        staged_explode()
            BaseCF_assembly();

    explode([100, 50, 0], true, show_line=false) {
        Right_Face_CF_assembly();
        explode([50, 0, 0], true, show_line=false) {
            rightFaceIEC();
            rightFaceIEC_hardware();
        }

        translate([eX + 2 * eSizeX, 0, 0])
            rotate([90, 0, 90])
                lowerSideJoinerHolePositions(left=false)
                    boltM3Buttonhead(8);
    }
}

//! Bolt the **Left_Face_CF_assembly** to the base
//
module Stage_2_CF_assembly()
staged_assembly("Stage_2_CF", big=true, ngb=true) {

    Stage_1_CF_assembly();

    explode([-100, 0, 25], true) {
        Left_Face_CF_assembly();
        rotate([90, 0, 90])
            lowerSideJoinerHolePositions(left=true)
                vflip()
                    explode(10, true)
                        boltM3Buttonhead(8);
    }
}

//! Bolt the **Back_Face_CF_assembly** to the base and left and right faces.
//
module Stage_3_CF_assembly()
staged_assembly("Stage_3_CF", big=true, ngb=true) {

    Stage_2_CF_assembly();

    explode([0, 200, 0], true) {
        Back_Face_CF_assembly();
        translate([0, eY + 2*eSizeY, 0])
            rotate([90, 0, 0]) {
                backFaceAllHolePositions(-_backPlateCFThickness)
                    vflip()
                        explode(50)
                            boltM3Buttonhead(10);
                backFaceCFSideHolePositions(-_backPlateCFThickness)
                    vflip()
                        explode(50)
                            boltM3Buttonhead(10);
                backFaceBracketHolePositions(-_backPlateCFThickness)
                    vflip()
                        explode(50)
                            boltM3Buttonhead(10);
            }
            baseBackHolePositions(-_backPlateCFThickness)
                vflip()
                    boltM3Buttonhead(10);
    }
    if (!exploded())
        backFaceCableTies();
}


//! Bolt the **Front_Face_CF_assembly** to the base and left and right faces.
//
module Stage_4_CF_assembly()
staged_assembly("Stage_4_CF", big=true, ngb=true) {

    Stage_3_CF_assembly();

    explode([0, -100, 0], true) {
        rotate([90, 0, 0]) {
            frontFaceSideHolePositions()
                boltM3Buttonhead(10);
            frontFaceLowerHolePositions()
                boltM3Buttonhead(10);
        }
        Front_Face_CF_assembly();
    }
}

//! Add the **Top_Face_CF_assembly**.
//
module Stage_5_CF_assembly()
staged_assembly("Stage_5_CF", big=true, ngb=true) {

    Stage_4_CF_assembly();

    explode(100)
        Top_Face_CF_assembly();
    rotate([90, 0, 0])
        backFaceCFTopHolePositions(-eY - 2*eSizeY - _backPlateCFThickness)
            vflip()
                explode(50, true)
                    boltM3Buttonhead(10);
    staged_explode()
        explode(100, true) {
            topFaceSideHolePositions(eZ)
                explode(20, true)
                    boltM3Buttonhead(8);
            topFaceFrontHolePositions(eZ)
                explode(50, true)
                    boltM3Buttonhead(8);
        }
}

//! Thread the belts as shown and attach to the **X_Carriage_Belt_Side**.
//
module Stage_6_CF_assembly()
staged_assembly("Stage_6_CF", big=true, ngb=true) {

    Stage_5_CF_assembly();

    explode(250, true)
        CoreXYBelts(carriagePosition());
    explode(100, true)
        printheadBeltSide();
}

module CF_FinalAssembly() {
    translate([-(eX + 2*eSizeX)/2, - (eY + 2*eSizeY)/2, -eZ/2]) {
        Stage_6_CF_assembly();

        explode(100, true)
            printheadHotendSide();
        explode([100, 0, 100])
            faceRightSpoolHolder(cf=true);
        if (!exploded()) {
            printheadWiring(carriagePosition());
            explode(150)
                bowdenTube(carriagePosition());
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
            printheadBeltSide();
            printheadHotendSide();
        }
        explode([0, explode, 0])
            Back_Face_CF_assembly();
        explode([0, -explode, 0])
            Front_Face_CF_assembly();
        explode([-explode, 0, 0])
            Left_Face_CF_assembly();
        explode([explode, 0, 0])
            Right_Face_CF_assembly();
        explode(-eps)
            translate_z(-eps)
                BaseCF_assembly();
        if (!exploded()) {
            printheadWiring(carriagePosition());
            explode(150)
                bowdenTube(carriagePosition());
            explode([75, 0, 100])
                faceRightSpoolHolder(cf=true);
            explode([150, 0, 0])
                faceRightSpool(cf=true);
        }
    }
}
