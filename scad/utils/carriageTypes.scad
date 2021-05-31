include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rails.scad>

include <../Parameters_Main.scad>

function isCarriageType(carriageType) = is_list(carriageType) && carriageType[0][0] == "M";

function carriageType(carriageDescriptor) =
    carriageDescriptor == "MGN5C" ? MGN5C_carriage :
    carriageDescriptor == "MGN7C" ? MGN7C_carriage :
    carriageDescriptor == "MGN7H" ? MGN7H_carriage :
    carriageDescriptor == "MGN9C" ? MGN9C_carriage :
    carriageDescriptor == "MGN9H" ? MGN9H_carriage :
    carriageDescriptor == "MGN12C" ? MGN12C_carriage :
    carriageDescriptor == "MGN12H" ? MGN12H_carriage :
    carriageDescriptor == "MGN15C" ? MGN15C_carriage :
    undef;

function xCarriageType(xCarriageDescriptor = _xCarriageDescriptor) = carriageType(xCarriageDescriptor);
function yCarriageType(yCarriageDescriptor = _yCarriageDescriptor) = carriageType(yCarriageDescriptor);

function xRailType(xCarriageDescriptor = _xCarriageDescriptor) = carriage_rail(xCarriageType(xCarriageDescriptor));
function yRailType(yCarriageDescriptor = _yCarriageDescriptor) = carriage_rail(yCarriageType(yCarriageDescriptor));
