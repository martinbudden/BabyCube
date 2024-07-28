include <../global_defs.scad>

include <../utils/carriageTypes.scad>
include <../utils/X_Rail.scad>

use <NopSCADlib/vitamins/pcb.scad>
include <../vitamins/pcbs.scad>

use <X_Carriage.scad>
use <X_CarriageAssemblies.scad>

include <../Parameters_Main.scad>
use <../Parameters_Positions.scad>


module printheadBeltSide(rotate=0, explode=0, t=undef, halfCarriage=true) {
    xCarriageType = MGN9C_carriage;

    xRailCarriagePosition(carriagePosition(t), rotate)
        explode(explode, true) {
            explode([0, -20, 0], true)
                if (halfCarriage)
                    X_Carriage_Belt_Side_MGN9C_HC_assembly();
                else
                    X_Carriage_Belt_Side_MGN9C_assembly();
            xCarriageTopBolts(xCarriageType, countersunk=_xCarriageCountersunk, positions = halfCarriage ? [ [1, -1], [-1, -1] ] : undef);
            xCarriageBeltClampAssembly(xCarriageType);
        }
}

module printheadHotendSide(rotate=0, explode=0, t=undef, accelerometer=false, screwType=hs_cs_cap, boltLength=25, boreDepth=0) {
    xCarriageType = carriageType(_xCarriageDescriptor);
    xCarriageBeltSideSize = xCarriageBeltSideSize(xCarriageType, beltWidth()) + [xCarriageBeltAttachmentMGN9CExtraX(), 0, 0];
    holeSeparationTop = xCarriageHoleSeparationTop(xCarriageType);
    holeSeparationBottom = xCarriageHoleSeparationBottom(xCarriageType);

    xRailCarriagePosition(carriagePosition(t), rotate=rotate) {
        explode(explode, true)
            children();
        if (boltLength > 0)
            explode([0, -20, 0], true)
                xCarriageBeltSideBolts(xCarriageType, xCarriageBeltSideSize, topBoltLength=boltLength, holeSeparationTop=holeSeparationTop, bottomBoltLength=boltLength, holeSeparationBottom=holeSeparationBottom, screwType=screwType, boreDepth=boreDepth);
    }
}

module printheadAccelerometerAssembly() {
    translate(accelerometerOffset() + [0, 0, 1])
        rotate(180) {
            pcb = ADXL345;
            pcb(pcb);
            pcb_hole_positions(pcb) {
                translate_z(pcb_size(pcb).z)
                    boltM3Caphead(10);
                explode(-5)
                    vflip()
                        washer(M3_washer)
                            washer(M3_washer);
            }
        }
}

