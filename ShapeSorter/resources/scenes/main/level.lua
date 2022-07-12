local composer = require "composer"
local physics = require "physics"

local objectsDir = "resources.objects."
local typedShapes = require(objectsDir .. "dynamic.shapes.typed_shapes")
local line = require(objectsDir .. "static.line") 
local spawners = require(objectsDir .. "control.spawners")
local boxZones = require(objectsDir .. "control.boxZones")

local scene = composer.newScene()

local bg
local floor
local boxesTable
local spawnersTable
local boxZonesTable
local shapesList

local boxes = 3
local totalShapes = 21

local function insertTableToDisplayGroup(t, group)
	for i = 1, #t do
		group:insert( t[i] )
	end
end

function scene:create( event )

	local sceneGroup = self.view
	physics.start()
	physics.setContinuous( false )
	
	-- display groups
	local bgGroup = display.newGroup()
	local mainGroup = display.newGroup()

	-- objects
	-- bg
	local bg = display.newRect(
    display.contentCenterX,
    display.contentCenterY,
    display.contentWidth,
    display.contentHeight
	)
	bg:setFillColor(0.6, 0.7, 0.8)
	bgGroup:insert(bg)

	-- main
	boxZonesTable = boxZones.new(boxes)
	insertTableToDisplayGroup(boxZonesTable, mainGroup)


	floor = line.createFloor()
	mainGroup:insert(floor)

	boxesTable = line.createBoxes(boxes)
	insertTableToDisplayGroup(boxesTable, mainGroup)

	line.createBorders()


	spawnersTable = spawners.new(boxes, display.contentHeight - 100)


	sceneGroup:insert(bgGroup)
	sceneGroup:insert(mainGroup)
end

local function enterFrame(event)

	local elapsed = event.time

end

function scene:show( event )

	local phase = event.phase
	if ( phase == "will" ) then
		Runtime:addEventListener( "enterFrame", enterFrame )
	elseif ( phase == "did" ) then
		shapesList = spawnersTable:spawn(totalShapes)
		boxZonesTable:startCheck( shapesList )
	end
end

function scene:hide( event )

	local phase = event.phase
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		Runtime:removeEventListener( "enterFrame", enterFrame )
	end
end

function scene:destroy( event )

	--collectgarbage()
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene