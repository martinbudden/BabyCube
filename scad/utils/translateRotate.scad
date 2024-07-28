module translate_r(v) {
    assert(is_list(v));
    if (is_list(v[0]))
        translate(v[0])
            rotate(v[1])
                children();
    else
        translate([v.x, v.y, v.z])
            rotate(v[3])
                children();
}

