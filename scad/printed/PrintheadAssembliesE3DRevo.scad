include <PrintheadAssemblies.scad>
use <PrintheadExtras.scad>

include <X_CarriageE3DRevo.scad>

//!1. Bolt the **E3D Revo Voron heatsink** to the **X_Carriage_E3DRevo**.
//!2. Screw the **Bowden connector** into the **X_Carriage_E3DRevo**. Use an M6 bolt to pre-tap the X_Carriage.
//!3. Bolt the **E3DRevo_Fan_Duct** and the square radial fan to the **X_Carriage_E3DRevo**.
//!4. Bolt the axial fan to the **X_Carriage_E3DRevo**.
//!5. Attach the **E3D Revo HeaterCore** to the **E3D Revo Voron heatsink** and screw in the **E3D Revo nozzle**
//!6. Gather the cables from the printhead and wrap them in spiral cable wrap.
//!7. Use zipties to secure the wrapped cables to the printhead
//
module Printhead_E3DRevo_assembly() pose(a=[55, 0, 25 + 180])
assembly("Printhead_E3DRevo", big=true) {

    stl_colour(pp4_colour)
        rotate([0, 90, 0])
            X_Carriage_E3DRevo_stl();
    X_Carriage_E3DRevo_hardware();
    if (!exploded())
        printheadWiring("E3DRevo");
}

module Printhead_E3DRevo_Compact_assembly() pose(a=[55, 0, 25 + 180])
assembly("Printhead_E3DRevo", big=true) {

    stl_colour(pp4_colour)
        rotate([0, 90, 0])
            X_Carriage_E3DRevo_Compact_stl();
    X_Carriage_E3DRevo_Compact_hardware();
    if (!exploded())
        printheadWiring("E3DRevoCompact");
}

module Printhead_E3DRevo_40_assembly() pose(a=[55, 0, 25 + 180])
assembly("Printhead_E3DRevo_40", big=true) {

    stl_colour(pp4_colour)
        rotate([0, 90, 0])
            X_Carriage_E3DRevo_40_stl();
    X_Carriage_E3DRevo_40_hardware();
}

module printheadHotendSideE3DRevo(rotate=0, explode=0, t=undef, accelerometer=false, boltLength=25) {
    screwType = hs_cap;
    boreDepth = xCarriageBoreDepth();

    printheadHotendSide(rotate=rotate, explode=explode, t=t, accelerometer=accelerometer, screwType=screwType, boltLength=boltLength, boreDepth=boreDepth)
        Printhead_E3DRevo_assembly();
}

module printheadHotendSideE3DRevoCompact(rotate=0, explode=0, t=undef, accelerometer=false, boltLength=25) {
    screwType = hs_cap;
    boreDepth = xCarriageBoreDepth();

    printheadHotendSide(rotate=rotate, explode=explode, t=t, accelerometer=accelerometer, screwType=screwType, boltLength=boltLength, boreDepth=boreDepth)
        Printhead_E3DRevo_Compact_assembly();
}

