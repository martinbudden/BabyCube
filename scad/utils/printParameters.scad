include <NopSCADlib/utils/core/core.scad>

include <../Parameters_Positions.scad>

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
    echo(Print_size = [_xMax-_xMin, _yMax-_yMin, _zMax-_zMin]);
}

module echoVariant() {
    echo(Variant = _variant);
    echo(Print_size = [_xMax-_xMin, _yMax-_yMin, _zMax-_zMin]);
    echo(Sizes = [eX + 2*eSizeX, eY + 2*eSizeY, eZ]);
    echo(Motors = _xyMotorDescriptor, _zMotorDescriptor);
    echo(Rails = _xRailLength, _yRailLength);
    echo(Carriages = _xCarriageDescriptor, _yCarriageDescriptor);
    echo(Rods  = _zRodDiameter, _zRodLength);
    echo(Leadscrew  = _zLeadScrewLength);
    echo(_zRodOffsetY = _zRodOffsetY);
}
