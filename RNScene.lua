----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------

module(..., package.seeall)


-- Create a New Scene Object

function RNScene:new(o)

    o = o or {
        name = "",
        sprites = {},
        width = 0,
        height = 0,
        spriteIndex = 0,
        viewport = nil,
        layer = nil,
        visible = true
    }

    setmetatable(o, self)
    self.__index = self
    return o
end

function RNScene:getName()
    return self.name
end

function RNScene:setName(name)
    self.name = name
end

function RNScene:initWith(width, height)
    self.width = width
    self.height = height
    self.viewport = MOAIViewport.new()
    self.viewport:setSize(width, height)
    self.viewport:setScale(width, -height)
    self.viewport:setOffset(-1, 1)
    self.layer = MOAILayer2D.new()
    self.layer:setViewport(self.viewport)
    MOAISim.pushRenderPass(self.layer)
end


function RNScene:addSpriteWithLocatingMode(sprite, mode)
    sprite:setScreenSize(self.width, self.height)
    sprite:setLocatingMode(mode)
    self.layer:insertProp(sprite:getProp())
    sprite:updateLocation()
    self.sprites[self.spriteIndex] = sprite
    self.spriteIndex = self.spriteIndex + 1
end

function RNScene:getLayer()
    return self.layer
end

function RNScene:addSprite(sprite)
    self:addSpriteWithLocatingMode(sprite, RNSprite.CENTERED_MODE)
end

function RNScene:getSprites()
    return self.sprites
end


function RNScene:hideAll()
    self.visible = false
    for key, value in pairs(self.sprites)
    do
        self.layer:removeProp(value:getProp())
    end
end

function RNScene:isVisible()
    return self.visible
end

function RNScene:showAll()
    self.visible = true
    for key, value in pairs(self.sprites)
    do
        self.layer:insertProp(value:getProp())
    end
end

function RNScene:seekColor(r, g, b, a, time, mode)
    local currentSceneSprites = self:getSprites()

    local action = nil

    for key, value in pairs(currentSceneSprites)
    do
        action = value:getShader():seekColor(r, g, b, a, time, mode)
    end
    return action
end

function RNScene:setColor(r, g, b, a, time, mode)
    local currentSceneSprites = self:getSprites()

    local action = nil

    for key, value in pairs(currentSceneSprites)
    do
        value:getShader():setColor(r, g, b, a, mode)
    end
end
