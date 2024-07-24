_variant = "BC220CF";

_useCNC = true;

_backPlateOutset = [0, 0];

_tabTolerance = 0.05; // for CNC, 0.05 each side gives 0.1 total tolerance

_chordLengths = [220, 220, 210];

eSizeX = 10;

_xyMotorDescriptor = "NEMA14";
_zMotorDescriptor = "NEMA17_34L150";

_psuDescriptor = "NG_CB_200W_24V";

_xRailLength = 150;
_yRailLength = floor(_chordLengths.y/50)*50;
// set _fullLengthYRail to add end cutouts for Y rail
_fullLengthYRail = _yRailLength == _chordLengths.y ? true : false;
_backFaceUpperBracketOffset  = 3;
_zRodOffsetZ  = _chordLengths.z == 200 ? 0 : _chordLengths.z - 200 - 3; // 3 is topPlateThickness
_backFaceLowerBracketOffset  = _zRodOffsetZ == 0 ? 0 : _zRodOffsetZ;
_xCarriageDescriptor = "MGN9C";
_xCarriageCountersunk = false;
_yCarriageDescriptor = "MGN9C";
//_coreXYDescriptor = "GT2_20_16";
_coreXYDescriptor = "GT2_20_F623";
_useReversedBelts = true;

_useFrontDisplay = false;
_useFrontSwitch = false;
_useHalfCarriage = false;

_printBedSize = 120;