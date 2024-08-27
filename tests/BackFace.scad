//! Display the back face

include <NopSCADlib/utils/core/core.scad>
//include <NopSCADlib/vitamins/cameras.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../scad/printed/BackFace.scad>
use <../scad/printed/BackFaceAssemblies.scad>
//use <../scad/printed/LeftAndRightFaceAssemblies.scad>
//use <../scad/printed/LeftAndRightFaceAssembliesCF.scad>

//use <../scad/printed/TopFaceAssemblies.scad>
//use <../scad/printed/Printbed.scad>
//use <../scad/printed/Printbed3point.scad>
use <../scad/utils/printParameters.scad>

use <../scad/config/Parameters_Positions.scad>
include <../scad/config/Parameters_CoreXY.scad>
include <../scad/utils/CoreXYBelts.scad>

//$explode = 1;
//$pose = 1;
module Back_Face_test() {
    t = 3;
    echoPrintSize();
    echo(_zRodSeparation=_zRodSeparation);
    //backFace(zMotorType(),false);
    //CoreXYBelts(carriagePosition(t), show_pulleys=true);

    //topFaceMotors(xyMotorType());
    //translate_z(bedHeight(t)) Print_bed_3_point_assembly();
    //translate_z(bedHeight(t)) Print_bed_assembly();
    //translate_z(_zMin) Print_bed_3_point_printed_assembly();

    if (_useCNC) {
        //translate([0, eY + 2*eSizeY + eps, 0]) rotate([90, 0, 0])
        //translate_z(-4) backFace(zMotorType())();
        //Back_Face_CF(render=false);
        //translate([0, eY + 2*eSizeY, 0]) rotate([90, 0, 0]) Back_Face_CF();
        //Back_Face_CF_Stage_1_assembly();
        //Back_Face_CF_Stage_2_assembly(bedHeight(t));
        Back_Face_CF_assembly();
    } else {
        //translate([0, eY + 2*eSizeY + eps, 0]) rotate([90, 0, 0]) translate_z(-4) backFace(zMotorType(),false);
        //translate([0, eY + 2*eSizeY, 0]) rotate([90, 0, 0]) Back_Face_CF();
        //Back_Face_CF();
        //Back_Face_Stage_1_assembly();
        Back_Face_assembly(bedHeight(t));
    }
    //Left_Face_assembly();
    //translate([-eps, 0, 0]) rotate([90, 0, 90]) Left_Face_stl();
    //Left_Face_CF_assembly();
    //Right_Face_CF_assembly();
    //Right_Face_assembly();
    //printheadBeltSide(t=t);
    //printheadHotendSideE3DV6(t=t);
    //camera(rpi_camera_v2, fov_distance = eY/2);

    //Top_Face_CF_Stage_1_assembly();
    //Top_Face_Stage_1_assembly(t);
    //Top_Face_CF_assembly();
    //translate_z(eZ - _topPlateThickness) Top_Face_CF();


    //let($preview=false)
    //backFaceLowerBrackets(NEMA17P, 0);
    //backFaceUpperBrackets(_xyNEMA_width);
    //backFaceBare(NEMA17P);
    //backFaceLeftAndRightSideHolePositions() cylinder(r=2, h=10);
    //backFaceHolePositions(left=false) cylinder(r=2, h=10);
    //backFaceCableTies();
    /*
    *translate([0, eY + eSizeY, 0])
        rotate([90, 0, 0]) {
            backFaceBare();
            *backFaceTopBrackets();
            *backFaceBottomBrackets(NEMA17Slim);
        }
    *translate([-eX/2 - eSizeX, -eY, 0])
        //let($preview=false)
        {
            Left_Face_assembly();
            *Right_Face_assembly();
        }
    */
}
let($hide_bolts=true)
if ($preview)
    translate([0, -eY, 0])
        Back_Face_test();
else
    Back_Face_stl();
