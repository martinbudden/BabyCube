function middleWebOffsetZ() = eZ - 105;

function printheadWiringPosX() = let(zRodOffsetX = (eX + 2*eSizeX - _zRodSeparation)/2) (eX + eSizeX - zRodOffsetX/2 - 4);
//function printheadWiringPosX() = eX + 2*eSizeX -47.5;
//function printheadWiringPos() = [printheadWiringPosX(), eY + 2*eSizeY - 2*printheadWireRadius() - 10, eZ-50];
function printheadWiringPos() = [printheadWiringPosX(), eY + 2*eSizeY - 38+15+4, eZ];
function printheadWireRadius() = 3;

function idlerBracketTopSizeY() = 11;
function idlerBracketTopSizeZ() = 25;

function faceConnectorOverlap() = 10;
function faceConnectorOverlapHeight() = 4;

function backFaceBracketLowerOffset() = [30, 15];
function backFaceBracketUpperOffset() = [30, 15];


//function topFaceMidSideHolePositions() = [ eSizeY + eY/3, eSizeY + 2*eY/3 ];
//function topFaceSideHolePositions() = [ 8, 20, 60, 140, 180 ];
//function topFaceSideHolePositions() = [ 20, 60, 100, 140, 180 ];
function topFaceSideHolePositions() = eY == 180 ? [ 20, 100, 180 ] : [ 30, 110];

// offset of side bolt holes for top plate
holePositionsYRailShiftX = 1;
function topBoltHolderThickness(reversedBelts) = holePositionsYRailShiftX + (reversedBelts ? 6.5 : 7.25);
function topBoltHolderSize(sidePlateThickness=_sidePlateThickness, reversedBelts) = [eY + 2*eSizeY - 15 - (reversedBelts ? 20 : 0) - _frontPlateCFThickness, 8, topBoltHolderThickness(reversedBelts) - sidePlateThickness]; // -15 to avoid back cube, +2.75 to give clearance for bolt hole
function topFaceSideHolePositionOffset() = 3.75 + holePositionsYRailShiftX + 0.5;
function baseBackHoleOffset() = [ floor(_zNEMA_width/2) + 4, 4];
//topBackHoleOffset = [ 20, 4];
function topFaceBackHolePositions() = [ eX/2 + eSizeX ];
function backFaceTopHolePositions() = [ eX/2 + eSizeX - 15, eX/2 + eSizeX + 15 ];
function topFaceBackHolePositionOffsetY() = 4;
function topFaceFrontHolePositionOffsetY() = 8;

function upperSideJoinerHolePositions() = eY == 180 ? [ 40, 80, 120, 160 ] : [ 50, 90, 130 ];
function lowerSideJoinerHolePositions(left) = [ 10, 10 + eY/3, 10 + 2*eY/3, eY + 10 ];
function backSideJoinerHolePositions() =  eZ == 200 ? [ 45, 80 ] : [50, 90 ];
function frontSideJoinerHolePositions(bolts=false) = eZ == 200 ? (bolts ? [40, 80] : [ 40, 80, 120 ]) : [ 50 ];

function backFaceHolePositions(cf=false) = cf ? [eSizeY/2 + 1] : [eSizeY/2 + 1, middleWebOffsetZ() + eSizeY/2, eZ - eSizeY/2 - _topPlateThickness];

function motorUprightZipTiePositions() = [30, middleWebOffsetZ() - 18];

baseCoverInsideHeight = 40;
baseCoverOutsideHeight = 43;

// base
module baseLeftCornerHolePositions(z=0) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    for (x = [_cornerHoleInset],
         y = [_baseBoltHoleInset.y, size.y - _baseBoltHoleInset.y] )
        translate([x, y, z])
            rotate(-90)
                children();
    for (x = [_baseBoltHoleInset.x],
         y = [_cornerHoleInset, size.y - _cornerHoleInset])
        translate([x, y, z])
            rotate(-90)
                children();
}

module baseRightCornerHolePositions(z=0) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    for (x = [size.x - _cornerHoleInset],
         y = [_baseBoltHoleInset.y, size.y - _baseBoltHoleInset.y] )
        translate([x, y, z])
            rotate(90)
                children();
    for (x = [size.x - _baseBoltHoleInset.x],
         y = [_cornerHoleInset, size.y - _cornerHoleInset])
        translate([x, y, z])
            rotate(90)
                children();
}

module baseAllCornerHolePositions(z=0) {
    baseLeftCornerHolePositions(z)
        children();
    baseRightCornerHolePositions(z)
        children();
}

module baseLeftHolePositions(z=0) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    for (x = [ _baseBoltHoleInset.x],
            y = [size.y/2]) //y = [(size.y-eSizeY)/6, -(size.y-eSizeY)/6])
        translate([x, y, z])
            children();
}

module baseRightHolePositions(z=0) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    translate([size.x/2, size.y/2, z])
        for (x = [size.x/2 - _baseBoltHoleInset.x],
             y = [0]) //y = [(size.y-eSizeY)/6, -(size.y-eSizeY)/6])
            translate([x, y, 0])
                rotate(-90)
                    children();
}

module baseFrontHolePositions(z=0, cf=false) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    for (x = cf ? [size.x/2] : [size.x/3 + eSizeX/6, 2*size.x/3 - eSizeX/6],
         y = [_baseBoltHoleInset.y] )
        translate([x, y, z])
            rotate(90)
                children();
}

module baseBackHolePositions(z=0) {
    // this should match backFaceBaseHolePositions
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    for (x = [size.x/2 - baseBackHoleOffset().x, size.x/2 + baseBackHoleOffset().x ],
         y = [size.y - baseBackHoleOffset().y] )
        translate([x, y, z])
            rotate(90)
                children();
}

module baseCoverHolePosition(z=0, coverHolePosY) {
    translate([(eX + 2*eSizeX)/2, coverHolePosY, z])
        children();
}

module baseAllHolePositions(z=0, cf=false, coverHolePosY=0) {
    baseAllCornerHolePositions(z)
        children();
    baseLeftHolePositions(z)
        children();
    baseRightHolePositions(z)
        children();
    baseBackHolePositions(z)
        children();
    baseFrontHolePositions(z, cf)
        children();
    if (coverHolePosY)
        baseCoverHolePosition(z=0, coverHolePosY=coverHolePosY)
            children();

}

// back face
module backFaceBaseHolePositions(y=0) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    for (x = [size.x/2 - baseBackHoleOffset().x, size.x/2 + baseBackHoleOffset().x ])
        translate([x, y, baseBackHoleOffset().y])
            children();
}

module backFaceHolePositions(left, z=0, cf=false) {
    size = [eX + 2*eSizeX, eZ];
    for (y = backFaceHolePositions(cf))
        translate(left ? [_backFaceHoleInset, y, z] : [size.x - _backFaceHoleInset, y, z])
            children();
}

module backFaceLeftAndRightSideHolePositions(z=0, cf=false) {
    backFaceHolePositions(left=true, z=z, cf=cf)
        children();
    backFaceHolePositions(left=false, z=z, cf=cf)
        children();
}

module backFaceCFSideHolePositions(z=0) {
    size = [eX + 2*eSizeX, eZ];
    for (x = [_backFaceHoleInset, size.x - _backFaceHoleInset], y = [30, eZ - 100])
        translate([x, y, z])
            children();
}

// front face
module frontFaceLowerHolePositions(z=0) {
    size = [eX + 2*eSizeX, eZ];
    for (x = [65, size.x - 65])
        translate([x, 10/2, z])
            children();
}

module frontFaceUpperHolePositions(z=0) {
    size = [eX + 2*eSizeX, eZ];
    xPos = eX == 200 ? 85 : eX == 220 ? 80 : 75;
    for (x = [xPos, size.x - xPos])
        translate([x, size.y - _topPlateThickness - eSizeZ/2, z])
            children();
}

module frontFaceSideHolePositions(z=0) {
    size = [eX + 2*eSizeX, eZ];
    // IdlerBracket holes
    for (x = [30, size.x - 30])
        translate([x, size.y - 15.5, z])
            children();
    for (x = [(_sidePlateThickness + eSizeXBase)/2, size.x - (_sidePlateThickness + eSizeXBase)/2],
          //y = [60 : 40 : eZ - 60])
          y = [20, 140])
        translate([x, y + (eZ == 200 ? 0 : 10), z])
            children();
}

// top face
module topFaceFrontHolePositions(z=0, useJoiner=false) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    positions = useJoiner ? (_fullLengthYRail ? [95, size.x - 95] : [25, 95, size.x - 95, size.x - 25]) : [size.x/3 + eSizeX/6, 2*size.x/3 - eSizeX/6];
    for (x = positions)
        translate([x, topFaceFrontHolePositionOffsetY(), z])
            children();
}

module topFaceBackHolePositions(z=0) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    for (x = topFaceBackHolePositions())
        translate([x, eY + 2*eSizeY - topFaceBackHolePositionOffsetY(), z])
            children();
}

module backFaceCFTopHolePositions(z=0) {
    for (x = backFaceTopHolePositions())
        translate([x, eZ - _topPlateThickness - eSizeZ/2, z])
            children();
}

module topFaceLeftSideHolePositions(z=0) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    for (x = [topFaceSideHolePositionOffset()],
         y = topFaceSideHolePositions()
        )
        translate([x, y, z])
            children();
}

module topFaceRightSideHolePositions(z=0) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    for (x = [size.x - topFaceSideHolePositionOffset()],
         y = topFaceSideHolePositions()
        )
        translate([x, y, z])
            children();
}

module topFaceSideHolePositions(z=0) {
    topFaceLeftSideHolePositions(z)
        children();
    topFaceRightSideHolePositions(z)
        children();
}

module sideFaceTopHolePositions(z=topFaceSideHolePositionOffset()) {
    size = [eX + 2*eSizeX, eZ];
    for (x = topFaceSideHolePositions())
        translate([x, size.y - _topPlateThickness, z])
            rotate([90, 0, 0])
                children();
}

module topFaceAllHolePositions(z=0, cf=false) {
    topFaceFrontHolePositions(z, cf)
        children();
    topFaceBackHolePositions(z)
        children();
    topFaceSideHolePositions(z)
        children();
}

module lowerSideJoinerHolePositions(z=0, left=true) {
    size = [eY + 2*eSizeY, eZ];
    for (x = lowerSideJoinerHolePositions(left), y = [5])
        translate([x, y, z])
            children();
}

module upperSideJoinerHolePositions(z=0, reversedBelts) {
    size = [eY + 2*eSizeY, eZ];
    for (x = upperSideJoinerHolePositions(), y = [size.y - _topPlateThickness - topBoltHolderSize(reversedBelts=reversedBelts).y/2])
        translate([x, y, z])
            children();
}

module backSideJoinerHolePositions(z=0) {
    size = [eY + 2*eSizeY, eZ];
    for (x = [size.x - eSizeY/2], y = backSideJoinerHolePositions())
        translate([x, y, z])
            children();
}

module frontSideJoinerHolePositions(z=0, bolts=false) {
    size = [eY + 2*eSizeY, eZ];
    for (x = [3 + eSizeY/2], y = frontSideJoinerHolePositions(bolts))
        translate([x, y, z])
            children();
}

module zRodHolePositions() {
    zRodOffsetX = (eX + 2*eSizeX - _zRodSeparation)/2;
    for (x = [0, _zRodSeparation])
        translate([x + zRodOffsetX, eY + 2*eSizeY - _zRodOffsetY, 0])
            children();
}

module zLeadScrewHolePosition() {
        translate([eX/2 + eSizeX, eY + 2*eSizeY - _zLeadScrewOffset, 0])
            children();
}

// left and right faces
module lowerChordHolePositions(z=_baseBoltHoleInset.x, includeFeet=true) {
    // this should match baseLeftHolePositions and baseRightHolePositions
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    for (y = includeFeet ? [_cornerHoleInset, size.y/2, size.y - _cornerHoleInset] : [size.y/2])
        translate([y, 0, z])
            children();
}

module faceConnectorHolePositions(z=_cornerHoleInset) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    for (y = [_baseBoltHoleInset.y, size.y -_baseBoltHoleInset.y] )
        translate([y, 0, z])
            children();
}

module faceSideHolePositions(z=0) {
    if (_useSideHoles) {
        size = [eY + 2*eSizeY, eZ];
        for (y = [size.y/3 + eSizeY/6, 2*size.y/3 - eSizeY/6])
            translate([eSizeY/2, y, z])
                children();
        for (x = [3*eSizeY/2,
                size.x/2,
                //size.x/3 + eSizeY/6,
                //2*size.x/3 - eSizeY/6
                ],
            y = [eSizeY/2, size.y - eSizeY/2])
            translate([x, y, z])
                children();
        // -10 displacement is to clear threaded insert
        translate([size.x - 3*eSizeY/2, eSizeY/2, z])
            children();
        // -20 displacement is to clear motor bolt access hole
        //translate([size.x - 20, size.y - eSizeY/2, z])
        // actually, intersecting with bolt access hole should not be a problem
        translate([size.x - 3*eSizeY/2, size.y - eSizeY/2, z])
            children();
        translate([size.x - eSizeY/2, size.y/2, z])
            children();
    }
}
