----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------
require("RNSprite")

-- Create a New Scene Object

RNScene = {}

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

--print("adding with mode ".. mode)

    if sprite == nil then
        print("found nil sprite")
        return
    end

    sprite:setLocatingMode(mode)
    self.layer:insertProp(sprite:getProp())
    sprite:setParentScene(self)
    sprite:updateLocation()
    self.sprites[self.spriteIndex] = sprite
    self.spriteIndex = self.spriteIndex + 1

    if sprite:getChildrenSize() > 0 then
    --print(sprite:getImageName())
    --print(sprite:getChildrenSize())

        for i = 0, sprite:getChildrenSize() - 1 do
            local spriteChild = sprite:getChildat(i)
            --  print("Call add sprite for child index [" .. i .. "]")
            self:addSpriteWithLocatingMode(spriteChild, mode)
        end
    end
end

function RNScene:getLayer()
    return self.layer
end

function RNScene:addSprite(sprite)
    self:addSpriteWithLocatingMode(sprite, 1)
end

function RNScene:getSprites()
    return self.sprites
end


function RNScene:hideAll()
    self.visible = false
    for key, value in pairs(self.sprites)
    do
        self.layer:removeProp(value:getProp())
        value:setVisible(false)
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
        value:setVisible(true)
    end
end

function RNScene:seekColor(r, g, b, a, time, mode)
    local currentSceneSprites = self:getSprites()

    local action = nil

    for key, value in pairs(currentSceneSprites)
    do
        action = value:getProp():seekColor(r, g, b, a, time, mode)
    end
    return action
end

function RNScene:seekColorToDefault(r, g, b,  time, mode)
    local currentSceneSprites = self:getSprites()

    local action = nil

    for key, value in pairs(currentSceneSprites)
    do
        action = value:getProp():seekColor(r, g, b, value:getAlpha(), time, mode)
    end
    return action
end

function RNScene:setColor(r, g, b, a, time, mode)
    local currentSceneSprites = self:getSprites()

    local action = nil

    for key, value in pairs(currentSceneSprites)
    do
        value:getProp():setColor(r, g, b, a, mode)
    end
end
