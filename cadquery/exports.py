import cadquery as cq

def exports(object, name, type):
    object.export("exports/" + name + "_" + type + ".step")
    object.export("exports/" + name + "_" + type + ".stl")
    object.section().export("exports/" + name + "_" + type + ".dxf")
