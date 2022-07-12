local physics = require "physics"

local Shape = {}

function Shape.new(instance, addParams)
    if not instance then error("no instance") end
    local addParams = addParams or {}

    -- physics
    local params = {
        density = 1.2,
        friction = 0.3,
        bounce = 0.7,
        isSensor = false
    }
    for k, v in pairs(addParams) do
        params[k] = v
    end

    physics.addBody(instance, "dynamic", params)

    function instance:touch( event )
        local phase = event.phase
        
        if phase == "began" then
            display.getCurrentStage():setFocus(self)
            self.isFocus = true

            self.xOffSet = event.x
            self.yOffSet = event.y
            self:setLinearVelocity(0)
            self.bodyType = "kinematic"

            self.force = {dx = 0, dy = 0}
        
        elseif self.isFocus then
            if phase == "moved" then
                local dx = event.x - self.xOffSet
                local dy = event.y - self.yOffSet
                self.x, self.y = self.x + dx, self.y + dy

                self.xOffSet = event.x
                self.yOffSet = event.y

                self.force = {dx = dx, dy = dy}

            elseif phase == "ended" or phase == "cancelled" then
                display.getCurrentStage():setFocus(nil)
                self.isFocus = false

                self.bodyType = "dynamic"
                self:applyForce(self.force.dx * 40, self.force.dy * 40, self.x, self.y)
            end
        end
    end

    instance:addEventListener("touch", instance)

    return instance
end

return Shape