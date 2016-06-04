
-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
-- composer.gotoScene( "menu" )

local scene = composer.newScene()

local floor = display.newImage("background2.png")
local car = display.newImage("car2.png")
local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )

local totalTime = 60000
local floorSpeed = (floor.contentWidth - display.contentWidth) / totalTime
local virtualWidth = floor.contentWidth + 10000
local foreSpeed = virtualWidth / totalTime

local stones = {}
local craters = {}
local balls = {}

function scene:create( event )

	local sceneGroup = self.view

	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	sceneGroup:insert(background)

	floor.anchorX = 0
	floor.anchorY = 0
	floor.x, floor.y = 0, display.contentHeight - floor.contentHeight
	sceneGroup:insert(floor)

	car.x = 40
	car.y = floor.y + 50
	sceneGroup:insert(car)

	local stoneFreeDistance = 200
	for i=1,10 do
		local stone = display.newImage("rock0.png")
		stone.y = car.y
		stone.x = math.random(stoneFreeDistance, virtualWidth)
		sceneGroup:insert(stone)
		stones[i] = stone
	end

	for i=1,10 do
		local crater = display.newImage("crater0.png")
		crater.y = car.y + 25
		crater.x = math.random(stoneFreeDistance, virtualWidth)
		sceneGroup:insert(crater)
		craters[i] = crater
	end
end

local startTime = nil
local lastTime = nil

local jumpHeight = 200
local jumpDuration = 2500
local jumpSpeed = jumpHeight / (jumpDuration/2)
local jumpStart = nil
local gameEnded = false

function move( event )
	if startTime == nil then
		startTime = event.time
		lastTime = startTime
	end

	local timePassed = event.time - startTime

	if gameEnded then
		return
	end

	if timePassed >= totalTime then
		gameEnded = true
		local text = display.newText({
			text = "You win",
			x = display.contentWidth / 2,
			y = display.contentHeight / 2
			})
		text:setFillColor( 0, 1, 0, 1 )
		scene.view:insert(text)
		return
	end

	-- translate things

	floor.x = timePassed * floorSpeed * -1

	for i=1,#stones do
		stones[i]:translate( (event.time - lastTime) *  foreSpeed *-1,0)
	end

	for i=1,#craters do
		craters[i]:translate( (event.time - lastTime) *  foreSpeed *-1,0)
	end

	for i=#balls, 1, -1 do
		local thisBall = balls[i]
		if event.time - thisBall.born > 5000 then
			scene.view:remove(thisBall)
			table.remove(balls, i)
		else
			thisBall:translate( (event.time - lastTime) * floorSpeed, 0) -- 2 times of car
		end
	end

	-- jump if needed
	local jumping = isJumping(event)
	if jumping == 1 then
		car:translate(0, (event.time - lastTime) * jumpSpeed * -1)
	elseif jumping == -1 then
		car:translate(0, (event.time - lastTime) * jumpSpeed)
	else
		car.y = floor.y + 50
	end

	checkCollision()

	lastTime = event.time
end

function checkCollision()
	for i=#stones, 1, -1 do
		local thisStone = stones[i]
		for j=#balls, 1, -1 do
			local thisBall = balls[j]
			if isColliding(thisBall, thisStone) then
				table.remove(balls, j)
				table.remove(stones,i)
				scene.view:remove(thisBall)
				scene.view:remove(thisStone)
			end
		end
	end
	for i=1,#stones do
		local thisStone = stones[i]
		if isColliding(thisStone, car) then
			gameOver()
			return
		end
	end
	for i=1,#craters do
		local thisCrater = craters[i]
		if isColliding(thisCrater, car) then
			gameOver()
			return
		end
	end
end

function isColliding( obj1, obj2 )
	local obj1Rect = {
		x = obj1.x - obj1.width/2,
		y = obj1.y - obj1.height/2,
		width = obj1.width,
		height = obj1.height
	}
	local obj2Rect = {
		x = obj2.x - obj2.width/2,
		y = obj2.y - obj2.height/2,
		width = obj2.width,
		height = obj2.height
	}
	if obj1Rect.x < obj2Rect.x + obj2Rect.width and 
		obj1Rect.x + obj1Rect.width > obj2Rect.x and 
		obj1Rect.y < obj2Rect.y + obj2Rect.height and
		obj1Rect.height + obj1Rect.y > obj2Rect.y then

		return true
	end
	return false
end

local touchingCar = false
function runtimeTouch( event )
	if gameEnded then 
		return 
	end
	if event.phase == "began" and isColliding(car, {x=event.x, y=event.y, width=1, height=1}) then
		touchingCar = true
		return
	end
	if (event.phase == "ended" or event.phase == "cancelled") and touchingCar then
		touchingCar = false
		if event.yStart - event.y > 50 then
			jumpStart = event.time
		end
		return
	end
	if event.phase == "began" then
		local ball = display.newRect(car.x+40, car.y+10, 10, 10)
		ball:setFillColor(1,1,0,1)
		ball.born = event.time
		scene.view:insert(ball)
		table.insert(balls, ball)
	end
end

-- return 1 == moving up
-- return -1 == moving down
-- return 0 not jumping
function isJumping( event )
	if jumpStart == nil then
		return 0
	end
	if event.time - jumpStart < jumpDuration/2 then
		return 1
	elseif event.time - jumpStart < jumpDuration then
		return -1
	end
	return 0
end

function gameOver()
	gameEnded = true
	local text = display.newText({
		text = "Game over",
		x = display.contentWidth / 2,
		y = display.contentHeight / 2
		})
	text:setFillColor( 1, 0, 0, 1 )
	scene.view:insert(text)
	scene.view:remove(car)
end

Runtime:addEventListener("touch", runtimeTouch)

Runtime:addEventListener("enterFrame",move)

scene:addEventListener( "create", scene )

return scene