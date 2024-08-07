include <PrintheadAssemblies.scad>
use <PrintheadExtras.scad>

include <X_CarriageE3DRevo.scad>

//!1. Bolt the **E3D Revo Voron heatsink** to the **X_Carriage_E3DRevo_MGN9C**.
//!2. Screw the **Bowden connector** into the **X_Carriage_E3DRevo_MGN9C**. Use an M6 bolt to pre-tap the X_Carriage.
//!3. Bolt the **E3DRevo_Fan_Duct** and the square radial fan to the **X_Carriage_E3DRevo_MGN9C**.
//!4. Bolt the axial fan to the **X_Carriage_E3DRevo_MGN9C**.
//!5. Attach the **E3D Revo HeaterCore** to the **E3D Revo Voron heatsink** and screw in the **E3D Revo nozzle**
//
module Printhead_E3DRevo_MGN9C_assembly() pose(a=[55, 0, 25 + 180])
assembly("Printhead_E3DRevo_MGN9C", big=true) {

    stl_colour(pp4_colour)
        rotate([0, 90, 0])
            X_Carriage_E3DRevo_MGN9C_stl();
    X_Carriage_E3DRevo_MGN9C_hardware();
    if (!exploded())
        printheadWiring(undef, "E3DRevo",  undef, segment=true);
}

module Printhead_E3DRevo_40_MGN9C_assembly() pose(a=[55, 0, 25 + 180])
assembly("Printhead_E3DRevo_40_MGN9C", big=true) {

    stl_colour(pp4_colour)
        rotate([0, 90, 0])
            X_Carriage_E3DRevo_40_MGN9C_stl();
    X_Carriage_E3DRevo_40_MGN9C_hardware();
}

module printheadHotendSideE3DRevo(rotate=0, explode=0, t=undef, accelerometer=false, boltLength=25) {
    screwType = hs_cap;
    boreDepth = xCarriageBoreDepth();

    printheadHotendSide(rotate=rotate, explode=explode, t=t, accelerometer=accelerometer, screwType=screwType, boltLength=boltLength, boreDepth=boreDepth)
        Printhead_E3DRevo_MGN9C_assembly();
}

