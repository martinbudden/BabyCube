_variant = "BC260CF";

_useCNC = true;

_backPlateOutset = [0, 0];

_tabTolerance = 0.05; // for CNC, 0.05 each side gives 0.1 total tolerance

_chordLengths = [270, 260, 260];

eSizeX = 10;

_xyMotorDescriptor = "NEMA17";
_zMotorDescriptor = "NEMA17_34L150";

_psuDescriptor = "NG_CB_200W_24V";

// set _fullLengthYRail to add end cutouts for Y rail
_xRailLength = 200;
_yRailLength = floor(_chordLengths.y/50)*50;
_backFaceUpperBracketOffset  = 50;//_topPlateThickness;
_fullLengthYRail = _yRailLength == _chordLengths.y ? true : false;
_xCarriageDescriptor = "MGN9C";
_xCarriageCountersunk = true;
_yCarriageDescriptor = "MGN9C";
//_coreXYDescriptor = "GT2_20_16";
_coreXYDescriptor = "GT2_20_F623";
_useReversedBelts = true;

_useFrontDisplay = false;
_useFrontSwitch = false;

_printBedSize = 120;