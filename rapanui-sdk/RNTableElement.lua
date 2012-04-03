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
local isTOUCHING
local CHOOSEDONE = false

local WHITE = { 255, 255, 255 }
local BLUE = { 0, 0, 255 }
local BLACK = { 0, 0, 0 }



local function fieldChangedListener(self, key, value)

    getmetatable(self).__object[key] = value
    self = getmetatable(self).__object

    if key ~= nil and key == "x" then
        self:setX(value)
    end

    if key ~= nil and key == "y" then
        self:setY(value)
    end

    if key ~= nil and key == "alpha" then
        self:setAlpha(value)
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
        rectangles = {},
        lines = {},
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
    --set self
    SELF = self
    --set style if nil
    if self.style == nil then
        self.style = { size = 10, font = nil, top = 30, left = 0, width = 500, height = 30, alignment = MOAITextBox.LEFT_JUSTIFY }
    end
    --create texts and rectangles and lines
    for i, v in ipairs(self.elements) do
        local xoffs,yoffs=self.elements[i].XOffset,self.elements[i].YOffset
        if xoffs==nil then xoffs=0 end
        if yoffs==nil then yoffs=0 end
        local color=self.elements[i].color
        if color==nil then color={255,255,255} end
        --texts
        v.rnText = RNFactory.createText(v.text, { size = self.style.size, font = self.style.font, top = -self.style.top + self.style.top * i +yoffs, left = self.style.left+xoffs, width = self.style.width, height = self.style.height, alignment = MOAITextBox.LEFT_JUSTIFY })
        v.rnText.x = self.x
        v.rnText.y = self.y
        v.rnText:setTextColor(color[1],color[2],color[3])
        --rectangles
        self.rectangles[i] = RNFactory.createRect(self.style.left, -self.style.top + self.style.top * i, self.style.width, self.style.height, { rgb = BLUE })
        self.rectangles[i].y = -self.style.top + self.style.top * i - self.style.height / 2
        --lines
        self.lines[i] = RNFactory.createRect(self.style.left, -self.style.top + self.style.top * i, self.style.width, 5, { rgb = BLACK })
        self.lines[i].y = -self.style.top + self.style.top * i - self.style.height
    end
    --last line
    local place = table.getn(self.lines) + 1
    self.lines[place] = RNFactory.createRect(self.style.left, -self.style.top + self.style.top * place, self.style.width, 5, { rgb = BLACK })
    self.lines[place].y = -self.style.top + self.style.top * place - self.style.height
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

        if deltay > 0 and SELF.y < SELF.maxY + 100 then
            SELF.y = SELF.y + deltay
        end
        if deltay <= 0 and SELF.y > SELF.minY - 100 then
            SELF.y = SELF.y + deltay
        end

        if deltay > 1 or deltay < -1 then
            isSCROLLINGY = true
        end

        if SELF.y > SELF.maxY and isTOUCHING == false then
            deltay = 0
            SELF.y = SELF.y - (SELF.maxY + SELF.y) / 20
        end
        if SELF.y < SELF.minY and isTOUCHING == false then
            deltay = 0
            SELF.y = SELF.y + (SELF.minY - SELF.y) / 20
        end
    end
end

function RNTableElement.touchEvent(event)
    local self = SELF
    if event.phase == "began" and self ~= nil then
        tmpY = event.y
        isTOUCHING = true
    end


    if event.phase == "moved" and self ~= nil then
        deltay = event.y - tmpY
        if self.canScrollY == true then
            tmpY = event.y
        end
    end

    if event.phase == "ended" and isSCROLLINGY == false and self ~= nil and CHOOSEDONE == false then
        for i = 1, table.getn(self.elements), 1 do
            if event.y > -self.style.top + i * self.style.top + self.y and event.y < i * self.style.top + self.y then
                if self.elements[i].onClick ~= nil then
                    local funct = self.elements[i].onClick
                    local event = { text = self.elements[i].text, target = self.elements[i].name }
                    local cColor = WHITE
                    self.rectangles[i]:setPenColor(cColor[1], cColor[2], cColor[3])
                    CHOOSEDONE = true
                    funct(event)
                end
            end
        end
        isTOUCHING = false
    end

    if event.phase == "ended" and isSCROLLINGY == true then
        isSCROLLINGY = false
        isTOUCHING = false
    end
end

function RNTableElement:setX(value)
    for i, v in ipairs(self.elements) do
        if v.rnText ~= nil then
            v.rnText.x = value
        end
    end
    for i, v in ipairs(self.rectangles) do
        if v ~= nil then
            v.x = v.x + value
        end
    end
    for i, v in ipairs(self.lines) do
        if v ~= nil then
            v.x = v.x + value
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
    for i, v in ipairs(self.rectangles) do
        if v ~= nil then
            v.y = value + self.style.top * i - self.style.height / 2
        end
    end
    for i, v in ipairs(self.lines) do
        if v ~= nil then
            v.y = value + self.style.top * i - self.style.height
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
    --[[ bug in removing shapes
    for i, v in ipairs(self.rectangles) do
        if v ~= nil then
            v:remove()
        end
    end
    ]] --
    --[[ bug in removing shapes
    for i, v in ipairs(self.lines) do
        if v ~= nil then
            v:remove()
        end
    end
    ]] --

    self = nil
    SELF = nil
end




function RNTableElement:getType()
    return "RNTableElement"
end


function RNTableElement:setAlpha(value)
    for i, v in ipairs(self.elements) do
        v.rnText.alpha = value
    end
    --bug in alpha shapes
    for i, v in ipairs(self.rectangles) do
        v.alpha = value
    end
end

function RNTableElement:setVisibility(value)
    for i, v in ipairs(self.elements) do
        v.rnText.visible = value
    end
    for i, v in ipairs(self.rectangles) do
        v.visible = value
    end
end

--mocks for groupAdd


function RNTableElement:setIDInGroup()
    --mocked for group adding see RNGroup
end

function RNTableElement:setLevel()
    --mocked for group adding see RNGroup
end



