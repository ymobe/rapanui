----------------------------------------------------------------
-- RapaNui Framework 0.1
--
----------------------------------------------------------------
module(..., package.seeall)


-- Create a New Scene Object

function RNScene:new(o)

	o = o or {
		name = "",
		width = 0,
		height = 0,
		viewport = nil,
		layer = nil
	}

	setmetatable(o, self)
	self.__index = self
	return o
end



function RNScene:initWith(width, height)
	self.width = width
	self.height = height
	self.viewport = MOAIViewport.new()
	self.viewport:setSize(width, height)
	self.viewport:setScale(width, -height)
	self.viewport:setOffset ( -1, 1 )
	self.layer = MOAILayer2D.new()
	self.layer:setViewport(self.viewport)
	MOAISim.pushRenderPass(self.layer)
end


function RNScene:addSpriteWithLocatingMode(sprite, mode)
	sprite:setScreenSize(self.width, self.height)
	sprite:setLocatingMode(mode)
	self.layer:insertProp(sprite:getProp())
	sprite:updateLocation()
end


function RNScene:addSprite(sprite)
	self:addSpriteWithLocatingMode(sprite, RNSprite.CENTERED_MODE)
end