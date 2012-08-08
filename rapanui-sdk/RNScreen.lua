--[[
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
]]



RNScreen = {}

function RNScreen:new(o)

    o = o or {
        name = "",
        sprites = {},
        numSprites = 0,
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

function RNScreen:initWith(width, height, screenWidth, screenHeight)
    self.width = width
    self.height = height
    self.viewport = MOAIViewport.new()
    self.viewport:setSize(screenWidth, screenHeight)
    self.viewport:setScale(width, -height)
    self.viewport:setOffset(-1, 1)
    self.layer = MOAILayer2D.new()
    self.layer:setViewport(self.viewport)

    self.mainPartition = MOAIPartition.new()
    self.layer:setPartition(self.mainPartition)

    MOAISim.pushRenderPass(self.layer)
end

function RNScreen:addRNObject(object, mode)

    if object == nil then
        return
    end

    object:setLocatingMode(mode)

    self.mainPartition:insertProp(object:getProp())
    object:setParentScene(self)
    object:updateLocation()

    self.numSprites = self.numSprites + 1
    self.sprites[self.numSprites] = object
    object:setIDInScreen(self.numSprites)

    object:getProp().rnObjectId = self.numSprites
end

function RNScreen:removeRNObject(object)
    self.layer:removeProp(object:getProp())
    local id = object.idInScreen
    local len = table.getn(self.sprites)
    local ind = id
    for i = 1, len, 1 do
        if (i == ind) then
            for k = ind + 1, len, 1 do
                self.sprites[k - 1] = self.sprites[k]
                self.sprites[k].idInScreen = k - 1
                self.sprites[k]:getProp().rnObjectId = k - 1
            end
            self.sprites[len] = nil
        end
    end

    --
    self.numSprites = table.getn(self.sprites)
end

function RNScreen:getObjectWithHighestLevelOn(x, y)

    local ofx = RNFactory.screenXOffset
    local ofy = RNFactory.screenYOffset

    local gx = config.graphicsDesign.w
    local gy = config.graphicsDesign.h
    local tx = RNFactory.width
    local ty = RNFactory.height

    --screen aspect without calculating offsets
    local Ax = gx / (tx - ofx * 2)
    local Ay = gy / (ty - ofy * 2)

    --screen aspect calculating offsets
    local AspectX = (gx + ofx * 2 * Ax) / tx
    local AspectY = (gy + ofy * 2 * Ay) / ty



    local props
    if config.stretch == true then
        local toGetX, toGetY = (x - ofx) * Ax, (y - ofy) * Ay
        --        print(x, y, toGetX, toGetY)
        props = { self.mainPartition:propListForPoint(toGetX, toGetY, 0, MOAILayer.SORT_PRIORITY_DESCENDING) }
    else
        props = { self.mainPartition:propListForPoint(x, y, 0, MOAILayer.SORT_PRIORITY_DESCENDING) }
    end

    for i, p in ipairs(props) do
        for j, k in ipairs(self.sprites) do
            if k.prop == p then
                if k.touchable == true then
                    --                    print(k.name)
                    return k
                end
            end
        end
    end
end

function RNScreen:getRNObjectWithHighestLevelOn(x, y)
    if self:getObjectWithHighestLevelOn(x, y) ~= nil then
        return self:getObjectWithHighestLevelOn(x, y)
    else
        return nil
    end
end

function RNScreen:getImages()
    return self.images
end

return RNScreen