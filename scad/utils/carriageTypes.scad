include <NopSCADlib/vitamins/rails.scad>

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

function railType(carriageDescriptor) = carriage_rail(carriageType(carriageDescriptor));
