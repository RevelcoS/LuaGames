local configDir = "resources.config."

local ColorConfig = require( configDir .. "shape_color_config" )
local SizeConfig = require ( configDir .. "size_config" )

local victoryText = require "resources.objects.static.victory_text"
local physicsFX = require "resources.fx.physics_fx"

local BoxZones = {}

function BoxZones.new(boxes)
    if not boxes then error("bad arguments") end

    local boxZoneHeight = SizeConfig["boxSideHeight"]
    local colorLightConst = 0.17
    local colorAlphaConst = 0.6

    local deltaCheckTimeBound = 1000 -- miliseconds

    local lastTime = 0
    local deltaCheckTime = 0

    local width = display.contentWidth
    local height = display.contentHeight

    -- box spacing
    local dx = width / boxes

    local function convertRGB(rgb)
        local newRGB = {}

        for i = 1, #rgb do
            local newColor = rgb[i]
            if newColor > 1 then
                newColor = 1
            end
            newRGB[i] = newColor
        end

        return newRGB
    end

    local function lightColor(rgb)
        local newRGB = {}

        for i = 1, #rgb do
            local newColor = rgb[i] + colorLightConst
            newRGB[i] = newColor
        end

        return convertRGB( newRGB )
    end

    local function copyList(t)
        local newList = {}
        for i = 1, #t do
            newList[i] = t[i]
        end
        return newList
    end

    local function drawBox(drawData)
        local xPos = drawData.xPos
        local fillColor = copyList( drawData.fillColor )

        local params = {
            xPos + dx / 2,
            height - boxZoneHeight / 2,
            dx,
            boxZoneHeight
        }
        local rect = display.newRect( unpack(params) )
        local newColor = lightColor( fillColor )
        newColor[#newColor + 1] = colorAlphaConst
        rect.fill = newColor
        return rect
    end

    local function storeCornersPositions(boxZone, xPos)
        local bottomLeftCornerPos = {
            x = xPos,
            y = height,
        }
        boxZone.bottomLeftCornerPos = bottomLeftCornerPos

        local topRightCornerPos = {
            x = xPos + dx,
            y = boxZoneHeight
        }
        boxZone.topRightCornerPos = topRightCornerPos
    end

    -- Init box zones
    -- xPos - bottom left position
    local boxZone1Target = "rectangle"
    local xPos1 = dx * 0
    local boxZone1Params = {
        xPos = xPos1,
        fillColor = ColorConfig[boxZone1Target]
    }
    local boxZone1 = drawBox(boxZone1Params)
    boxZone1.target = boxZone1Target
    storeCornersPositions(boxZone1, xPos1)

    local boxZone2Target = "circle"
    local xPos2 = dx * 1
    local boxZone2Params = {
        xPos = xPos2,
        fillColor = ColorConfig[boxZone2Target]
    }
    local boxZone2 = drawBox(boxZone2Params)
    boxZone2.target = boxZone2Target
    storeCornersPositions(boxZone2, xPos2)

    local boxZone3Target = "triangle"
    local xPos3 = dx * 2
    local boxZone3Params = {
        xPos = xPos3,
        fillColor = ColorConfig[boxZone3Target]
    }
    local boxZone3 = drawBox(boxZone3Params)
    boxZone3.target = boxZone3Target
    storeCornersPositions(boxZone3, xPos3)
    
    local boxZonesList = {
        boxZone1,
        boxZone2,
        boxZone3
    }

    function boxZonesList:check()
        local shapesList = self.shapes
        for i = 1, #shapesList do
            local shape = shapesList[i]
            local x, y = shape.x, shape.y
            for j = 1, #self do
                local boxZone = self[j]
                if boxZone.target == shape.shapeName then
                    local corner1 = boxZone.bottomLeftCornerPos
                    local x1, y1 = corner1.x, corner1.y

                    local corner2 = boxZone.topRightCornerPos
                    local x2, y2 = corner2.x, corner2.y

                    if x < x1 or x > x2 or y > y1 or y < y2 then
                        return false
                    end
                end
            end
        end

        return true
    end

    local function finishGame( shapes )
        victoryText.new()
        physicsFX.explode( shapes )
    end

    function boxZonesList:enterFrame( event )
        local time = event.time
        local delta = time - lastTime
        lastTime = time

        deltaCheckTime = deltaCheckTime + delta
        if deltaCheckTime > deltaCheckTimeBound then
            deltaCheckTime = 0

            if self:check() then
                Runtime:removeEventListener("enterFrame", self)
                finishGame( self.shapes )
            end
        end
    end

    function boxZonesList:startCheck( shapes )
        boxZonesList.shapes = shapes
        Runtime:addEventListener("enterFrame", self)
    end

    return boxZonesList
end

return BoxZones