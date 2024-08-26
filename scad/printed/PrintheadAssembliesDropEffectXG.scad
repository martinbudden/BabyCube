include <PrintheadAssemblies.scad>
use <PrintheadExtras.scad>

include <X_CarriageDropEffectXG.scad>

//!1. Assemble the DropEffect XG hotend, including fan and Bowden adaptor.
//!2. Attach the DropEffect XG hotend to the **X_Carriage**
//!3. Gather the cables from the printhead and wrap them in spiral cable wrap.
//!4. Use zipties to secure the wrapped cables to the printhead
//
module Printhead_DropEffect_XG_assembly() pose(a=[55, 0, 25 + 180])
assembly("Printhead_DropEffect_XG", big=true) {

    stl_colour(pp4_colour)
        rotate([-90, 0, 0])
            X_Carriage_DropEffect_XG_stl();
    X_Carriage_DropEffect_XG_hardware();
    if (!exploded())
        printheadWiring("DropEffectXG");
}

module printheadHotendSideDropEffectXG(rotate=0, explode=0, t=undef, accelerometer=false, boltLength=25) {
    screwType = hs_cap;
    boreDepth = xCarriageBoreDepth();

    printheadHotendSide(rotate=rotate, explode=explode, t=t, accelerometer=accelerometer, screwType=screwType, boltLength=boltLength, boreDepth=boreDepth)
        Printhead_DropEffect_XG_assembly();
}

