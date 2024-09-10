import cadquery as cq

from constants import fittingTolerance, cncKerf, cncCuttingRadius, lsrKerf, lsrCuttingRadius, wjKerf, wjCuttingRadius
from constants import cSizeX, cSizeY, cSizeZ, plateThickness
from exports import exports
from BackFace import backFace
from FrontFace import frontFace
from LeftFace import leftFace
from RightFace import rightFace
from TopFace import topFace


def makeCNCs():
    print("Making CNCs")
    backFaceCNC = backFace(cq.Workplane("XY"), sizeX=cSizeX, sizeY=cSizeZ, sizeZ=plateThickness, cuttingRadius=cncCuttingRadius, dogboneTolerance=fittingTolerance, kerf=cncKerf)
    exports(backFaceCNC, "Back_Face_x220_z210", "CNC")

    frontFaceCNC = frontFace(cq.Workplane("XY"), sizeX=cSizeX, sizeY=cSizeZ, sizeZ=plateThickness, dogboneTolerance=fittingTolerance, cuttingRadius=cncCuttingRadius, kerf=cncKerf)
    exports(frontFaceCNC, "Front_Face_x220_z210", "CNC")

    leftFaceCNC = leftFace(cq.Workplane("XY"), sizeX=cSizeY, sizeY=cSizeZ, sizeZ=plateThickness, dogboneTolerance=fittingTolerance, cuttingRadius=cncCuttingRadius, kerf=cncKerf)
    exports(leftFaceCNC, "Left_Face_y220_z210", "CNC")

    rightFaceCNC = rightFace(cq.Workplane("XY"), sizeX=cSizeY, sizeY=cSizeZ, sizeZ=plateThickness, dogboneTolerance=fittingTolerance, cuttingRadius=cncCuttingRadius, kerf=cncKerf)
    exports(rightFaceCNC, "Right_Face_y220_z210", "CNC")

    topFaceCNC = topFace(cq.Workplane("XY"), sizeX=cSizeX, sizeY=cSizeY, sizeZ=plateThickness, dogboneTolerance=fittingTolerance, cuttingRadius=cncCuttingRadius, kerf=cncKerf)
    exports(topFaceCNC, "Top_Face_x220_y220", "CNC")


def makeLSRs():
    backFaceLSR = backFace(cq.Workplane("XY"), sizeX=cSizeX, sizeY=cSizeZ, sizeZ=plateThickness, cuttingRadius=lsrCuttingRadius, dogboneTolerance=fittingTolerance, kerf=lsrKerf)
    exports(backFaceLSR, "Back_Face_x220_z210", "LSR")

    frontFaceLSR = frontFace(cq.Workplane("XY"), sizeX=cSizeX, sizeY=cSizeZ, sizeZ=plateThickness, dogboneTolerance=fittingTolerance, cuttingRadius=lsrCuttingRadius, kerf=lsrKerf)
    exports(frontFaceLSR, "Front_Face_x220_z210", "LSR")

    leftFaceLSR = leftFace(cq.Workplane("XY"), sizeX=cSizeY, sizeY=cSizeZ, sizeZ=plateThickness, dogboneTolerance=fittingTolerance, cuttingRadius=lsrCuttingRadius, kerf=lsrKerf)
    exports(leftFaceLSR, "Left_Face_y220_z210", "LSR")

    rightFaceLSR = rightFace(cq.Workplane("XY"), sizeX=cSizeY, sizeY=cSizeZ, sizeZ=plateThickness, dogboneTolerance=fittingTolerance, cuttingRadius=lsrCuttingRadius, kerf=lsrKerf)
    exports(rightFaceLSR, "Right_Face_y220_z210", "LSR")

    topFaceLSR = topFace(cq.Workplane("XY"), sizeX=cSizeX, sizeY=cSizeY, sizeZ=plateThickness, dogboneTolerance=fittingTolerance, cuttingRadius=lsrCuttingRadius, kerf=lsrKerf)
    exports(topFaceLSR, "Top_Face_x220_y220", "LSR")


def makeWJs():
    backFaceWJ = backFace(cq.Workplane("XY"), sizeX=cSizeX, sizeY=cSizeZ, sizeZ=plateThickness, cuttingRadius=wjCuttingRadius, dogboneTolerance=fittingTolerance, kerf=wjKerf)
    exports(backFaceWJ, "Back_Face_x220_z210", "WJ")

    frontFaceWJ  = frontFace(cq.Workplane("XY"), sizeX=cSizeX, sizeY=cSizeZ, sizeZ=plateThickness, dogboneTolerance=fittingTolerance, cuttingRadius=wjCuttingRadius, kerf=wjKerf)
    exports(frontFaceWJ, "Front_Face_x220_z210", "WJ")

    leftFaceWJ  = leftFace(cq.Workplane("XY"), sizeX=cSizeY, sizeY=cSizeZ, sizeZ=plateThickness, dogboneTolerance=fittingTolerance, cuttingRadius=wjCuttingRadius, kerf=wjKerf)
    exports(leftFaceWJ, "Left_Face_y220_z210", "WJ")

    rightFaceWJ  = rightFace(cq.Workplane("XY"), sizeX=cSizeY, sizeY=cSizeZ, sizeZ=plateThickness, dogboneTolerance=fittingTolerance, cuttingRadius=wjCuttingRadius, kerf=wjKerf)
    exports(rightFaceWJ, "Right_Face_y220_z210", "WJ")

    topFaceWJ  = topFace(cq.Workplane("XY"), sizeX=cSizeX, sizeY=cSizeY, sizeZ=plateThickness, dogboneTolerance=fittingTolerance, cuttingRadius=wjCuttingRadius, kerf=wjKerf)
    exports(topFaceWJ, "Top_Face_x220_y220", "WJ")


def main() -> None:
    makeCNCs()
    #makeLSRs()
    #makeWJs()


# check if running in cq-editor
if 'show_object' in globals():
    main()

