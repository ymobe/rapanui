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

RNGroup = {}

local function fieldChangedListener(self, key, value)

    getmetatable(self).__object[key] = value
    self = getmetatable(self).__object

    if key ~= nil and key == "x" then


        local xx, yy = self.prop:getLoc()
        self.prop:setLoc(value, yy)

        -- print(self.lastx, value)
        local deltax = self:getDelta(self.lastx, value)
        if self.lastx == nil then
            self.lastx = 0
        end

        if (value < self.lastx) then
            deltax = -deltax
        end


        for i = 1, self.numChildren, 1 do
            local anObject = self.displayObjects[i]
            anObject.x = anObject.x + deltax
        end



        self.lastx = value
    end

    if key ~= nil and key == "y" then

        local xx, yy = self.prop:getLoc()
        self.prop:setLoc(xx, value)

        local deltay = self:getDelta(self.lasty, value)

        if self.lasty == nil then
            self.lasty = 0
        end

        if (value < self.lasty) then
            deltay = -deltay
        end

        for i = 1, self.numChildren, 1 do
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
    local object = getmetatable(self).__object

    if key ~= nil and key == "x" then
        local xx, yy = object.prop:getLoc()
        object.x = xx
        object.y = yy
    end

    if key ~= nil and key == "y" then
        local xx, yy = object.prop:getLoc()
        object.x = xx
        object.y = yy
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


function RNGroup:setAlpha(value)
    for i, v in ipairs(self:getAllNonGroupChildren()) do
        v:setAlpha(value)
    end
end

function RNGroup:getAllNonGroupChildren()
    --returns all children , sub-groups excluded
    local t = {}
    for i, v in ipairs(self.displayObjects) do
        if v:getType() == "RNGroup" then
            local gt = v:getAllNonGroupChildren()
            for j, k in ipairs(gt) do
                t[#t + 1] = k
            end
        else
            t[#t + 1] = v
        end
    end

    return t
end

function RNGroup:getAllChildren()
    --returns all children , sub-groups included
    local t = {}
    for i, v in ipairs(self.displayObjects) do
        if v:getType() == "RNGroup" then
            local gt = v:getAllChildren()
            for j, k in ipairs(gt) do
                t[#t + 1] = k
            end
        end
        t[#t + 1] = v
    end

    return t
end

function RNGroup:flattern(value)
    for i, v in ipairs(self:getAllChildren()) do
        v:setLevel(value + i)
    end
end

function RNGroup:setPriority(value)
    self:flattern(value)
end

function RNGroup:innerNew(o)
    o = o or {
        name = "",
        visible = true,
    }

    o.parentGroup = nil
    setmetatable(o, self)
    self.__index = self
    if RNFactory.mainGroup ~= nil then
        RNFactory.mainGroup:insert(o)
    end
    o.prop = MOAIProp2D.new()
    return o
end


function RNGroup:setScreen(screen)
    self.screen = screen
end


function RNGroup:insert(object, resetTransform)
    if object:getType() == "RNTableElement" then
        for i, v in ipairs(object.elements) do
            self:insert(v.rnText)
        end
    else

        if resetTransform == true then
            object.x = self.x
            object.y = self.y
        end

        if object.parentGroup ~= nil and object:getType() ~= "RNMap" then
            object.parentGroup:removeChild(object.idInGroup)
        end

        object:setParentGroup(self)


        local level = self:getHighestLevel() + 1


        object:setLevel(level)


        self.levels[level] = level

        self.numChildren = self.numChildren + 1
        self.displayObjects[self.numChildren] = object
        object:setIDInGroup(self.numChildren)
    end

    if object.setScissorRect and self.scissorRect ~= nil then object:setScissorRect(self.scissorRect) end
end

function RNGroup:removeChild(id)
    local len = table.getn(self.displayObjects)
    local ind = id
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
    self.numChildren = table.getn(self.displayObjects)
end

function RNGroup:inserLevel(level)
    self.levels[level] = level
end

function RNGroup:getLowestLevel()
    local t = -1
    for i, v in pairs(self.levels) do
        if t > v then
            t = v
        end
    end
    return t
end

function RNGroup:getHighestLevel()
    local t = -1
    for i, v in pairs(self.levels) do
        if t < v then
            t = v
        end
    end
    return t
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

function RNGroup:getChild(value)
    local o
    if type(value) == "string" then
        for i, v in ipairs(self:getAllChildren()) do
            if v.name == value then
                o = v
            end
        end
    else
        o = self.displayObjects[value]
    end
    return o
end

function RNGroup:getSize()
    return self.numChildren
end

function RNGroup:setFocus(value)
end

function RNGroup:remove()
    for i = 1, #self.displayObjects do
        self.displayObjects[1]:remove()
    end
    if (self.parentGroup) then
        self.parentGroup:removeChild(self.idInGroup)
    end
    self.prop = nil
    self = nil
    --    collectgarbage()
end


function RNGroup:removeSelf()
end

function RNGroup:addEventListener(event, button)
end


function RNGroup:setVisible(value)
    for i = 0, self.numChildren - 1 do
        local anObject = self.displayObjects[i]
        if anObject ~= nil then
            if anObject.getType ~= nil then
                if anObject:getType() ~= "RNButton" then
                    if anObject ~= nil and type(anObject.getProp) ~= "table" and anObject:getProp() ~= nil then
                        anObject.visible = value
                    end
                else
                    anObject.visible = value
                end
            end
        end
    end
end

function RNGroup:setScissorRect(scissorRect)
    self.scissorRect = scissorRect or nil
    if self.displayObjects == nil then return end

    for i = 1, #self.displayObjects do
        if self.displayObjects[i].setScissorRect then self.displayObjects[i]:setScissorRect(self.scissorRect) end
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

function RNGroup:setLevel(value)
    if self.prop ~= nil then
        self:setPriority(value)
    end
end

function RNGroup:setParentGroup(group)
    self.parentGroup = group
end

function RNGroup:getProp()
    return self.prop
end

function RNGroup:setIDInGroup(id)
    self.idInGroup = id
end

function RNGroup:getType()
    return "RNGroup"
end

return RNGroup