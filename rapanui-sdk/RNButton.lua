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
        rnImageDefault = nil,
        rnImageOver = nil
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


function RNButton:initWith(imageDefault, imageOver, rntext)
    self.text = rntext
    self.rnImageDefault = imageDefault

    self.pippo = "boh"

    if imageOver ~= nil then
        self.rnImageOver = imageOver
    end

end


function RNButton:getType()
    return "RNButton"
end

function RNButton:getLoc()
    return self.rnImageDefault:getProp():getLoc()
end

function RNButton:getRNtext()
    return self.text
end

function RNButton:getAllProps()
    local props = self:getAllRNObjectProps()
    table.insert(props, self.text:getProp())
    return props
end

function RNButton:getAllRNObjectProps()
    local props = {}
    --table.insert(props, self.text:getProp())
    table.insert(props, self.rnImageDefault:getProp())

    if self.rnImageOver ~= nil then
        table.insert(props, self.rnImageOver:getProp())
    end

    return props
end

function RNButton:setOnTouchDown(func)
    self.onTouchDownFunc = func

    local function defaultOnTouchDownButton(event)

        if self.rnImageOver ~= nil then
            self.rnImageDefault:setVisible(false)
            self.rnImageOver:setVisible(true)
        end
        self.onTouchDownFunc(event)
    end

    self.rnImageDefault:setOnTouchDown(defaultOnTouchDownButton)
end


function RNButton:setOnTouchUp(func)
    self.rnImageDefault:setOnTouchUp(func)
    self.onTouchUpFunc = func

    local function defaultOnTouchUp(event)

        if self.rnImageOver ~= nil then
            self.rnImageOver:setVisible(false)
            self.rnImageDefault:setVisible(true)
        end
        self.onTouchUpFunc(event)
    end

    self.rnImageDefault:setOnTouchUp(defaultOnTouchUp)
end


function RNButton:remove(func)
    local tmpText = self.text
    local tmpRnobject = self.rnImageDefault
    self.text = nil
    self.rnImageDefault = nil

    if self.rnImageOver ~= nil then
        local tmpRnImageOver = self.rnImageOver
        self.rnImageOver = nil
        tmpRnImageOver:remove()
    end

    tmpText:remove()
    tmpRnobject:remove()
end


return RNButton