include <../global_defs.scad>

include <NopSCADlib/core.scad>

include <../Parameters_Main.scad>
include <../Parameters_Positions.scad>

/*
Note, layer height ranges:
0.4 : [  0.11,   0.34  ], at ew : [ 0.44, 0.68 ]
0.5 : [  0.1375, 0.425 ], at ew : [ 0.55, 0.85 ]
0.6 : [  0.165,  0.51  ], at ew : [ 0.66, 1.02 ]
0.8 : [  0.22,   0.68  ], at ew : [ 0.88, 1.36 ]
*/
module echoPrintParameters() {
    //assert(extrusion_width >= 1.1*nozzle, "extrusion_width too small for nozzle");
    //assert(extrusion_width <= 1.7*nozzle, "extrusion_width too large for nozzle");
    //assert(layer_height <= 0.5*extrusion_width, "layer_height too large for extrusion_width");
    //assert(layer_height >= 0.25*extrusion_width, "layer_height too small for extrusion_width"); // not sure this one is correct

    echo(nozzle = nozzle);
    echo(extrusion_width = extrusion_width, r= [ 1.1*nozzle, 1.7*nozzle ]);
    echo(layer_height = layer_height, r = [ 0.25*extrusion_width, 0.5*extrusion_width ]);
    echo(layer_height_full_range = [ 0.25*1.1*nozzle, 0.5*1.7*nozzle ], ew = [1.1*nozzle, 1.7*nozzle ]);
    echo($fs=$fs);
    echo($fa=$fa);
}

module echoPrintSize() {
    echo(Variant = _variant);
    echo(Print_size = [_xMax-_xMin, _yMax-_yMin, _zMax-_zMin]);
    echo(Sizes = [eX + 2*eSizeX, eY + 2*eSizeY, eZ]);
    echo(Motors = _xyNemaType, _zNemaType);
    echo(Rails = _xRailLength, _yRailLength);
    echo(Carriages = _xCarriageType, _yCarriageType);
    echo(Rods  = _zRodDiameter, _zRodLength);
    echo(Leadscrew  = _zLeadScrewLength);
    echo(_zRodOffsetY = _zRodOffsetY);
}
