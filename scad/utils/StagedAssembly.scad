staged_assembly = !true; // set this to false for faster builds during development
main_staged_assembly = true; // set this to false for faster builds during development


module staged_assembly(name, big, ngb) {
    if (staged_assembly)
        assembly(name, big, ngb)
            children();
    else
        children();
}

module main_staged_assembly(name, big, ngb) {
    if (main_staged_assembly)
        assembly(name, big, ngb)
            children();
    else
        children();
}

module staged_explode(z=0, show_line=true) {
    if (staged_assembly)
        children();
    else
        translate_z(exploded() ? z : 0)
            explode(eps, false, show_line=show_line)
                children();
}
