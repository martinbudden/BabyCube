include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rails.scad>

include <../Parameters_Main.scad>

function xCarriageType() =
    _xCarriageType == "7C" ? MGN7C_carriage :
    _xCarriageType == "9C" ? MGN9C_carriage :
    _xCarriageType == "9H" ? MGN9H_carriage :
    _xCarriageType == "12C" ? MGN12C_carriage :
    _xCarriageType == "12H" ? MGN12H_carriage :
    undef;

function yCarriageType() =
    _yCarriageType == "7C" ? MGN7C_carriage :
    _yCarriageType == "9C" ? MGN9C_carriage :
    _yCarriageType == "9H" ? MGN9H_carriage :
    _yCarriageType == "12C" ? MGN12C_carriage :
    _yCarriageType == "12H" ? MGN12H_carriage :
    undef;

function xRailType() = carriage_rail(xCarriageType());
function yRailType() = carriage_rail(yCarriageType());
