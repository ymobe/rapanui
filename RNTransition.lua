----------------------------------------------------------------
-- RapaNui Framework 0.1
--
----------------------------------------------------------------
module(..., package.seeall)

MOVE = "move"
ROTATE = "rotate"

-- Create a New Transition Object
function RNTransition:new(o)
	o = o or {
		name = ""
	}
	setmetatable(o, self)
	self.__index = self
	return o
end

mainSprite = nil

function RNTransition:run(type, sprite, props)

	if (props.x ~= nil) then
	--print("x value:" .. props.x)
	end

	if (props.y ~= nil) then
	--print("y value:" .. props.y)
	end

	if (type == MOVE) then
	--[[


		local tx, ty = self:getTranslatedLocation(sprite, props.y, props.x)
		local spriteScrX, spriteScrY = sprite:getScreenUILocation()

		local locX, locy = sprite:getProp():getLoc();
		print("===========================================================================================")
		print("Event     						      loc X: " .. props.x .. " Y: " .. props.y)
		print("Relative sprite:getProp():getLoc();    loc X: " .. locX .. " locy: " .. locy)
		print("Sprite   sprite:getScreenUILocation()  loc X: " .. spriteScrX .. " locy: " .. spriteScrY)


		local locX, locy = sprite:getProp():getLoc();

		print("Sprite delta X: " .. deltaX .. " locy: " .. deltaY)

		--local action = sprite:getProp():moveLoc(deltaX, deltaY, 2)
		--local action = sprite:getProp():moveLoc(deltaX, (-1) * deltaY, 2)
		--local action = sprite:getProp():moveLoc(deltaX, (-1) * deltaY, 2)
		--local action = sprite:getProp():move(10, 0,0, 0, 0, 2)
		local locX, locy = sprite:getProp():getLoc();
		print("BEFORE MOVE X: " .. locX .. " Y: " .. locy)
                                              ]] --
		local deltaX = self:getDelta(spriteScrX, props.x);
		local deltaY = self:getDelta(spriteScrY, props.y);

		--local action = sprite:getProp():move(deltaX, 0, 2)
		local action = sprite:getProp():moveRot(-360, 2)
		--action:setListener ( MOAIAction.EVENT_STOP, function () print ( "end" ) end )
		--while action:isBusy() do coroutine.yield() end
		local locX, locy = sprite:getProp():getLoc();
		print("AFTTER MOVE X: " .. locX .. " Y: " .. locy)




	--sprite:setLocation(props.x, props.y)
	end

	if (type == ROTATE) then
		local action = sprite:getProp():moveRot(-360, 2)
	end
end




function RNTransition:getDelta(a, b)
	if (a > b) then
		return a - b
	else
		return b - a
	end
end

function RNTransition:getTranslatedLocation(sprite, x, y)

	local screenWidth, screenHeight = sprite:getScreenSize();

	--print(" transition screenW: " .. screenWidth .. " transition screenH:  " .. screenHeight)

	local translatedX = 0;
	local translatedY = 0;

	--print(" Location mode: " .. sprite:getLocatingMode())

	if (sprite:getLocatingMode() == TOP_LEFT_MODE) then

		if (x > screenWidth / 2) then
			translatedX = (screenWidth / 2) - (screenWidth - x) + sprite:getOriginalWidth() / 2
		else
			translatedX = screenWidth / 2 - (screenWidth - x) + sprite:getOriginalWidth() / 2
		end

		if (y > screenHeight / 2) then
			translatedY = (-1) * ((screenHeight / 2) - (screenHeight - y)) - sprite:getOriginalHeight() / 2
		else
			translatedY = (screenHeight - y) - screenHeight / 2 - sprite:getOriginalHeight() / 2
		end
	else
		if (x > screenWidth / 2) then
			translatedX = (screenWidth / 2) - (screenWidth - x)
		else
			translatedX = screenWidth / 2 - (screenWidth - x) -- (-1) * screenWidth / 2 -
		end

		if (y > screenHeight / 2) then
			translatedY = (-1) * ((screenHeight / 2) - (screenHeight - y))
		else
			translatedY = (screenHeight - y) - screenHeight / 2
		end
	end

	return translatedX, translatedY
end