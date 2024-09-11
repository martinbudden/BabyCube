include <PrintheadAssemblies.scad>
include <PrintheadAssembliesDropEffectXG.scad>
include <PrintheadAssembliesE3DRevo.scad>
include <PrintheadAssembliesE3DV6.scad>


module printheadHotendSide(hotendDescriptor, rotate=0, explode=0, t=undef, accelerometer=false, boltLength=25, halfCarriage=false) {
    if (hotendDescriptor == "E3DV6")
        printheadHotendSideE3DV6(rotate, explode, t, accelerometer, boltLength, halfCarriage);
    else if (hotendDescriptor == "E3DRevo")
        printheadHotendSideE3DRevo(rotate, explode, t, accelerometer, boltLength);
    else if (hotendDescriptor == "E3DRevoCompact")
        printheadHotendSideE3DRevoCompact(rotate, explode, t, accelerometer, boltLength);
    else if (hotendDescriptor == "DropEffectXG")
        printheadHotendSideDropEffectXG(rotate, explode, t, accelerometer, boltLength);
}

