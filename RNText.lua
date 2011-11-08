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
require("RNObject")

-- Create a new class that inherits from a base class RNObject
RNText = RNObject:innerNew()

local function fieldChangedListenerRNText(self, key, value)

    getmetatable(self).__index[key] = value

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


function RNText:innerNew(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- Create a new proxy for RNText Object
function RNText:new(o)
    local RNText = RNText:innerNew()
    local proxy = setmetatable({}, { __newindex = fieldChangedListenerRNText, __index = RNText })
    return proxy
end


function RNText:initWithText(text, font, size, x, y, width, height, alignment)
    self.charcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-'

    if font ~= nil then
        self.fontName = font
    end

    self.font = MOAIFont.new()
    self.font:loadFromTTF(self.fontName .. ".TTF", self.charcodes, size, 163)

    self.locatingMode = CENTERED_MODE
    self.text = text

    self.name = text
    self.visible = true

    self.textbox = MOAITextBox.new()
    self.prop = self.textbox

    self.text = text


    self.textbox:setString(self.text)
    self.textbox:setFont(self.font)
    self.textbox:setTextSize(self.font:getScale())
    self.textbox:setRect(x, y, x + width, y + height)
    self.textbox:setAlignment(alignment)

    self:setTextColor(1, 1, 1)
end


function RNText:setSize(width, height)
    self.textbox:setRect(self.x, self.y, self.x + width, self.y + height)
end

function RNText:setTextSize(size)
    self.font:loadFromTTF(self.fontName .. ".TTF", self.charcodes, size, 163)
    self.textbox:setString(self.text)
    self.textbox:setFont(self.font)
    self.textbox:setTextSize(self.font:getScale())
end


function RNText:setText(text)
    self.textbox:setString(text)
end


function RNText:setTextColor(r, g, b)
    self.r = r
    self.g = g
    self.g = b

    self.textbox:setColor(r, g, b)
end

function RNText:setAlpha(value)
    self.alpha = value
    self.prop:setColor(self.r, self.g, self.g, value, 0)
end