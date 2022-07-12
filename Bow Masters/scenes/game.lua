local composer = require("composer")
local stickMan = require("lib.stickman")
local physics = require("physics")

local scene = composer.newScene()

-- VARIABLES

local bgGroup
local mainGroup
local uiGroup

local leftPlatform
local rightPlatform

local leftStickMan
local rightStickMan
local stickManWithBow

local gameOver = false

local function changeTurn()
	stickManWithBow:setDefaultArms()
	stickManWithBow.weapon.isVisible = false
	stickManWithBow.isArrowShot = false

	if stickManWithBow.thisPlatform.name == "leftPlatform" then
		stickManWithBow = rightStickMan
	else
		stickManWithBow = leftStickMan
	end

	leftStickMan.turn = not leftStickMan.turn
	rightStickMan.turn = not rightStickMan.turn

	if leftStickMan.turn then
		rightStickMan.arrow = nil
		stickManWithBow = leftStickMan
		rightStickMan:setBodyActivity(true)
		leftStickMan:setBow()
	else
		leftStickMan.arrow = nil
		stickManWithBow = rightStickMan
		leftStickMan:setBodyActivity(true)
		rightStickMan:setBow()
	end
end


local function checkArrowPos()
	if stickManWithBow.arrow and stickManWithBow.isArrowShot and not stickManWithBow.arrow.isCollided then

		local checkList = {
			stickManWithBow.arrow.x > display.contentWidth + 30,
			stickManWithBow.arrow.x < -30,
			stickManWithBow.arrow.y > display.contentHeight + 30
		}

		for i = 1, #checkList do
			if checkList[i] then
				stickManWithBow.arrow:setLinearVelocity(0, 0)
				stickManWithBow.arrow.gravityScale = 0
				stickManWithBow.arrow:removeSelf()
				stickManWithBow.weapon.isVisible = false
				stickManWithBow.isArrowShot = false
				changeTurn()
				break
			end
		end

	end
end

local function checkIfGameIsContinuing()
	local stickMans = {
		leftStickMan,
		rightStickMan
	}

	for i = 1, #stickMans do
		if stickMans[i].hp <= 0 then
			stickMans[i]:dead()
			gameOver = true
			break
		end
	end
end


local function collision(event)
	phase = event.phase

	if phase == "began" then
		local object1 = event.object1
		local object2 = event.object2

		local objectCombinations = {{object1, object2}, {object2, object1}}

		for i = 1, 2 do
			local obj1, obj2 = objectCombinations[i][1], objectCombinations[i][2]

			if obj1.name == "arrow" and not obj1.isCollided and obj2.name ~= "arrow" then
		
				obj1:setLinearVelocity(0, 0)
				obj1.gravityScale = 0

				obj1.isCollided = true
	
				if obj2.type == "bodyPart" then
					local stickman = obj2.owner
					table.insert(stickman.arrowsOnBody, obj1)

					if obj2.name == "head" then
						stickman.hp = stickman.hp - 30
					elseif obj2.name == "torso" then
						stickman.hp = stickman.hp - 20
					elseif obj2.name == "leftLeg" or obj2.name == "rightLeg" then
						stickman.hp = stickman.hp - 10
					end

					if stickman.hp <= 0 then
						gameOver = true
						leftStickMan.gameOver = true
						rightStickMan.gameOver = true
						timer.performWithDelay(20, stickman.dead)
					end
				end

				if not gameOver then
					timer.performWithDelay(40, changeTurn)
				end
			end
		end
	end
end


function scene:create(event)
    local sceneGroup = self.view

	-- Scene groups
    bgGroup = display.newGroup()
    sceneGroup:insert(bgGroup)

    mainGroup = display.newGroup()
    sceneGroup:insert(mainGroup)

    uiGroup = display.newGroup()
    sceneGroup:insert(uiGroup)

	-- Background
    local background = display.newImageRect(bgGroup, "images/background.jpeg", 480, 320)
    background.x = display.contentCenterX
	background.y = display.contentCenterY

	-- Platforms
	local leftPlatformX = 90
	local leftPlatformY = math.random(150, display.contentHeight - 100)
	leftPlatform = display.newRect(leftPlatformX, leftPlatformY, 90, 14)
	leftPlatform:setFillColor(0.2, 0.2, 0.2)
	leftPlatform.name = "leftPlatform"

	local rightPlatformX = display.contentWidth - 90
	local rightPlatformY = math.random(150, display.contentHeight - 100)
	rightPlatform = display.newRect(rightPlatformX, rightPlatformY, 90, 14)
	rightPlatform:setFillColor(0.2, 0.2, 0.2)
	rightPlatform.name = "rightPlatform"
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Stickmans
		local num = math.random(2)
		leftStickManTurn = true
		if num == 1 then
			leftStickManTurn = false
		end

		physics.start()

		physics.addBody(rightPlatform, "static")
		physics.addBody(leftPlatform, "static")

		leftStickMan = stickMan.new({platform = leftPlatform, turn = leftStickManTurn})
		rightStickMan = stickMan.new({platform = rightPlatform, turn = not leftStickManTurn})

		if leftStickMan.turn then
			stickManWithBow = leftStickMan
		else
			stickManWithBow = rightStickMan
		end

		Runtime:addEventListener("collision", collision)
		Runtime:addEventListener("enterFrame", checkArrowPos)
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene