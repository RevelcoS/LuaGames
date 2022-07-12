local physics = require "physics"
local sizeConfig = require "resources.config.size_config"

local M = {}

local lineWidth = sizeConfig["lineWidth"]
local height = display.contentHeight
local width = display.contentWidth

local function drawRect(drawParams)
    local rect = display.newRect( unpack(drawParams) )
    rect.name = "border"
    physics.addBody(rect, "static")
    rect.fill = {0.5, 0.5, 0.5}
    return rect
end

function M.createFloor()
    local params = {
        display.contentCenterX,
        height - lineWidth / 2,
        width,
        lineWidth,
    }
    return drawRect(params)
end

function M.createBoxes(n)
    -- n - number of boxes
    local n = n or 3
    local boxSideHeight = sizeConfig["boxSideHeight"]
    local boxSideWidth = sizeConfig["boxSideWidth"]

    local boxSides = {}
    local dx = (width - boxSideWidth) / n
    for i = 1, n + 1 do
        local x = boxSideWidth / 2 + (i - 1) * dx
        local y = height - (boxSideWidth + boxSideHeight / 2)
        local params = {x, y, boxSideWidth, boxSideHeight}
        boxSides[i] = drawRect(params)
    end

    return boxSides
end

function M.createBorders()
    local centerX = display.contentCenterX
    local centerY = display.contentCenterY

    local leftBorderParams = {
        -lineWidth / 2,
        centerY,
        lineWidth,
        height
    }
    drawRect(leftBorderParams)

    local rightBorderParams = {
        width + lineWidth / 2,
        centerY,
        lineWidth,
        height
    }
    drawRect(rightBorderParams)

    local topBorderParams = {
        centerX,
        -lineWidth / 2,
        width,
        lineWidth
    }
    drawRect(topBorderParams)

    local bottomBorderParams = {
        centerX,
        height + lineWidth / 2,
        width,
        lineWidth
    }
    drawRect(bottomBorderParams)
end

return M