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


-- Create a new class that inherits from a base class RNObject
RNButton = {}

local function fieldChangedListenerRNButton(self, key, value)

    getmetatable(self).__object[key] = value
    self = getmetatable(self).__object


    if key ~= nil and key == "x" then
        local tmpX = value
        local tmpY = self.y

        if (self:getProp() ~= nil) then
            self:getProp():setLoc(tmpX, tmpY);
        end
    end

    if key ~= nil and key == "y" then
        local tmpX = self.x
        local tmpY = value

        if (self:getProp() ~= nil) then
            self:getProp():setLoc(tmpX, tmpY);
        end
    end

    if key == "isFocus" and value == true then
        -- TODO: implement focus handling
    end

    if key == "text" and value ~= nil then
        if self.textbox ~= nil then
            self:setText(value)
        end
    end
end


local function fieldAccessListener(self, key)

    local object = getmetatable(self).__object

    if key ~= nil and key == "rnobject" then
        print("rnobject")
    end

    --[[
if key ~= nil and key == "x" then
  local xx, yy
  xx, yy = object:getProp():getLoc()
  object.x = xx
end


if key ~= nil and key == "x" then
  local xx, yy
  xx, yy = object:getProp():getLoc()
  object.y = yy
end
    ]] --
    return getmetatable(self).__object[key]
end

function RNButton:innerNew(o)
    o = o or {
        name = "",
        rntext = nil,
        rnobject = nil
    }

    setmetatable(o, self)
    self.__index = self
    return o
end


-- Create a new proxy for RNButton Object
function RNButton:new(o)
    local RNButton = RNButton:innerNew(nil)
    local proxy = setmetatable({}, { __newindex = fieldChangedListenerRNButton, __index = fieldAccessListener, __object = RNButton })
    return proxy
end


function RNButton:initWith(rnobject, rntext)
    self.text = rntext
    self.rnobject = rnobject
end


function RNButton:setOnTouchDown(func)
    self.rnobject:setOnTouchDown(func)
end


function RNButton:setOnTouchUp(func)
    self.rnobject:setOnTouchUp(func)
end


function RNButton:remove(func)
    local tmpText = self.text
    local tmpRnobject = self.rnobject
    self.text = nil
    self.rnobject = nil

    tmpText:remove()
    tmpRnobject:remove()
end


return RNButton