//!# Carbon Fiber BabyCube Assembly Instructions
//!
//!These are the assembly instructions for the carbon fiber BabyCube.
//!
//!![BC200CF Assembly](assemblies/BC200CF_assembled.png)
//
include <NopSCADlib/core.scad>

use <MainAssemblyCF.scad>

//! Add the printhead
//! Thread the belts
//
module BC200CF_assembly() pose(a = [55, 0, 25])
assembly("BC200CF", big=true) {
    //CF_FinalAssembly();
    CF_DebugAssembly();
    if (!exploded())
        CoreXYBelts(carriagePosition());
}

if ($preview)
    translate([-(eX + 2*eSizeX)/2, - (eY + 2*eSizeY)/2, -eZ/2])
        BC200CF_assembly();
