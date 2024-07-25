include <PrintheadAssemblies.scad>

include <X_CarriageE3DRevo.scad>

//!1. Assemble the E3D hotend, including fan, thermistor cartridge and heater cartridge.
//!2. Use the **E3DV6_Clamp** to attach the hotend to the **X_Carriage_Groovemount**.
//!3. Collect the wires together and attach to the **X_Carriage_Groovemount** using the **Hotend_Strain_Relief_Clamp**.
//
module Printhead_E3DRevo_MGN9C_assembly() pose(a=[55, 0, 25 + 180])
assembly("Printhead_E3DRevo_MGN9C", big=true) {

    stl_colour(pp1_colour)
        X_Carriage_E3DRevo_MGN9C_stl();
    X_Carriage_E3DRevo_MGN9C_hardware();
}

module printheadHotendSideE3DRevo(rotate=0, explode=0, t=undef, accelerometer=false) {
    screwType = hs_cap;
    boreDepth = xCarriageBoreDepth();

    printheadHotendSide(rotate=rotate, explode=explode, t=t, accelerometer=accelerometer, screwType=screwType, boltLength=25, boreDepth=boreDepth)
        Printhead_E3DRevo_MGN9C_assembly();
}

