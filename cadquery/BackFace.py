import cadquery as cq
from dogbone import dogbone

#sizeX = 220
#sizeY = 210
sizeZ = 3
eSizeZ = 10

M3_clearance_radius = 3.3 / 2
M5_clearance_radius = 5.3 / 2
#cncTabTolerance = 0.05  # 0.05 each side gives 0.1 total tolerance


def backFace(
    sizeX: float,
    sizeY: float,
    sizeZ: float,
    cuttingRadius: float = 1.5,
    cncTabTolerance: float = 0,
    kerf: float = 0,
):
    kerf2 = kerf/2

    _zRodSeparation = 96
    sk_sizeZ = 14
    sk_screw_separation = 32
    zRodOffsetX = (sizeX - _zRodSeparation)/2;
    skBracketHoles = [(zRodOffsetX + x + s -sizeX/2, -sizeY/2 + y) for x in [0, _zRodSeparation] for s in [-sk_screw_separation/2, sk_screw_separation/2] for y in [sk_sizeZ/2 + 7, sizeY - sk_sizeZ/2 - 3]]

    topPlateThickness = 3
    topHoles = [(x, sizeY/2 - topPlateThickness - eSizeZ/2) for x in [-15, 15]]

    zMotorMountHoles = [(132.25 - sizeX/2, 39.5 - sizeY/2), (87.75 - sizeX/2, 39.5 - sizeY/2)]
    backFaceCFSideHoles = [(x, y - sizeY/2) for x in [8 - sizeX/2, sizeX/2 - 8] for y in [30, 110]]
    backFaceBracketHoles = [(30 - sizeX/2, 15 - sizeY/2), (sizeX/2 - 30, 15 - sizeY/2)]
    backFaceHoles = [(8 - sizeX/2, 6 - sizeY/2),(sizeX/2 - 8, 6 - sizeY/2)]

    xyMotorMountBackHoles = [(8 - sizeX/2, sizeY/2 - 8), (sizeX/2 - 8, sizeY/2 - 8), (37 - sizeX/2, sizeY/2 - 43.5), (sizeX/2 - 37, sizeY/2 - 43.5)]

    result = cq.Workplane("XY") \
        .rect(sizeX, sizeY) \
        .pushPoints(skBracketHoles) \
        .circle(M5_clearance_radius - kerf2) \
        .pushPoints(topHoles) \
        .circle(M3_clearance_radius - kerf2) \
        .pushPoints(zMotorMountHoles) \
        .circle(M3_clearance_radius - kerf2) \
        .pushPoints(backFaceCFSideHoles) \
        .circle(M3_clearance_radius - kerf2) \
        .pushPoints(xyMotorMountBackHoles) \
        .circle(M3_clearance_radius - kerf2) \
        .pushPoints(backFaceBracketHoles) \
        .circle(M3_clearance_radius - kerf2) \
        .pushPoints(backFaceHoles) \
        .circle(M3_clearance_radius - kerf2) \


    #range(start, end, step)
    leftDogbones = [(-sizeX/2, i - sizeY/2) for i in range(50, 210 + 1, 40)]
    rightDogbones = [(sizeX/2, i - sizeY/2) for i in range(50, 210 + 1, 40)]
    topDogbones = [(i - sizeX/2, sizeY/2) for i in range(30, 190 + 1, 40)]

    result = result.extrude(sizeZ) \
        .pushPoints(rightDogbones) \
        .dogbone(20, 6, cuttingRadius, 90, cncTabTolerance).cutThruAll() \
        .moveTo(-sizeX/2, -sizeY/2) \
        .dogbone(40, 6, cuttingRadius, 90, cncTabTolerance).cutThruAll() \
        .pushPoints(leftDogbones) \
        .dogbone(20, 6, cuttingRadius, 90, cncTabTolerance).cutThruAll() \
        .moveTo(sizeX/2, -sizeY/2) \
        .dogbone(40, 6, cuttingRadius, 90, cncTabTolerance).cutThruAll() \
        .pushPoints(topDogbones) \
        .dogbone(20, 6, cuttingRadius, 0, cncTabTolerance).cutThruAll()

    return result

dxf = (
    cq.importers.importDXF("../BC220CF/dxfs/Back_Face_x220_z210.dxf") \
    .wires() \
    .toPending() \
    .extrude(sizeZ)
)

cncCuttingRadius = 1.5
cncTabTolerance = 0.05 # 0.05 each side gives 0.1 total tolerance
lsrKerf = 0.3
lsrCuttingRadius = 0.3

backFaceCNC = backFace(sizeX=220, sizeY=210, sizeZ=3, cuttingRadius=cncCuttingRadius, cncTabTolerance=0.05, kerf=0) 
backFaceLSR = backFace(sizeX=220, sizeY=210, sizeZ=3, cuttingRadius=lsrCuttingRadius, cncTabTolerance=0.05, kerf=lsrKerf) 

show_object(backFaceCNC)
#show_object(backFaceLSR)
show_object(dxf)

cq.exporters.export(backFaceCNC, "Back_Face_x220_z210.stl")
#cq.exporters.export(backFaceCNC.section(), "Back_Face_x220_z210.dxf")
#cq.exporters.export(backFaceCNC, "Back_Face_x220_z210.step")

cq.exporters.export(backFaceLSR, "Back_Face_x220_z210_LSR.stl")
#cq.exporters.export(backFaceLSR.section(), "Back_Face_x220_z210_LSR.dxf")
#cq.exporters.export(backFaceLSR, "Back_Face_x220_z210_LSR.step")