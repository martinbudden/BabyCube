include <NopSCADlib/utils/core/core.scad>

include <../Parameters_CoreXY.scad>

function middleWebOffsetZ() = eZ - 105;

function printheadWiringPosX() = let(zRodOffsetX = (eX + 2*eSizeX - _zRodSeparation)/2) (eX + eSizeX - zRodOffsetX/2 - 4);
//function printheadWiringPosX() = eX + 2*eSizeX -47.5;
//function printheadWiringPos() = [printheadWiringPosX(), eY + 2*eSizeY - 2*printheadWireRadius() - 10, eZ-50];
function printheadWiringPos() = [printheadWiringPosX(), eY + 2*eSizeY - 38+15+4, eZ];
function printheadWireRadius() = 3;

function backFaceBracketLowerOffset() = [30, 15];
function backFaceBracketUpperOffset() = [30, 15];


//function topFaceMidSideHolePositions() = [ eSizeY + eY/3, eSizeY + 2*eY/3 ];
//function topFaceSideHolePositions() = [ 8, 20, 60, 140, 180 ];
//function topFaceSideHolePositions() = [ 20, 60, 100, 140, 180 ];
function topFaceSideHolePositions() = [ 20, 100, 180 ];

// offset of side bolt holes for top plate
topBoltHolderThickness = 7.25 + yRailShiftX();
function topBoltHolderSize(sidePlateThickness=_sidePlateThickness) = [eY + 2*eSizeY - 15 - _frontPlateCFThickness, 8, topBoltHolderThickness - sidePlateThickness]; // -15 to avoid back cube, +2.75 to give clearance for bolt hole
function topFaceSideHolePositionOffset() = 3.75 + yRailShiftX() + 0.5;
function baseBackHoleOffset() = [ floor(_zNEMA_width/2) + 4, 3];
//topBackHoleOffset = [ 20, 4];
function topFaceBackHolePositions() = [ eX/2 + eSizeX - 20, eX/2 + eSizeX + 20];
function topFaceBackHolePositionOffsetY() = 4;
function topFaceFrontHolePositionOffsetY() = 8;

function upperSideJoinerHolePositions() = [ 40, 80, 120, 175 ];
function lowerSideJoinerHolePositions(left) = left ? [ 90, 185 ] : [ 30, 90, 185 ];
function backSideJoinerHolePositions() =  [ 15, 55, 90 ];
function frontSideJoinerHolePositions() = [ 15, 40, 120 ];

function backFaceHolePositions() = [eSizeY/2 + 1, middleWebOffsetZ() + eSizeY/2, eZ - eSizeY/2 - _topPlateThickness];


module cutout_circle(r, cnc) {
    if (cnc)
        circle(r=r);
    else
        poly_circle(r=r);
}


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
             y=[0]) //y = [(size.y-eSizeY)/6, -(size.y-eSizeY)/6])
            translate([x, y, 0])
                rotate(-90)
                    children();
}

module baseFrontHolePositions(z=0) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    for (x = [size.x/3 + eSizeX/6, 2*size.x/3 - eSizeX/6],
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

module baseAllHolePositions(z=0) {
    baseAllCornerHolePositions(z)
        children();
    baseLeftHolePositions(z)
        children();
    baseRightHolePositions(z)
        children();
    baseBackHolePositions(z)
        children();
    baseFrontHolePositions(z)
        children();
}

// back face
module backFaceBaseHolePositions(y=0) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    for (x = [size.x/2 - baseBackHoleOffset().x, size.x/2 + baseBackHoleOffset().x ])
        translate([x, y, baseBackHoleOffset().y])
            children();
}

module backFaceHolePositions(left, z=0) {
    size = [eX + 2*eSizeX, eZ];
    xInset = _backFaceHoleInset;
    translate_z(z)
        for (y = backFaceHolePositions())
            translate(left ? [xInset, y, 0] : [size.x - xInset, y, 0])
                children();
}

module backFaceAllHolePositions(z=0, cf=false) {
    backFaceHolePositions(left=true, z=z)
        children();
    backFaceHolePositions(left=false, z=z)
        children();
    size = [eX + 2*eSizeX, eZ];
    if (cf)
        translate([size.x/2, size.y - _topPlateThickness - eSizeZ/2, z])
            children();
}

// front face
module frontFaceLowerHolePositions(z=0) {
    size = [eX + 2*eSizeX, eZ];
    for (x = [85, size.x - 85])
        translate([x, 10/2, z])
            children();
}

module frontFaceHolePositions(z=0) {
    size = [eX + 2*eSizeX, eZ];
    for (x = [30, size.x - 30])
        translate([x, size.y - 15.5, z])
            children();
    for (x = [85, size.x - 85])
        translate([x, size.y - _topPlateThickness - eSizeZ/2, z])
            children();
    for (x = [(_sidePlateThickness + eSizeXBase)/2, size.x - (_sidePlateThickness + eSizeXBase)/2],
         y = [20, 60, 100, 140])
        translate([x, y, z])
            children();
}

// top face
module topFaceFrontHolePositions(z=0) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    for (x = [size.x/3 + eSizeX/6, 2*size.x/3 - eSizeX/6])
        translate([x, topFaceFrontHolePositionOffsetY(), z])
            children();
}

module topFaceBackHolePositions(z=0) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    //for (x = [size.x/2 - topBackHoleOffset.x, size.x/2 + topBackHoleOffset.x ])
    for (x = topFaceBackHolePositions())
        translate([x, eY + 2*eSizeY - topFaceBackHolePositionOffsetY(), z])
            children();
}

module backFaceTopHolePositions(z=0) {
    size = [eX + 2*eSizeX, eZ];
    for (x = topFaceBackHolePositions())
        translate([x, eZ - _topPlateThickness, topFaceBackHolePositionOffsetY()])
            children();
}

module topFaceSideHolePositions(z=0) {
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    for (x = [topFaceSideHolePositionOffset(), size.x - topFaceSideHolePositionOffset()],
         //y = concat(topFaceMidSideHolePositions(), [eSizeY, eY + eSizeY]))
         y = topFaceSideHolePositions()
        )
        translate([x, y, z])
            children();
}

module sideFaceTopHolePositions(z=topFaceSideHolePositionOffset()) {
    size = [eX + 2*eSizeX, eZ];
    for (x = topFaceSideHolePositions())
        translate([x, size.y - _topPlateThickness, z])
            rotate([90, 0, 0])
                children();
}

module topFaceAllHolePositions(z=0) {
    topFaceFrontHolePositions(z)
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

module upperSideJoinerHolePositions(z=0) {
    size = [eY + 2*eSizeY, eZ];
    for (x = upperSideJoinerHolePositions(), y = [size.y - _topPlateThickness - topBoltHolderSize().y/2])
        translate([x, y, z])
            children();
}

module backSideJoinerHolePositions(z=0) {
    size = [eY + 2*eSizeY, eZ];
    for (x = [size.x - eSizeY/2], y = backSideJoinerHolePositions())
        translate([x, y, z])
            children();
}

module frontSideJoinerHolePositions(z=0) {
    size = [eY + 2*eSizeY, eZ];
    for (x = [3 + eSizeY/2], y = frontSideJoinerHolePositions())
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
module lowerChordHolePositions(z=_baseBoltHoleInset.x) {
    // this should match baseLeftHolePositions and baseRightHolePositions
    size = [eX + 2*eSizeX, eY + 2*eSizeY];
    for (y = [_cornerHoleInset, size.y/2, size.y - _cornerHoleInset])
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
