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
        --        sprites = {},
        --        numSprites = 0,
        width = 0,
        height = 0,
        spriteIndex = 0,
        viewport = nil,
        layer = nil,
        layers = nil,
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
    self.layers = RNLayer:new()
    self.layer, self.mainPartition = self.layers:createLayerWithPartition(RNLayer.MAIN_LAYER, self.viewport)
    self.layer:setViewport(self.viewport)

    self.layer:setPartition(self.mainPartition)

    MOAISim.pushRenderPass(self.layer)
end

--[[
    layer parameter can be either partition or layer since
    both MOAIObjects have the insertProp function.
--]]


function RNScreen:putOnLayer(object, layer)
    if object:getType() == "RNObject" or object:getType() == "RNText" then
        if object.layer == nil then
            self:addRNObject(object, nil, layer)
        else
            self:removeRNObject(object, object.layer)
            self:addRNObject(object, nil, layer)
        end
    elseif object:getType() == "RNGroup" then
        local childrenTable = object:getAllChildren()
        for i = 1, #childrenTable do
            self:putOnLayer(childrenTable[i], layer)
        end
    elseif object:getType() == "RNButton" then
        local childrenTable = object:getAllChildren()
        for i = 1, #childrenTable do
            self:putOnLayer(childrenTable[i], layer)
        end
    end
    object.layer = layer
end

function RNScreen:removeFromLayer(object, layer)
    if layer == nil then
        layer = object.layer
    end
    if object:getType() == "RNObject" or object:getType() == "RNText" then
        self:removeRNObject(object, layer)
    elseif object:getType() == "RNGroup" then
        local childrenTable = object:getAllChildren()
        for i = 1, #childrenTable do
            self:removeFromLayer(childrenTable[i], layer)
        end
    elseif object:getType() == "RNButton" then
        local childrenTable = object:getAllChildren()
        for i = 1, #childrenTable do
            self:removeFromLayer(childrenTable[i], layer)
        end
    end
    object.layer = nil
end

function RNScreen:addRNObject(object, mode, layer)

    if object == nil then
        return
    end

    if layer == nil then
        layer = self.mainPartition
    end

    object:setLocatingMode(mode)

    layer:insertProp(object:getProp())
    object:setParentScene(self)
    object:updateLocation()

    object.layer = layer

    object:getProp().RNObject = object
end

function RNScreen:removeRNObject(object, layer)

    if (layer == nil) then
        layer = self.layers:get(RNLayer.MAIN_LAYER)
    end

    layer:removeProp(object:getProp())

    object.layer = nil
end

function RNScreen:getObjectWithHighestLevelOn(x, y)




    local props
    if config.stretch.status == true then
        if config.stretch.letterbox == true then
            local toGetX, toGetY = (x - RNFactory.ofx) * RNFactory.Ax, (y - RNFactory.ofy) * RNFactory.Ay
            props = { self.mainPartition:propListForPoint(toGetX, toGetY + RNFactory.statusBarHeight * y / RNFactory.height, 0, MOAILayer.SORT_PRIORITY_DESCENDING) }
        else
            local toGetX, toGetY = (x - RNFactory.ofx) * RNFactory.Ax, (y - RNFactory.ofy) * RNFactory.Ay
            props = { self.mainPartition:propListForPoint(toGetX, toGetY + RNFactory.statusBarHeight * y / RNFactory.height, 0, MOAILayer.SORT_PRIORITY_DESCENDING) }
        end
    else
        props = { self.mainPartition:propListForPoint(x, y + RNFactory.statusBarHeight * y / RNFactory.height, 0, MOAILayer.SORT_PRIORITY_DESCENDING) }
    end


    for i = 1, #props do
        local currentProp = props[i]
        if currentProp.RNObject.touchable == true then
            return currentProp.RNObject
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