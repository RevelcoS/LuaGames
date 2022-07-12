local Shape = require "resources.objects.dynamic.shapes.shape"

local configDir = "resources.config."
local ColorConfig = require (configDir .. "shape_color_config")
local SizeConfig = require (configDir .. "size_config")

local M = {}
local shapeSize = SizeConfig.shapeSize

function M.init( options )
    local options = options or {}

    shapeSize = options.shapeSize or 30
end

function M.createTriangle(x, y)
    if not x or not y then error("no coords for triangle") end

    halfShapeSize = shapeSize / 2
    local shape = {
        0, -halfShapeSize,
        1.09 * halfShapeSize, 0.5 * shapeSize,
        - 1.09 * halfShapeSize, 0.5 * shapeSize
    }

    local triangle = Shape.new( display.newPolygon(x, y, shape), {shape = shape} )
    triangle.fill = fillColor

    local name = "triangle"
    triangle.shapeName = name

    local fillColor = ColorConfig[name]
    triangle.fill = fillColor

    return triangle
end

function M.createRectangle(x, y)
    if not x or not y then error("no coords for rectangle") end

    local params = {
        x,
        y,
        shapeSize,
        shapeSize
    }
    local rect = Shape.new( display.newRect(unpack(params)) )

    local name = "rectangle"
    rect.shapeName = name

    local fillColor = ColorConfig[name]
    rect.fill = fillColor

    return rect
end

function M.createCircle(x, y)
    if not x or not y then error("no coords for circle") end

    local radius = shapeSize / 2
    local params = {
        x,
        y,
        radius,
    }
    local circle = Shape.new( display.newCircle(unpack(params)), {radius = radius} )

    local name = "circle"
    circle.shapeName = name

    local fillColor = ColorConfig[name]
    circle.fill = fillColor

    return circle
end

return M