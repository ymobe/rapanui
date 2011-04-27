MOAISim.openWindow("test", 320, 480)

require("RNSprite")
require("RNScene")
require("RNTransition")

mainsprite = nil

propTest = nil

local function main()



	local background = RNSprite:new()

	local scene = RNScene:new()

	scene:initWith(320, 480)

	background:initWith("background.png")

	scene:addSpriteWithLocatingMode(background, RNSprite.TOP_LEFT_MODE)


	background:setLocation(0, 0)

	local sprite2 = RNSprite:new();

	sprite2:initWith("color_2.png")

	sprite2:setLocation(0, 0)

	local sprite3 = RNSprite:new();

	sprite3:initWith("color_1.png")

	sprite3:setLocation(100, 448)

	mainsprite = sprite2

	scene:addSpriteWithLocatingMode(sprite2, RNSprite.TOP_LEFT_MODE)
	scene:addSpriteWithLocatingMode(sprite3, RNSprite.TOP_LEFT_MODE)
end

main()

function onTouchEvent(eventType, idx, x, y, tapCount)

	if (eventType == MOAITouchSensor.TOUCH_DOWN) then
		local animation = RNTransition:new()
		animation:run(RNTransition.MOVE, mainsprite, { x = x, y = y })
	end
end

MOAIInputMgr.device.touch:setCallback(onTouchEvent)