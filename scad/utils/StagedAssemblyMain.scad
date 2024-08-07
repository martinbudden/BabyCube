main_staged_assembly = true; // set this to false for faster builds during development


module main_staged_assembly(name, big, ngb) {
    if (main_staged_assembly)
        assembly(name, big, ngb)
            children();
    else
        children();
}
