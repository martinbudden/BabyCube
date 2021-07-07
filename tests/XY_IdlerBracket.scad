//! Display the XY idler brackets

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../scad/printed/XY_IdlerBracket.scad>

use <../scad/utils/CoreXYBelts.scad>

use <../scad/Parameters_CoreXY.scad>
use <../scad/Parameters_Positions.scad>
include <../scad/Parameters_Main.scad>


//$explode = 1;
//$pose = 1;
module XY_IdlerBracket_test() {
    echo(idlerBracketSize = idlerBracketSize(coreXYPosBL(_xyNEMA_width)));
    CoreXYBelts(carriagePosition());

    //XY_IdlerBracket(coreXYPosBL(_xyNEMA_width), _xyNEMA_width, _sidePlateThickness);
    //XY_IdlerBracketHardware(coreXYPosBL(_xyNEMA_width));
    //XY_IdlerBracketThreadedInsert(coreXYPosBL(_xyNEMA_width));
    //XY_IdlerBracketCutouts(coreXYPosBL(_xyNEMA_width));
    //XY_Idler_Bracket_Left_stl();
    XY_Idler_Bracket_Left_assembly();
    //XY_Idler_Bracket_Right_stl();
    XY_Idler_Bracket_Right_assembly();
}

if ($preview)
    translate_z(-eZ)
        XY_IdlerBracket_test();
