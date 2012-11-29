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
require("rapanui-sdk/RNObject")

-- Create a new class that inherits from a base class RNObject
RNText = RNObject:innerNew()

local function fieldChangedListenerRNText(self, key, value)

    getmetatable(self).__object[key] = value

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

    if key ~= nil and key == "x" then
        local xx, yy
        xx, yy = object:getProp():getLoc()
        object.x = xx
    end

    if key ~= nil and key == "y" then
        local xx, yy
        xx, yy = object:getProp():getLoc()
        object.y = yy
    end

    return getmetatable(self).__object[key]
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
    local proxy = setmetatable({}, { __newindex = fieldChangedListenerRNText, __index = fieldAccessListener, __object = RNText })
    return proxy
end



function RNText:initWithText2(text, font, size, width, height, hAlignment, vAlignment)
    self.fontName = font


    if type(font) == "string" then
        if RNGraphicsManager:getAlreadyAllocated(font) then
            font = RNGraphicsManager:getFontByPath(font)
        else
            font = RNGraphicsManager:allocateFont(font)
        end
    end

    if vAlignment == nil then
        vAlignment = hAlignment
    end

    self.font = font
    self.text = text
    self.locatingMode = CENTERED_MODE
    self.name = text
    self.visible = true

    self.textbox = MOAITextBox.new()

    self.style = self:setStyle(font, size, 1, { 255, 255, 255, 255 })
    self.r = 255
    self.g = 255
    self.b = 255
    self.textbox:setStyle(self.style)
    self.textbox:setString(self.text)
    self.textbox:setRect(0, 0, width, height)
    self.textbox:setAlignment(hAlignment, vAlignment)
    self.prop = self.textbox
    self.size = size

    self.textbox:setGlyphScale(0.75)

    self.stylesList = {}

    return self, self.font
end

function RNText:setStyle(font, size, scale, color)
    local style = MOAITextStyle.new()
    style:setFont(font)
    style:setSize(size)
    style:setScale(scale or 1)
    style:setColor(color[1] / 255, color[2] / 255, color[3] / 255, color[4] / 255)
    return style;
end

function RNText:addStyle(name, font, size, color)
    local style = MOAITextStyle.new()
    self.stylesList[#self.stylesList + 1] = style

    if type(font) == "string" then
        if RNGraphicsManager:getAlreadyAllocated(font) then
            font = RNGraphicsManager:getFontByPath(font)
        else
            font = RNGraphicsManager:allocateFont(font)
        end
    end

    if color == nil then
        color = { 255, 255, 255, 255 }
    end

    style:setFont(font)
    style:setSize(size)
    style:setColor(color[1] / 255, color[2] / 255, color[3] / 255, color[4] / 255)

    self.textbox:setStyle(name, style)

    return style;
end

function RNText:setTextSize(value)
    self.style:setSize(value)
end

function RNText:setSize(width, height)
    self.textbox:setRect(self.x, self.y, self.x + width, self.y + height)
end

function RNText:setText(text)
    self.textbox:setString(text)
    if self.text ~= text then
        self.text = text
    end
end

function RNText:spool()
    self.textbox:spool()
end

function RNText:highlight(index, size, r, g, b, a)
    self.textbox:setHighlight(index, size, r / 255, g / 255, b / 255, a)
end

function RNText:setVisible(value)
    --NOTE: this is a workaround becouse MOAI's setVisible has a bug.

    if value then
        self:setAlpha(1)
    else
        self:setAlpha(0)
    end
end

function RNText:setScissorRect(scissorRect)
    self:getProp():setScissorRect(scissorRect)
end

function RNText:getText()
    return self.text
end

function RNText:getType()
    return "RNText"
end


function RNText:setTextColor(r, g, b)

    self.r = r
    self.g = g
    self.b = b

    self.textbox:getStyle():setColor(r / 255, g / 255, b / 255)
end

function RNText:setAlpha(value)
    self.alpha = value
    self.prop:setColor(self.r / 255, self.g / 255, self.b / 255, value, 0)
end

return RNText