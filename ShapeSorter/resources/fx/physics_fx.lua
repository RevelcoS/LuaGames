local typedShapes = require "resources.objects.dynamic.shapes.typed_shapes"
local SizeConfig = require "resources.config.size_config"

local M = {}

function M.explode( shapesList )
    local maxImpulse = 10

    -- slice shapes and create a new list of shapes
    local newShapesList = {}

    local newShapeSize = SizeConfig.shapeSize / 2
    local options = {shapeSize = newShapeSize}
    typedShapes.init( options )

    local spawnFunctions = {
        ["rectangle"] = typedShapes.createRectangle,
        ["triangle"] = typedShapes.createTriangle,
        ["circle"] = typedShapes.createCircle
    }

    for i = 1, #shapesList do
        local shape = shapesList[i]
        local name = shape.shapeName
        local spawnFunction = spawnFunctions[name]
        local x, y = shape.x, shape.y
        shape:removeSelf()

        for _ = 1, 4 do
            local newShape = spawnFunction(x, y)
            newShapesList[#newShapesList + 1] = newShape
        end
    end

    -- make a slow-motion explosion
    for i = 1, #newShapesList do
        local shape = newShapesList[i]
        shape.gravityScale = 0.05

        local linearImpulseOptions = {
            math.random() * maxImpulse,
            math.random() * maxImpulse,
            shape.x,
            shape.y
        }
        shape:applyLinearImpulse( unpack(linearImpulseOptions) )
    end
end

return M