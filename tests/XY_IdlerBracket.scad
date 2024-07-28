//! Display the XY idler brackets

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../scad/printed/XY_IdlerBracket.scad>
use <../scad/printed/TopFaceAssemblies.scad>
use <../scad/printed/FrontFace.scad>

include <../scad/utils/CoreXYBelts.scad>

use <../scad/Parameters_Positions.scad>


//$explode = 1;
//$pose = 1;
module XY_IdlerBracket_test() {
    echo(idlerBracketSize = idlerBracketSize(coreXYPosBL(_xyNEMA_width)));
    CoreXYBelts(carriagePosition(), show_pulleys=[1, 0, 0]);

    //XY_IdlerBracket(coreXYPosBL(_xyNEMA_width), _xyNEMA_width, _sidePlateThickness);
    //XY_IdlerBracketHardware(coreXYPosBL(_xyNEMA_width));
    //XY_IdlerBracketThreadedInsert(coreXYPosBL(_xyNEMA_width));
    //XY_IdlerBracketCutouts(coreXYPosBL(_xyNEMA_width));

    //translate_z(eZ -_topPlateThickness + eps) Top_Face_CF();
    let($hide_bolts=true) topFaceAssembly(_xyNEMA_width, t=5);

    //Front_Face_CF_assembly();
    XY_Idler_Bracket_Left_assembly();
    XY_Idler_Bracket_Right_assembly();
    //rotate(180) translate_z(eZ) XY_Idler_Bracket_Left_stl();
    //translate_z(eZ) XY_Idler_Bracket_Right_stl();
}

if ($preview)
    translate_z(-eZ)
        XY_IdlerBracket_test();
