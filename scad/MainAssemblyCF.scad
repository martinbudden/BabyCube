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


staged_assembly = !true; // set this to false for faster builds during development

module staged_assembly(name, big, ngb) {
    if (staged_assembly)
        assembly(name, big, ngb)
            children();
    else
        children();
}

module staged_explode(z=0) {
    if (staged_assembly)
        children();
    else
        translate_z(exploded() ? z : 0)
            explode(eps, false)
                children();
}

//! Bolt the left face and the left feet to the base
//
module Stage_1_CF_assembly()
staged_assembly("Stage_1_CF", big=true, ngb=true) {

    explode([-100, 0, 25])
        Left_Face_CF_assembly();

    translate_z(-eps)
        staged_explode()
            Base_assembly();

    explode(-20, true)
        translate_z(-eps) {
            stl_colour(pp2_colour)
                baseLeftFeet();
            staged_explode()
                baseLeftFeet(hardware=true);
        }
    staged_explode()
        explode(-40)
            baseLeftHolePositions(-_basePlateThickness)
                vflip()
                    boltM3Buttonhead(8);
}

//! Bolt the right face and the right feet to the base
//
module Stage_2_CF_assembly()
staged_assembly("Stage_2_CF", big=true, ngb=true) {

    Stage_1_CF_assembly();

    explode([100, 50, 0])
        Right_Face_CF_assembly();

    explode(-20, true)
        translate_z(-eps) {
            stl_colour(pp2_colour)
                baseRightFeet();
            staged_explode()
                baseRightFeet(hardware=true);
        }
    staged_explode()
        explode(-40)
            baseRightHolePositions(-_basePlateThickness)
                vflip()
                    boltM3Buttonhead(8);
}

//! Add the back face.
//
module Stage_3_CF_assembly()
staged_assembly("Stage_3_CF", big=true, ngb=true) {

    Stage_2_CF_assembly();

    explode([0, 200, 0], true) {
        Back_Face_CF_assembly();
        translate([0, eY + 2*eSizeY, 0])
            rotate([90, 0, 0]) {
                backFaceAllHolePositions(-_backPlateThickness, cf=true)
                    vflip()
                        explode(50)
                            boltM3Buttonhead(10);
                backFaceBracketHolePositions(-_backPlateThickness)
                    vflip()
                        explode(50)
                            boltM3Buttonhead(10);
            }
            baseBackHolePositions(-_basePlateThickness)
                vflip()
                    boltM3Buttonhead(10);
    }
    if (!exploded())
        backFaceCableTies();
}


//! Add the Front Face
//
module Stage_4_CF_assembly()
staged_assembly("Stage_4_CF", big=true, ngb=true) {

    Stage_3_CF_assembly();

    explode([0, -100, 0], true) {
        rotate([90, 0, 0]) {
            frontFaceHolePositions()
                boltM3Buttonhead(12);
            frontFaceLowerHolePositions()
                boltM3Buttonhead(12);
        }
        frontFaceCFAssembly();
    }
}

//! Add the Top Face
//
module Stage_5_CF_assembly()
staged_assembly("Stage_5_CF", big=true, ngb=true) {

    Stage_4_CF_assembly();

    explode(100)
        Top_Face_CF_assembly();
    staged_explode(100)
        explode(100, true)
            topFaceAllHolePositions(eZ)
                boltM3Buttonhead(8);
}

//! Thread the belts as shown and attach to the X_Carriage_Belt_Side.
//
module Stage_6_CF_assembly()
staged_assembly("Stage_5_CF", big=true, ngb=true) {

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


module CF_DebugAssembly() {
    translate([-(eX + 2*eSizeX)/2, - (eY + 2*eSizeY)/2, -eZ/2]) {
        explode = 75;
        explode(explode + 25) {
            Top_Face_CF_assembly();
            printheadBeltSide();
            printheadHotendSide();
        }
        explode([0, explode, 0])
            Back_Face_CF_assembly();
        explode([0, -explode, 0])
            frontFaceCFAssembly();
        explode([-explode, 0, 0])
            Left_Face_CF_assembly();
        explode([explode, 0, 0])
            Right_Face_CF_assembly();
        explode(-eps)
            translate_z(-eps)
                Base_assembly();
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
