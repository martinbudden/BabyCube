include <../global_defs.scad>

include <../utils/carriageTypes.scad>
include <../utils/X_Rail.scad>

use <NopSCADlib/vitamins/pcb.scad>
include <../vitamins/pcbs.scad>

use <X_Carriage.scad>
use <X_CarriageAssemblies.scad>

include <../Parameters_CoreXY.scad>
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

