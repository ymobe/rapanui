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

RNTableElement = {}
local SELF
local isSCROLLINGY = false
local tmpY = 0
local deltay = 0
local ENTERFRAMELISTENER
local TOUCHLISTENER

local function fieldChangedListener(self, key, value)

    getmetatable(self).__object[key] = value
    self = getmetatable(self).__object

    if key ~= nil and key == "x" then
        self:setX(value)
    end

    if key ~= nil and key == "y" then
        self:setY(value)
    end
end


local function fieldAccessListener(self, key)

    local object = getmetatable(self).__object

    return getmetatable(self).__object[key]
end



function RNTableElement:new(o)
    local tab = RNTableElement:innerNew(o)
    local proxy = setmetatable({}, { __newindex = fieldChangedListener, __index = fieldAccessListener, __object = tab })
    return proxy, tab
end


function RNTableElement:innerNew(o)

    o = o or {
        name = "",
        style = { size = 10, font = nil, top = 30, left = -50, width = 200, height = 50 },
        elements = {},
        x = 0,
        y = 0,
        canScrollY = false,
        minY = 0,
        maxY = 320,
        maxScrollingForceY = 100,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function RNTableElement:init()
    --set style if nil
    if self.style == nil then
        self.style = { size = 10, font = nil, top = 30, left = 0, width = 500, height = 500, alignment = MOAITextBox.LEFT_JUSTIFY }
    end
    --create texts
    for i, v in ipairs(self.elements) do
        v.rnText = RNFactory.createText(v.text, { size = self.style.size, font = self.style.font, top = -self.style.top + self.style.top * i, left = self.style.left, width = self.style.width, height = self.style.height, alignment = MOAITextBox.LEFT_JUSTIFY })
        v.rnText.x = self.x
        v.rnText.y = self.y
    end
    SELF = self
    --add touch listener
    ENTERFRAMELISTENER = RNListeners:addEventListener("touch", self.touchEvent)
    --step listener
    TOUCHLISTENER = RNListeners:addEventListener("enterFrame", self)
end

function RNTableElement:enterFrame()
    if SELF ~= nil then
        if deltay > 0 then deltay = deltay - 0.2 end
        if deltay < 0 then deltay = deltay + 0.2 end

        if deltay > SELF.maxScrollingForceY then deltay = SELF.maxScrollingForceY end
        if deltay < -SELF.maxScrollingForceY then deltay = -SELF.maxScrollingForceY end

        if deltay > 0 and deltay <= 0.2 then deltay = 0 end
        if deltay < 0 and deltay >= -0.2 then deltay = 0 end

        if deltay > 0 and SELF.y < SELF.maxY then
            SELF.y = SELF.y + deltay
        end
        if deltay <= 0 and SELF.y > SELF.minY then
            SELF.y = SELF.y + deltay
        end
    end
end

function RNTableElement.touchEvent(event)
    local self = SELF
    if event.phase == "began" and self ~= nil then
        tmpY = event.y
        isSCROLLINGY = false
    end


    if event.phase == "moved" and self ~= nil then
        isSCROLLINGY = true
        deltay = event.y - tmpY
        if self.canScrollY == true then
            tmpY = event.y
        end
    end

    if event.phase == "ended" and isSCROLLINGY == false and self ~= nil then
        for i = 1, table.getn(self.elements), 1 do
            if event.y > -self.style.top + i * self.style.top + self.y and event.y < i * self.style.top + self.y then
                if self.elements[i].onClick ~= nil then
                    local funct = self.elements[i].onClick
                    local event = { text = self.elements[i].text, target = self.elements[i].name }
                    funct(event)
                end
            end
        end
    end
end

function RNTableElement:setX(value)
    for i, v in ipairs(self.elements) do
        if v.rnText ~= nil then
            v.rnText.x = value
        end
    end
    self.x = value
end

function RNTableElement:setY(value)
    for i, v in ipairs(self.elements) do
        if v.rnText ~= nil then
            v.rnText.y = value
        end
    end
    self.y = value
end

function RNTableElement:remove()
    RNListeners:removeEventListener("enterFrame", ENTERFRAMELISTENER)
    --RNListeners:removeEventListener("touch", TOUCHLISTENER)
    for i, v in ipairs(self.elements) do
        if v.rnText ~= nil then
            v.rnText:remove()
        end
    end
    self = nil
    SELF = nil
end




function RNTableElement:getType()
    return "RNTableElement"
end


function RNTableElement:setAlpha(value)
    for i,v in ipairs(self.elements)do
        self.elements[i].alpha=value
    end
end

--mocks for groupAdd


function RNTableElement:setIDInGroup()
    --mocked for group adding see RNGroup
end

function RNTableElement:setLevel()
    --mocked for group adding see RNGroup
end



