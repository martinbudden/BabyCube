//!# Carbon Fiber BabyCube Assembly Instructions
//!
//!**Note that the Carbon Fiber BabyCube is very much a work in progress.**
//!
//!These are the assembly instructions for the Carbon Fiber BabyCube. These instructions are not fully comprehensive, that
//!is they do not show every small detail of the construction, and in particular they do not show the wiring. However there
//!is sufficient detail that someone with a good understanding of 3D printers can build the BabyCube.
//!
//!![BC200CF Assembly](assemblies/BC200CF_assembled.png)
//
include <NopSCADlib/utils/core/core.scad>

use <assemblies/MainAssemblyCF.scad>

//! Add the printhead, spool holder and spool.
//
module BC200CF_assembly(test=false) pose(a=[55, 0, 25])
assembly("BC200CF", big=true) {
    CF_FinalAssembly(test);
    //CF_DebugAssembly();
}

//!1. Attach the Bowden tube to the extruder and the hotend.
//!2. Attach the **Spool_Holder**.
//!
module BC220CF_assembly(test=false) pose(a=[55, 0, 25])
assembly("BC220CF", big=true) {
    CF_FinalAssembly(test);
    //CF_DebugAssembly();
}

module BC250CF_assembly(test=false) pose(a=[55, 0, 25])
assembly("BC250CF", big=true) {
    CF_FinalAssembly(test);
    //CF_DebugAssembly();
}

module BC260CF_assembly(test=false) pose(a=[55, 0, 25])
assembly("BC260CF", big=true) {
    CF_FinalAssembly(test);
    //CF_DebugAssembly();
}

if ($preview)
    BC220CF_assembly();
