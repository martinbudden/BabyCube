use <NopSCADlib/utils/sweep.scad>
use <NopSCADlib/utils/maths.scad>
use <NopSCADlib/utils/bezier.scad>


module bezierTube(startPos, endPos, tubeRadius=2, vitamin=false, extraZ=50) {
    assert(is_list(startPos));
    assert(is_list(endPos));
    assert(is_num(extraZ));

    pathEndPos = endPos - startPos;
    // assumes startPos.z < endPos.z
    heightDelta = endPos.z - startPos.z;
    arcRadius = 1.25*sqrt((startPos.x-endPos.x)*(startPos.x-endPos.x) + (startPos.y-endPos.y)*(startPos.y-endPos.y))/2;
    p = [ [0, 0, 0], [0, 0, heightDelta], [0, 0, heightDelta + extraZ], [pathEndPos.x/2, pathEndPos.y/2, pathEndPos.z + arcRadius], pathEndPos+[0, 0, extraZ], pathEndPos + [0, 0, extraZ/2], pathEndPos ];
    path = bezier_path(p, 50);

    length = ceil(bezier_length(p));
    if (vitamin)
        vitamin(str("bezierTube(): PTFE tube ", length, " mm"));

    translate(startPos)
        sweep(path, circle_points(tubeRadius, $fn = 64));
}

module bezierTube2(path, tubeRadius=2) {

    bPath = bezier_path(path, 150);
    sweep(bPath, circle_points(tubeRadius, $fn = 64));
}
