local physics = require "physics"
local tools = require "tools"

local M = {}

local randrange = tools.randrange
local map = tools.map

function M.new(options)
    --Options
    local options = options or {}
    local minr = options.minr or 27
    local maxr = options.maxr or 30
    local r = randrange({minr, maxr})
    local x = options.x or display.contentCenterX
    local y = options.y or display.contentCenterY

    local rRange = {0.9, 1} or options.rRange
    local gRange = {0.2, 0.5} or options.gRange
    local bRange = {0.1, 0.2} or options.bRange
    local tpsRange = {0.3, 0.4} or options.tpsRange
    local color = map({rRange, gRange, bRange, tpsRange}, randrange)

    local lifetime = options.lifetime or 2000

    --Init
    local particle = display.newCircle(x, y, r)
    particle:setFillColor(unpack(color))

    function particle.start()
        physics.addBody(particle, "dinamic", {isSensor=true})
        particle.gravityScale = -1.5
        particle:applyForce(randrange({-5, 5}), randrange({-5, 5}))
        transition.to(particle, {
            time=lifetime, alpha=0,
            xScale=0.1, yScale=0.1,
            transition=easing.outQuad,
            onComplete=function()
                particle:removeSelf()
                particle=nil
            end})
    end

    return particle
end

return M