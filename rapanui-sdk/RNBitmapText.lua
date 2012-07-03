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
RNBitmapText = RNGroup:innerNew()

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


function RNBitmapText:innerNew(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- Create a new proxy for RNBitmapText Object
function RNBitmapText:new(o)
    local RNBitmapText = RNBitmapText:innerNew()
    local proxy = setmetatable({}, { __newindex = fieldChangedListener, __index = fieldAccessListener, __object = RNBitmapText })
    return proxy
end


--- Returns the String as a table in which each cahr is the key of the table eg:
--- "ABC"
--- { ["A"] = 1, ["B"] = 2, ["c"] = 3}
function RNBitmapText:stringToTableKeys(text)
    local charsetList = {}
    local p = string.sub(text, 1, 1)
    local size = 0
    for k = 1, string.len(text) do
        local chunk = string.sub(text, k, k)
        charsetList[chunk] = k
        print("stringToTableKeys decode chunk --> " .. chunk .. " at " .. k)
        size = size + 1
    end
    return charsetList, size
end

--- Returns the String as a table eg:
--- "ABC"
--- { [1] = "A", [2] = "B", [3] = "C"}
function RNBitmapText:stringToTable(text)
    local charsetList = {}
    local p = string.sub(text, 1, 1)
    local size = 0
    for k = 1, string.len(text) do
        local chunk = string.sub(text, k, k)
        charsetList[k] = chunk

        size = size + 1
    end
    return charsetList, size
end


function RNBitmapText:initWith(text, image, charcodes, charWidth, charHeight, top, left, hAlignment, vAlignment)
    self.charcodes = charcodes

    --todo: refactor RNGRoup to avoid this reasignment
    self.displayObjects = {}
    self.numChildren = 0
    self.y = 0
    self.lasty = 0
    self.x = 0
    self.lastx = 0
    self.levels = {}
    self.levels[1] = 1
    -- end reassignment to make RNGroup work

    self.charsConversionTable, self.conversionSize = self:stringToTableKeys(charcodes)

    print_r(self.charsConversionTable)


    local textAsList, textLenght = self:stringToTable(text)

    print_r(textAsList)


    local currentx = left

    for i = 1, textLenght do
        local charFrame = self.charsConversionTable[textAsList[i]]
        print("frame", charFrame, i)

        local aChar = RNFactory.createAnim(image, charWidth, charHeight)

        aChar.frame = charFrame
        aChar.y = top
        aChar.x = currentx

        self:insert(aChar)
        currentx = currentx + 16
    end

    if vAlignment == nil then
        vAlignment = hAlignment
    end

    self.text = text

    self.name = text
    self.visible = true

    return self
end


function RNBitmapText:setSize(width, height)
end

function RNBitmapText:setText(text)
    self.textbox:setString(text)
end

function RNBitmapText:getText()
    return self.text
end

function RNBitmapText:getType()
    return "RNBitmapText"
end


function RNBitmapText:setTextColor(r, g, b)
end

function RNBitmapText:setAlpha(value)
end

return RNBitmapText