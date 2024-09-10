import cadquery as cq

def exportCalibrations(object, name, type):
    object.export("calibration/" + name + "_" + type + ".step")
    object.export("calibration/" + name + "_" + type + ".stl")
    object.section().export("calibration/" + name + "_" + type + ".dxf")
