local Particle = require "particle"

display.setDefault("background", 1)

math.randomseed(os.time())
physics.start()

local x, y = display.contentCenterX, display.contentCenterY
local mouseOn = false

local function loop(event)
    if mouseOn then
        local options = {
            x = x, y = y
        }

        local particle = Particle.new(options)
        particle.start()
    end
end

local function onMouseEvent(event)
    x, y = event.x, event.y
    if event.type == "down" then
        mouseOn = true
    elseif event.type == "up" then
        mouseOn = false
    end
end

Runtime:addEventListener("enterFrame", loop)
Runtime:addEventListener("mouse", onMouseEvent)