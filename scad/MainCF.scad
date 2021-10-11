//!# Carbon Fiber BabyCube Assembly Instructions
//!
//!These are the assembly instructions for the carbon fiber BabyCube.
//!
//!![BC200CF Assembly](assemblies/BC200CF_assembled.png)
//
include <NopSCADlib/utils/core/core.scad>

use <MainAssemblyCF.scad>

//! Add the printhead
//! Thread the belts
//
module BC200CF_assembly() pose(a=[55, 0, 25])
assembly("BC200CF", big=true) {
    CF_FinalAssembly();
    //CF_DebugAssembly();
}

if ($preview)
    BC200CF_assembly();
