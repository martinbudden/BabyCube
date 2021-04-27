include <Parameters_main.scad>

// set $t = 2 for mid position
$t = 2;

// Print head movement is [113, 68, 63] with E3D hotend, [118.5, 68, 63] for non-E3D

_xMin = 33;// limited by part cooling fan hitting belts, Y_Carriage endstop set to prevent this
_xMax = eX - 2*eSizeX - 52; // for E3D hotend, limited by hotend fan hitting belts (replace -10 by -4.5 for non-E3D)
_yMin = 30.85; // limited by Y carriage hitting idler and X carriage front bolts hitting top face
_yMax = eY - 67;
_zMin = _printBedSize == 100 ? 77.35 : 59.5;
_zMax = eZ - (_printBedSize == 100 ? 60.65 : 81);

// note values of _zRodSeparation (for zRodOffsetX) and heatedBedOffset

// In animation $t takes values from 0 to 1

// X-axis
function xPos(t) = t==-1 ? 0 : t==2 ? (_xMin + _xMax)/2 : t==3 ? _xMin : t==4 ? _xMax : t==5 ? _xMax : t==6 ? _xMin : _xMax;
function xPosAnimate(t) = eX/2 + t*100;
__carriagePositionX = $t > 1 ? xPos($t) : xPosAnimate($t);

// Y-axis
function yPos(t) = t==-1 ? 0 : t==2 ? (_yMin + _yMax)/2 : t==3 ? _yMin : t==4 ? _yMin : _yMax;
function yPosAnimate(t) = eY/2 + t*100;
__carriagePositionY = $t > 1  ? yPos($t) : yPosAnimate($t);

function carriagePosition() = [__carriagePositionX, __carriagePositionY];

// Z-axis
function zPos(t) = t==2 ? _zMin : t==7 ? (_zMin + _zMax)/2 - 15 : _zMax;
function zPosAnimate(t) = _zMax - t*10;
function bedHeight() = $t > 1 ? zPos($t) : zPosAnimate($t);
