local physics = require("physics")
local vector2D = require("plugins.vector2D")

local M = {}

function M.new(options)
    local instance = {}
    instance.thisPlatform = options.platform
    instance.turn = options.turn
    instance.weapon = display.newImage("images/bow.png", 50, 50, 20, 40)
    instance.weapon.isVisible = false
    instance.isArrowShot = false
    instance.hp = 100
    instance.armsSet = false
    instance.gameOver = false
    instance.arrowsOnBody = {}
    instance.arrowShotSound = audio.loadSound("sounds/BowShot.mp3")

    instance.stickWidth = 5
    instance.stickHeight = 40
    instance.cornerRadius = 2.5
    instance.spaceDegrees = 60
    
    -- Rotate the bow
    if instance.thisPlatform.name == "rightPlatform" then
        instance.bowRotateDegrees = instance.spaceDegrees / 2 - 90
    else
        instance.bowRotateDegrees = 270 - (instance.spaceDegrees / 2)
    end

    instance.weapon.rotation = instance.bowRotateDegrees

    -- StickMan Body
    local instanceBody = {}

    -- Legs
    local rightLegX = instance.thisPlatform.x + (instance.stickHeight / 2) * math.sin(math.rad(instance.spaceDegrees / 2))
    local rightLegY = instance.thisPlatform.y - (instance.thisPlatform.height / 2) - ((instance.stickHeight / 2) * math.cos(math.rad(instance.spaceDegrees / 2)))
    instanceBody.rightLeg = display.newRoundedRect(rightLegX, rightLegY,
        instance.stickWidth, instance.stickHeight, instance.cornerRadius)
    instanceBody.rightLeg.rotation = -(instance.spaceDegrees / 2)
    instanceBody.rightLeg.name = "rightLeg"
    instanceBody.rightLeg.owner = instance

    local leftLegX = instance.thisPlatform.x - (instance.stickHeight / 2) * math.sin(math.rad(instance.spaceDegrees / 2))
    local leftLegY = rightLegY
    instanceBody.leftLeg = display.newRoundedRect(leftLegX, leftLegY,
        instance.stickWidth, instance.stickHeight, instance.cornerRadius)
    instanceBody.leftLeg.rotation = instance.spaceDegrees / 2
    instanceBody.leftLeg.name = "leftLeg"
    instanceBody.leftLeg.owner = instance

    -- Torso
    local torsoX = instance.thisPlatform.x
    local torsoY = instance.thisPlatform.y - instance.stickHeight * math.cos(math.rad(instance.spaceDegrees / 2)) - (instance.stickHeight / 2)
    instanceBody.torso = display.newRoundedRect(torsoX, torsoY,
        instance.stickWidth, instance.stickHeight, instance.cornerRadius)
    instanceBody.torso.name = "torso"
    instanceBody.torso.owner = instance

    -- Head
    local headRadius = 10
    instance.headRadius = headRadius
    local headX = instance.thisPlatform.x
    local headY = torsoY - (instance.stickHeight / 2) - headRadius + 5
    instanceBody.head = display.newCircle(headX, headY, headRadius)
    instanceBody.head.name = "head"
    instanceBody.head.owner = instance

    instance.body = instanceBody    -- Inserting body into instance

    for k, v in pairs(instance.body) do
        physics.addBody(v, {isSensor = true})
        v.gravityScale = 0
        v.isFixedRotation = true
    end

    -- Arms and hands
    function instance:setDefaultArms()

        if instance.armsSet then
            for k, v in pairs({instance.body.leftArm, instance.body.rightArm}) do
                v:removeSelf()
            end
        end

        local platform = instance.thisPlatform
        local rightArmX = platform.x
        local rightArmY = instance.body.head.y + instance.headRadius
        instance.body.rightArm = display.newRoundedRect(rightArmX,
            rightArmY, instance.stickWidth, instance.stickHeight, instance.cornerRadius)
        instance.body.rightArm.rotation = -(instance.spaceDegrees / 2)
        instance.body.rightArm:setFillColor(0, 0, 0)

        local leftArmX = rightArmX
        local leftArmY = rightArmY
        instance.body.leftArm = display.newRoundedRect(leftArmX,
            leftArmY, instance.stickWidth, instance.stickHeight, instance.cornerRadius)
        instance.body.leftArm.rotation = instance.spaceDegrees / 2
        instance.body.leftArm:setFillColor(0, 0, 0)

        local platformName = instance.thisPlatform.name
        local leftArm = instance.body.leftArm
        local rightArm = instance.body.rightArm

        if platformName == "rightPlatform" then
            leftArm.anchorX, leftArm.anchorY = 1, 0
            rightArm.anchorX, rightArm.anchorY = 0, 0
        elseif platformName == "leftPlatform" then
            leftArm.anchorX, leftArm.anchorY = 1, 0
            rightArm.anchorX, rightArm.anchorY = 0, 0
        end

        instance.armsSet = true
    end


    function instance:setBodyActivity(bool)
        for k, v in pairs(instance.body) do
            v.isBodyActive = bool
        end
    end


    function instance:setBow()
        -- Bow and arrow
        local platformName = instance.thisPlatform.name
        instance:setBodyActivity(false)
        instance.weapon.rotation = instance.bowRotateDegrees

        instance.weapon:toFront()
        instance.weapon.isVisible = true
        instance.arrow = display.newImage("images/arrow.png", 50, 50, 29, 3)
        instance.arrow.isCollided = false
        instance.weapon.anchorX, instance.arrow.anchorX = 0, 0.8
        instance.weapon.anchorY, instance.arrow.anchorY = 0.5, 0.5
        physics.addBody(instance.arrow, {isSensor = true, density = 1.3})
        instance.arrow.gravityScale = 0
        instance.arrow.isFixedRotation = true
        instance.arrow.isBullet = true
        instance.arrow.name = "arrow"
        instance.arrow.owner = instance

        local d = 2 * instance.stickHeight * math.sin(math.rad(instance.spaceDegrees / 4))
        local weaponX
        local weaponY = instance.body.leftArm.y + ((instance.stickHeight ^ 2 - d ^ 2) ^ 0.5)
        if platformName == "rightPlatform" then
            weaponX = instance.thisPlatform.x - d - 2
        else
            weaponX = instance.thisPlatform.x + d + 2
        end


        instance.weapon.x, instance.arrow.x = weaponX, weaponX 
        instance.weapon.y, instance.arrow.y = weaponY, weaponY
        instance.arrow.rotation = instance.bowRotateDegrees + 180

        -- Change arm position
        if platformName == "rightPlatform" then
            instance.body.rightArm:removeSelf()
            instance.body.rightArm = display.newRoundedRect(0, 0,
                instance.stickWidth, instance.stickHeight / 2 + 4, instance.cornerRadius)
            local rightArm = instance.body.rightArm
            rightArm.anchorX, rightArm.anchorY = 1, 0
            rightArm.x, rightArm.y = instance.body.leftArm.x, instance.body.leftArm.y
            rightArm.rotation = instance.spaceDegrees / 2
            rightArm:setFillColor(0, 0, 0)
        elseif platformName == "leftPlatform" then
            instance.body.leftArm:removeSelf()
            instance.body.leftArm = display.newRoundedRect(0, 0,
                instance.stickWidth, instance.stickHeight / 2 + 4, instance.cornerRadius)
            local leftArm = instance.body.leftArm
            leftArm.anchorX, leftArm.anchorY = 0, 0
            leftArm.x, leftArm.y = instance.body.rightArm.x, instance.body.rightArm.y
            leftArm.rotation = -(instance.spaceDegrees / 2)
            leftArm:setFillColor(0, 0, 0)
        end
    end

    function instance:dead()
        local arms = {
            instance.body.leftArm,
            instance.body.rightArm
        }

        for k, v in pairs(arms) do
            physics.addBody(v)
        end

        for k, v in pairs(instance.body) do
            v.gravityScale = 4
            v.isFixedRotation = false
            v.isSensor = false
        end

        for k, v in pairs(instance.arrowsOnBody) do
            v.gravityScale = 4
            v.isFixedRotation = false
            v.isSensor = false
        end
    end

    instance:setDefaultArms()

    -- Color and setting types
    for k, v in pairs(instance.body) do
        v:setFillColor(0, 0, 0)
        v.type = "bodyPart"
    end

    -- Bow
    if instance.turn then
        instance:setBow()
    end

    local function shootArrow(event)
        if instance.turn and not instance.isArrowShot and not instance.gameOver then
            local phase = event.phase

            if phase == "began" then
                instance.xOffSet = event.x
                instance.yOffSet = event.y
                instance.auxiliaryVector = vector2D.new(0, 1)
                instance.mainVector = vector2D.new(0, 0)
                instance.dot = display.newCircle(instance.xOffSet, instance.yOffSet, 1)
                instance.dot:setFillColor(1, 0, 0)
            
            elseif phase == "moved" then
                local newX = event.x
                local newY = event.y
                instance.mainVector = vector2D.new(newX - instance.xOffSet, newY - instance.yOffSet)

                instance.angle = instance.mainVector:angleTo(instance.auxiliaryVector)

                local activeBodyParts = {
                    instance.body.leftArm,
                    instance.body.rightArm,
                    instance.weapon,
                    instance.arrow
                }

                if instance.mainVector[1] ~= 0 or instance.mainVector[2] ~= 0 then
                    for i = 1, #activeBodyParts do
                        if instance.mainVector[1] <= 0 then
                            activeBodyParts[i].rotation = instance.angle + 180
                        else
                            activeBodyParts[i].rotation = -instance.angle - 180
                        end
                    end

                    instance.weapon.rotation = instance.weapon.rotation - 90
                    instance.arrow.rotation = instance.arrow.rotation + 90

                    local x
                    if instance.mainVector[1] <= 0 then
                        x = instance.body.leftArm.x - instance.stickHeight * math.cos(math.rad(instance.angle - 270))
                        instance.arrow.x = x
                    else
                        x = instance.body.leftArm.x + instance.stickHeight * math.cos(math.rad(instance.angle - 270))
                        instance.arrow.x = x
                    end

                    local y = instance.body.leftArm.y - instance.stickHeight * math.sin(math.rad(instance.angle - 270))

                    instance.weapon.x = x
                    instance.weapon.y, instance.arrow.y = y, y
                end

            elseif phase == "ended" or phase == "cancelled" then
                local function sign(x)
                    return x / math.abs(x)
                end

                instance.arrow.gravityScale = 1
                local maxXVel = 500
                local maxYVel = 500
                local xVel = -instance.mainVector[1] * 5
                local yVel = -instance.mainVector[2] * 5

                if math.abs(xVel) > maxXVel then
                    xVel = sign(xVel) * maxXVel
                end

                if math.abs(yVel) > maxYVel then
                    yVel = sign(yVel) * maxYVel
                end

                instance.arrow:setLinearVelocity(xVel, yVel)
                display.currentStage:setFocus(nil)

                instance.isArrowShot = true
                instance.dot:removeSelf()
                instance.dot = nil

                audio.play(instance.arrowShotSound)
            end
        end
    end


    local function rotateArrow()
        if instance.arrow and instance.isArrowShot and not instance.arrow.isCollided then
            local x, y = instance.arrow:getLinearVelocity()
            local velVector = vector2D.new(x, y)
            local auxiliaryVector = vector2D.new(0, 1)

            local angle = velVector:angleTo(auxiliaryVector)
            if velVector[1] <= 0 then
                angle = angle - 270
            else
                angle = -angle + 90
            end

            instance.arrow.rotation = angle
        end
    end

    local function enterFrame()
        rotateArrow()
    end

    Runtime:addEventListener("touch", shootArrow)
    Runtime:addEventListener("enterFrame", enterFrame)

    return instance
end

return M