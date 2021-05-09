include <NopSCADlib/core.scad>
include <NopSCADlib/utils/core_xy.scad>
include <NopSCADlib/vitamins/washers.scad>
include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/vitamins/rails.scad>

include <Parameters_Main.scad>


GT2x9 = ["GT", 2.0,  9, 1.38, 0.75, 0.254];
GT2x16x11_toothed_idler = ["GT2x16_toothed_idler", "GT2",   16,  9.75, GT2x9, 11.0,  14, 0,   3, 14.0, 1.0, 0, 0,    false,         0];
GT2x16x11_plain_idler =   ["GT2x16x7_plain_idler", "GT2",    0,  9.63, GT2x9, 11.0,  13, 0,   3, 13.0, 1.0, 0, 0,    false,         0];

coreXY_GT2x9_20_16=["coreXY_20_16", GT2x9, GT2x20ob_pulley, GT2x16x11_toothed_idler, GT2x16x11_plain_idler, [0, 0, 1], [0, 0, 0.5, 1], [0, 1, 0], [0, 0.5, 0, 1] ];

function coreXY_type() = _beltWidth == 6 ? coreXY_GT2_20_16 : coreXY_GT2x9_20_16;


function yRailSupportThickness() = 3; // was 8// needs to be at least 7.5 to clear the side bolt holes
function yRailShiftX() = 1; // limit it this to [-0.5, +1.25] avoid problems with yCarriage bolt interference
//function yRailOffset(NEMA_width) = [_yRailLength/2 + (_fullLengthYRail ? 0 : eSizeY), eZ - yRailSupportThickness(), coreXYPosBL(NEMA_width).x - coreXYSeparation().x + yRailShiftX()];
function yRailOffset(NEMA_width) = [coreXYPosBL(NEMA_width).x - coreXYSeparation().x + yRailShiftX(), _yRailLength/2 + (_fullLengthYRail ? 0 : eSizeY), eZ - yRailSupportThickness()];
function yCarriageThickness() = 8;
function yCarriageBraceThickness() = 1; // brace to support cantilevered pulleys on yCarriage

// offset to midpoint between the two belts
function beltOffsetZ() = yCarriageThickness() - coreXYSeparation().z - 26 + yCarriageBraceThickness()/2;
//function beltOffsetZ() = eZ - coreXYPosBL().z - yRailSupportThickness() - 55;
//function beltOffsetZ() =  yCarriageThickness() + 19.5 - 55;


// use -12.75 for separation.x to make y-carriage idlers coincident vertically
function  coreXYSeparation() = [
    0,
    coreXY_coincident_separation( coreXY_type() ).y, // make Y carriage pulleys coincident in Y
    // Z separation is a pulley with a washer either side and an optional brace for the yCarriage pulleys
    pulley_height(coreXY_toothed_idler( coreXY_type() )) + 2*washer_thickness(M3_washer) + yCarriageBraceThickness()
];


function motorClearance() = [ 2, 8, 0.5 ]; // y value was 6, changed to 8 for better carbon fiber variants, should hot affect print volume
__idlerClearanceY = _useCNC ? 4 : 1;

function coreXYPosBL(NEMA_width, yCarriageType=MGN9C_carriage) = [
    is_undef(NEMA_width) ? undef : NEMA_width/2 - coreXY_drive_pulley_x_alignment( coreXY_type() ) + motorClearance().x,
    pulley_flange_dia(GT2x16_toothed_idler)/2 + __idlerClearanceY,
    // choose Z so the belts align with the Y_Carriage pulleys
    is_undef(yCarriageType) ? 0 : eZ - coreXYSeparation().z - yRailSupportThickness() - yCarriageThickness() - carriage_height(yCarriageType) + yCarriageBraceThickness()/2
];


function coreXYPosTR(NEMA_width, yCarriageType=MGN9C_carriage) = [
    // make X value symmetric with BL x-value
    eX + 2*eSizeX - coreXYPosBL(NEMA_width).x,
    eY + 2*eSizeY - NEMA_width/2 - motorClearance().y,
    // same as BL z-value
    coreXYPosBL(NEMA_width, yCarriageType).z
];
