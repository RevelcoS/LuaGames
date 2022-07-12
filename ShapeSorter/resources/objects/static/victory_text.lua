local colorConfig = require "resources.config.shape_color_config"

local VictoryText = {}

local function randomColor(colorConfig)
    local colorList = {}
    local idx = 0
    for _, v in pairs(colorConfig) do
        idx = idx + 1
        colorList[idx] = v
    end

    local s, e = 1, idx
    local colorIdx = math.random(s, e)
    local color = colorList[colorIdx]

    return color
end

function VictoryText.new()
    local textStr = "You won!"
    local x = display.contentCenterX
    local y = 100
    local width = 130
    local height = 50
    local font = native.systemFont
    local fontSize = 30
    local fillColor = {1, 0.4, 0.3}

    local params = {
        textStr,
        x, y,
        width, height, 
        font, fontSize
    }
    local text = display.newText( unpack(params) )
    text.fill = randomColor( colorConfig )
    return text
end

return VictoryText