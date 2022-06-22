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

use <MainAssemblyCF.scad>

//! Add the printhead, spool holder and spool.
//
module BC200CF_assembly() pose(a=[55, 0, 25])
assembly("BC200CF", big=true) {
    CF_FinalAssembly();
    //CF_DebugAssembly();
}

module BC200CF_unstaged_assembly()
assembly("BC200CF_unstaged", big=true) {
    CF_DebugAssembly();
}

if ($preview)
    BC200CF_assembly();
