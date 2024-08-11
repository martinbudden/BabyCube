//!# BabyCube Assembly Instructions
//!
//!
//!These are the assembly instructions for the BabyCube. These instructions are not fully comprehensive, that
//!is they do not show every small detail of the construction, and in particular they do not show the wiring. However there
//!is sufficient detail that someone with a good understanding of 3D printers can build the BabyCube.
//!
//!![BC22o Assembly](assemblies/BC220_assembled.png)
//
include <NopSCADlib/utils/core/core.scad>

use <assemblies/MainAssemblyRB.scad>

//!1. Bolt the BabyCube nameplate and the **Front_Lower_Chord** to the front of the frame.
//!2. Connect the Bowden tube.
//!3. Add the spool holder and spool.
//
module BC220_assembly(test=false) pose(a=[55, 0, 25])
assembly("BC220", big=true) {
    RB_FinalAssembly(test);
}

if ($preview)
    BC220_assembly();
