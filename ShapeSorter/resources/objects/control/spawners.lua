local typedShapes = require "resources.objects.dynamic.shapes.typed_shapes"

local Spawners = {}

function Spawners.new(n, yLevel)
    -- n - number of boxes
    if not n or not yLevel then error("bad arguments") end

    local spawnersGroup = {}
    local dx = display.contentWidth / (2 * n)
    for i = 1, n do
        local x = 2 * dx * (i - 1) + dx
        local y = yLevel
        spawnersGroup[i] = {x = x, y = y}
    end

    spawnersGroup.boxes = n

    function spawnersGroup:spawn(n)
        -- n - number of shapes to be spawned
        if not n then error("no number of shapes were given") end
        
        local totalShapes = n
        local maxShapeType = math.ceil(totalShapes / self.boxes)

        -- define shapesData
        local spawnFunctions = {
            typedShapes.createRectangle,
            typedShapes.createCircle,
            typedShapes.createTriangle
        }
        
        local shapesData = {}
        for i = 1, #spawnFunctions do
            shapesData[i] = {
                spawn = spawnFunctions[i],
                shapes = 0 
            }
        end

        -- spawn randomly all the shapes and return them
        local shapesList = {}
        local shapesListLength = 0
        local spawnerIdx, spawnerLastIdx = 1, #self
        while true do
            if totalShapes > 0 then
                -- choose random spawn function
                local spawn
                local s, e = 1, #shapesData
                while not spawn do
                    local idx = math.random(s, e)
                    local shapesNumber = shapesData[idx].shapes
                    if shapesNumber < maxShapeType then
                        spawn = shapesData[idx].spawn
                        shapesData[idx].shapes = shapesNumber + 1
                        totalShapes = totalShapes - 1
                    end
                end
                
                -- spawn and add to list
                local spawnerCoords = self[spawnerIdx]
                local shape = spawn(spawnerCoords.x, spawnerCoords.y)
                shapesListLength = shapesListLength + 1
                shapesList[shapesListLength] = shape

                if spawnerIdx == spawnerLastIdx then
                    spawnerIdx = 1
                else
                    spawnerIdx = spawnerIdx + 1
                end
            else
                break
            end
        end

        return shapesList
    end

    return spawnersGroup
end

return Spawners