include <target.scad>

_cubeName = "BabyCube";
_blowerDescriptor = "BL30x10";

// the base, top, and side plates, back plate is defined in variant
_basePlateThickness = 3;
_topPlateThickness = 3;
_topPlateCoverThickness = 4;
_sidePlateThickness = 3;
_backPlateThickness = 4;
_backPlateCFThickness = 3;
_frontPlateCFThickness = 3;

_sideTabs = true;
_backFaceSideCutouts = _sideTabs;
_backFaceTopCutouts = true;

_useSideHoles = false;
_useFrontHoles = false;
_useInsertsForYRail = false;
_useInsertsForFaces = false;
_useInsertsForRodBrackets = false;
_useDebugColors = false;


eSizeXBase = 10; // always use 10mm wide chords on base
eSizeY = 10; // needs to be 10 for faceConnectors
eSizeZ = 10;

eX = _chordLengths.x - 2*eSizeX;
eY = _chordLengths.y - 2*eSizeY;
eZ = _chordLengths.z;

_backFaceHoleInset = 8;//eSizeX/2 + 4;
_baseBoltHoleInset = _useCNC ? [eSizeXBase/2 + 2, eSizeY/2 + 2] : [eSizeXBase/2 + 1, eSizeY/2 + 1];//eSizeX/2;
_cornerHoleInset = 20;

_webThickness = 4;
_fillet = 1;

_xyNEMA_width = !is_undef(_xyMotorDescriptor) && _xyMotorDescriptor == "NEMA14" ? 35.2 : 42.3;
_xyMotorBracketThickness = 6;

_zNEMA_width = _zMotorDescriptor == "NEMA14" || _zMotorDescriptor == "NEMA14L" ? 35.2 : 42.3;
_corkDamperThickness = 2;

// Z rods
_zRodDiameter = 12;
_zRodLength = floor(eZ/100)*100;
_zRodSeparation = 100;
_zRodOffsetY = 23; // !! 20 to match SK8 and SK10 is a real squeeze. 23 for SK12 fits well

_zLeadScrewDiameter = 8;
_zLeadScrewOffset = _zRodOffsetY; // ensures clearance of zMotor from frame and alignment with zRods
_zLeadScrewLength = floor((_zRodLength - 25)/50)*50;
