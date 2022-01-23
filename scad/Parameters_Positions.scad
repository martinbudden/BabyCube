include <Parameters_main.scad>

// set $t = 2 for mid position
$t = 2;

// Print head movement is [113, 68, 63] with E3D hotend, [118.5, 68, 63] for non-E3D

_xMin = 43.1;// Limited by belt attachment hitting Y_Carriage. Was limited (at 33) by part cooling fan hitting belts, Y_Carriage endstop set to prevent this
_xMax = eX - 2*eSizeX - 53.8; // . For E3D hotend, was limited (at -52) by hotend fan hitting belts
_yMin = _useCNC ? 33.85 : 30.85; // limited by Y carriage hitting idler (and previousy also by X carriage front bolts hitting top face)
_yMax = eY - 67;
_zMin = _printBedSize == 100 ? 77.35 : _useCNC ? 63.5 : 59.5;
_zMax = eZ - (_printBedSize == 100 ? 61.4 : _useCNC ? 59.5 : 81);

// note values of _zRodSeparation (for zRodOffsetX) and heatedBedOffset

// In animation $t takes values from 0 to 1

// X-axis
function xPos(t) = t==-1 ? 0 : t==2 ? (_xMin + _xMax)/2 : t==3 ? _xMin : t==4 ? _xMax : t==5 ? _xMax : t==6 ? _xMin : _xMax;
function xPosAnimate(t) = eX/2 + t*100;

// Y-axis
function yPos(t) = t==-1 ? 0 : t==2 ? (_yMin + _yMax)/2 : t==3 ? _yMin : t==4 ? _yMin : _yMax;
function yPosAnimate(t) = eY/2 + t*100;

function carriagePosition(t=undef) = [is_undef(t) ? ($t > 1  ? xPos($t) : xPosAnimate($t)) : xPos(t), is_undef(t) ? ($t > 1  ? yPos($t) : yPosAnimate($t)) : yPos(t)];

// Z-axis
function zPos(t) = t==2 ? (_zMin + _zMax)/2 - 15 : t==7 ? _zMin : _zMax;
function zPosAnimate(t) = _zMax - t*10;
function bedHeight(t=undef) = is_undef(t) ? ($t > 1 ? zPos($t) : zPosAnimate($t)) : zPos(t);
