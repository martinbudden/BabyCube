import cadquery as cq
from dogbone import dogbone

#sizeX = 220
#sizeY = 210
sizeZ = 3
eSizeZ = 10
backPlateThickness = 3

M3_clearance_radius = 3.3 / 2
M5_clearance_radius = 5.3 / 2
#cncTabTolerance = 0.05  # 0.05 each side gives 0.1 total tolerance


def leftFace(
    sizeX: float,
    sizeY: float,
    sizeZ: float,
    cuttingRadius: float = 1.5,
    cncTabTolerance: float = 0,
    kerf: float = 0,
    grill: bool = True
):
    kerf2 = kerf/2
    sizeXB = sizeX - backPlateThickness

    baseHoles = [(x, 5 - sizeY/2) for x in [10 - sizeX/2, 76.5 - sizeX/2, sizeX/2 -79.5, sizeX/2 - 13]]
    topHoles = [(x, sizeY/2- 7) for x in [50 - sizeX/2, 90 - sizeX/2, 130 - sizeX/2]]
    frontHoles = [(8 - sizeX/2, 50 - sizeY/2)]
    idlerHoles = [(8 - sizeX/2, sizeY/2 - 44), (10 - sizeX/2, sizeY/2 - 15.5)]
    backHoles = [(sizeX/2 - 8, 50 - sizeY/2), (sizeX/2 - 8, 90 - sizeY/2)]
    motorHoles = [(sizeX/2 - 15, sizeY/2 - 18), (sizeX/2 - 38, sizeY/2 - 43.5)]

    grillHoles = [(55.3 + x*8.5 - sizeX/2, y - sizeY/2) for x in range(0, 4) for y in range(15, 40, 5)]
    grillHoles2 = [(55.3 + 8.5/2 + x*8.5 - sizeX/2, y+2.5 - sizeY/2) for x in range(0, 3) for y in range(15, 35, 5)]

    result = cq.Workplane("XY") \
        .rect(sizeX, sizeY) \
        .pushPoints(baseHoles) \
        .circle(M3_clearance_radius - kerf2) \
        .pushPoints(topHoles) \
        .circle(M3_clearance_radius - kerf2) \
        .pushPoints(frontHoles) \
        .circle(M3_clearance_radius - kerf2) \
        .pushPoints(backHoles) \
        .circle(M3_clearance_radius - kerf2) \
        .pushPoints(idlerHoles) \
        .circle(M3_clearance_radius - kerf2) \
        .pushPoints(motorHoles) \
        .circle(M3_clearance_radius - kerf2) \

    if grill:
        result = result \
            .pushPoints(grillHoles) \
            .circle(1.75 - kerf2) \
            .pushPoints(grillHoles2) \
            .circle(1.75 - kerf2) \


    #range(start, end, step)
    leftDogbones = [(-sizeX/2, i - sizeY/2) for i in range(30, 210 + 1, 40)]
    rightDogbones = [(sizeX/2, i - sizeY/2) for i in range(30, 210 + 1, 40)]
    topDogbones = [(i - sizeX/2, sizeY/2) for i in range(30, 190 + 1, 40)]

    result = result.extrude(sizeZ) \
        .pushPoints(rightDogbones) \
        .dogbone(20, 6, cuttingRadius, 90, cncTabTolerance).cutThruAll() \
        .pushPoints(leftDogbones) \
        .dogbone(20, 6, cuttingRadius, 90, cncTabTolerance).cutThruAll() \
        .pushPoints(topDogbones) \
        .dogbone(20, 6, cuttingRadius, 0, cncTabTolerance).cutThruAll()

    return result


dxf = (
    cq.importers.importDXF("../BC220CF/dxfs/Left_Face_y220_z210.dxf") \
    .wires() \
    .toPending() \
    .extrude(sizeZ)
)


cncCuttingRadius = 1.5
cncTabTolerance = 0.05 # 0.05 each side gives 0.1 total tolerance
lsrKerf = 0.3
lsrCuttingRadius = 0.3

leftFaceCNC = leftFace(sizeX=220+backPlateThickness, sizeY=210, sizeZ=3, cuttingRadius=cncCuttingRadius, cncTabTolerance=0.05, kerf=0)
#leftFaceLSR = leftFace(sizeX=223, sizeY=210, sizeZ=3, cuttingRadius=lsrCuttingRadius, cncTabTolerance=0.05, kerf=lsrKerf) 

#show_object(leftFaceCNC)
#show_object(leftFaceLSR)
#show_object(dxf)

#cq.exporters.export(leftFaceCNC, "Left_Face_x220_z210.stl")
#cq.exporters.export(leftFaceCNC.section(), "Left_Face_x220_z210.dxf")
#cq.exporters.export(leftFaceCNC, "Left_Face_x220_z210.step")

#cq.exporters.export(leftFaceLSR, "Left_Face_x220_z210_LSR.stl")
#cq.exporters.export(leftFaceLSR.section(), "Left_Face_x220_z210_LSR.dxf")
#cq.exporters.export(leftFaceLSR, "Left_Face_x220_z210_LSR.step")