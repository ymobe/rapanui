------------------------------------------------------------------------------------------------------------------------
--
-- RapaNui
--
-- by Ymobe ltd  (http://ymobe.co.uk)
--
-- LICENSE:
--
-- RapaNui uses the Common Public Attribution License Version 1.0 (CPAL) http://www.opensource.org/licenses/cpal_1.0.
-- CPAL is an Open Source Initiative approved
-- license based on the Mozilla Public License, with the added requirement that you attribute
-- Moai (http://getmoai.com/) and RapaNui in the credits of your program.
--
------------------------------------------------------------------------------------------------------------------------

RNScreen = {}

function RNScreen:new(o)

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
    self.images = {}
    self.images_size = 0
    return o
end

function RNScreen:getName()
    return self.name
end

function RNScreen:setName(name)
    self.name = name
end

function RNScreen:initWith(width, height)
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

function RNScreen:addRNObject(RNObject, mode)

    if RNObject == nil then
        return
    end

    self.images[self.images_size] = RNObject

    self.images_size = self.images_size + 1

    RNObject:setLocatingMode(mode)
    self.layer:insertProp(RNObject:getProp())
    RNObject:setParentScene(self)
    RNObject:updateLocation()
    self.sprites[self.spriteIndex] = RNObject
    self.spriteIndex = self.spriteIndex + 1
end

function RNScreen:getImages()
    return self.images
end