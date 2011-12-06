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

RNGroup = {}

local function fieldChangedListener(self, key, value)

    getmetatable(self).__object[key] = value
    self = getmetatable(self).__object

    if key ~= nil and key == "x" then


        local deltax = self:getDelta(self.lastx, value)
        if self.lastx == nil then
            self.lastx = 0
        end

        if (value < self.lastx) then
            deltax = -deltax
        end

        for i = 1, self.numChildren,1 do
            local anObject = self.displayObjects[i]
            anObject.x = anObject.x + deltax
        end
        self.lastx = value
    end

    if key ~= nil and key == "y" then

        local deltay = self:getDelta(self.lasty, value)

        if self.lasty == nil then
            self.lasty = 0
        end

        if (value < self.lasty) then
            deltay = -deltay
        end

        for i = 1, self.numChildren,1 do
            local anObject = self.displayObjects[i]
            anObject.y = anObject.y + deltay
        end
        self.lasty = value
    end

    if key ~= nil and key == "rotation" then
        self:getProp():setRot(value)
    end

    if key ~= nil and key == "visible" then
        self:setVisible(value)
    end
    if key ~= nil and key == "isVisible" then
        self:setVisible(value)
    end

    --if key == "isFocus" and value == true then
    --    -- TODO: implement focus handling
    -- end
end


local function fieldAccessListener(self, key)
    if getmetatable(self).__object[key] == nil then
        getmetatable(self).__object[key] = {}
    end
    return getmetatable(self).__object[key]
end

function RNGroup:new(o)
    local displayobject = RNGroup:innerNew()
    local proxy = setmetatable({}, { __newindex = fieldChangedListener, __index = fieldAccessListener, __object = displayobject })
    proxy.displayObjects = {}
    proxy.numChildren = 0
    proxy.y = 0
    proxy.lasty = 0
    proxy.x = 0
    proxy.lastx = 0
    proxy.levels = {}
    proxy.levels[1] = 1
    return proxy, displayobject
end

function RNGroup:innerNew(o)
    o = o or {
        name = "",
        visible = true,
    }

    setmetatable(o, self)
    self.__index = self
    return o
end


function RNGroup:setScreen(screen)
    self.screen = screen
end

function RNGroup:insert(object, resetTransform)

    if resetTransform == true then
        object.x = 0
        object.y = 0
    end

    if object.setParentGroup ~= nil then
        object:setParentGroup(self)
    end

    local level = self:getHighestLevel() + 1

    object:setLevel(level)

    self.levels[level] = level

    self.numChildren = self.numChildren + 1
    self.displayObjects[self.numChildren] = object
    object:setIDInGroup(self.numChildren)
end

function RNGroup:removeChild(id)
    len = table.getn(self.displayObjects)
    ind = id
    for i = 1, len, 1 do
        if (i == ind) then
            for k = ind + 1, len, 1 do
				self.displayObjects[k - 1] = self.displayObjects[k]
				self.displayObjects[k].idInGroup = k - 1
			end
            self.displayObjects[len] = nil
        end
    end
    --refresh other objects id
    for i, v in ipairs(self.displayObjects) do v.idInGroup = i end
    --
    self.numChildren=table.getn(self.displayObjects)
end

function RNGroup:inserLevel(level)
    self.levels[level] = level
end

function RNGroup:getLowestLevel()
    return math.min(unpack(self.levels))
end

function RNGroup:getHighestLevel()
    return math.max(unpack(self.levels))
end

function RNGroup:sendToBottom(object)
    local level = self:getLowestLevel() - 1
    object:setLevel(level)
    self.levels[level] = level
end

function RNGroup:bringToFront(object)
    local level = self:getHighestLevel() + 1
    object:setLevel(level)
    self.levels[level] = level
end

function RNGroup:setReferencePoint(referencePoint)
end

function RNGroup:setFocus(value)
end

function RNGroup:remove(value)
end

function RNGroup:removeSelf()
end

function RNGroup:addEventListener(event, button)
end


function RNGroup:setVisible(value)
    for i = 0, self.numChildren - 1 do
        local anObject = self.displayObjects[i]
        if anObject ~= nil and type(anObject.getProp) ~= "table" and anObject:getProp() ~= nil then
            anObject.visible = value
        end
    end
end

function RNGroup:getDelta(a, b)
    if a == nil then
        a = 0
    end

    if (a > b) then
        return a - b
    else
        return b - a
    end
end

function RNGroup:getDelta01(a, b)
    if a == nil then
        a = 0
    end
    if (a >= 0) then
        return -1 * (a - b)
    else
        return -1 * (b - a)
    end
end