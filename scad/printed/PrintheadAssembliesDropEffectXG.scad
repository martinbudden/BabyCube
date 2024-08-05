include <PrintheadAssemblies.scad>

include <X_CarriageDropEffectXG.scad>

//!1.
//
module Printhead_DropEffect_XG_MGN9C_assembly() pose(a=[55, 0, 25 + 180])
assembly("Printhead_DropEffect_XG_MGN9C", big=true) {

    stl_colour(pp1_colour)
        rotate([0, 90, 0])
            X_Carriage_DropEffect_XG_MGN9C_stl();
    X_Carriage_DropEffect_XG_MGN9C_hardware();
}

module printheadHotendSideDropEffectXG(rotate=0, explode=0, t=undef, accelerometer=false, boltLength=25) {
    screwType = hs_cap;
    boreDepth = xCarriageBoreDepth();

    printheadHotendSide(rotate=rotate, explode=explode, t=t, accelerometer=accelerometer, screwType=screwType, boltLength=boltLength, boreDepth=boreDepth)
        Printhead_DropEffect_XG_MGN9C_assembly();
}

