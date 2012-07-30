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

RNListView = {}


--since RapaNui touch listener doesn't return the target as the enterFrame does,
--we need to specify SELF here, and due to this fact
--only one RNList at once can be created  TODO: fix this.
-- I think we should change approach for this kind of classes. [like RNPageSwipe, too]

local SELF




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
    if key ~= nil and key == "visible" then
        self:setVisibility(value)
    end
end


local function fieldAccessListener(self, key)

    local object = getmetatable(self).__object

    return getmetatable(self).__object[key]
end



function RNListView:new(o)
    local tab = RNListView:innerNew(o)
    local proxy = setmetatable({}, { __newindex = fieldChangedListener, __index = fieldAccessListener, __object = tab })
    return proxy, tab
end


function RNListView:innerNew(o)

    o = o or {
        name = "",
        options = { timestep = 1 / 60, cellH = 50, cellW = 50, maxScrollingForceY = 30, minY = 0, maxY = 100, touchW = 320, touchH = 480, touchStartX = 0, touchStartY = 0 },
        elements = {},
        x = 0,
        y = 0,
        --
        timerListener = nil,
        touchListener = nil,
        --
        isTouching = false,
        tmpY = 0,
        deltay = 0,
        canScrollY = true,
        isScrollingY = false,
        --
        isChooseDone = false,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function RNListView:init()
    SELF = self
    --set default values if nil
    if self.options.cellH == nil then self.options.cellH = 50 end
    if self.options.cellW == nil then self.options.cellW = 50 end
    if self.options.maxScrollingForceY == nil then self.options.maxScrollingForceY = 30 end
    if self.options.minY == nil then self.options.minY = 0 end
    if self.options.maxY == nil then self.options.maxY = 100 end
    if self.options.touchW == nil then self.options.touchW = 320 end
    if self.options.touchH == nil then self.options.touchH = 480 end
    if self.options.touchStartX == nil then self.options.touchStartX = 0 end
    if self.options.touchStartY == nil then self.options.touchStartY = 0 end
    if self.options.timestep == nil then self.options.timestep = 1 / 60 end

    --organize items
    for i = 1, table.getn(self.elements), 1 do
        self.elements[i].object.x = self.x + self.elements[i].offsetX
        self.elements[i].object.y = self.y + i * self.options.cellH + self.elements[i].offsetY - self.options.cellH
    end
    --set listeners
    self.touchListener = RNListeners:addEventListener("touch", self.touchEvent)
    self.timerListener = nil
    self.createTimer()

    self.isToScroll = false
    self.postogo = 0

    self.registeredFunctions = {}
end


function RNListView.step()
    if SELF ~= nil then
        if #SELF.elements > 0 then
            if SELF.canScrollY == true then
                if SELF.deltay > 0 then SELF.deltay = SELF.deltay - 0.2 end
                if SELF.deltay < 0 then SELF.deltay = SELF.deltay + 0.2 end

                if SELF.deltay > SELF.options.maxScrollingForceY then SELF.deltay = SELF.options.maxScrollingForceY end
                if SELF.deltay < -SELF.options.maxScrollingForceY then SELF.deltay = -SELF.options.maxScrollingForceY end

                if SELF.deltay > 0 and SELF.deltay <= 0.2 then
                    SELF.deltay = 0
                end
                if SELF.deltay < 0 and SELF.deltay >= -0.2 then
                    SELF.deltay = 0
                end

                if SELF.deltay > 0 and SELF.y < SELF.options.maxY + 100 then
                    SELF.y = SELF.y + SELF.deltay
                end
                if SELF.deltay <= 0 and SELF.y > SELF.options.minY - 100 then
                    SELF.y = SELF.y + SELF.deltay
                end

                if SELF.deltay > 1 or SELF.deltay < -1 then
                    SELF.isScrollingY = true
                end

                if SELF.y > SELF.options.maxY and SELF.isTouching == false then
                    SELF.deltay = 0
                    local value = (SELF.y - SELF.options.maxY) / 20
                    SELF.y = SELF.y - value
                    if value < 0.001 then
                        SELF.removeTimer()
                    end
                end
                if SELF.y < SELF.options.minY and SELF.isTouching == false then
                    SELF.deltay = 0
                    local value = (SELF.options.minY - SELF.y) / 20
                    SELF.y = SELF.y + value
                    if value < 0.001 then
                        SELF.removeTimer()
                    end
                end

                --scroll due to postogo
                if SELF.isToScroll == true then
                    if SELF.y > SELF.postogo then SELF.y = SELF.y - 1 end
                    if SELF.y <= SELF.postogo then SELF.y = SELF.y + 1 end
                    if math.abs(SELF.y - SELF.postogo) < 2 then
                        SELF.y = SELF.postogo
                        SELF.isToScroll = false
                        SELF.removeTimer()
                    end
                end
                SELF:callRegisteredFunctions("step")
            end
        end
    end
end

function RNListView.createTimer()
    if SELF.timerListener == nil then
        SELF.timerListener = RNMainThread.addTimedAction(SELF.options.timestep, SELF.step)
    end
end

function RNListView.removeTimer()
    if SELF.timerListener ~= nil then
        RNMainThread.removeAction(SELF.timerListener)
        SELF.timerListener = nil
    end
end

function RNListView:callRegisteredFunctions(phase)
    for i = 1, #SELF.registeredFunctions do
        SELF.registeredFunctions[i](phase)
    end
end

function RNListView:registerFunction(funct)
    self.registeredFunctions[#self.registeredFunctions + 1] = funct
end

function RNListView.touchEvent(event)
    local self = SELF
    if self.canScrollY == true then
        if event.x > self.options.touchStartX and event.x < self.options.touchStartX + self.options.touchW and
                event.y > self.options.touchStartY and event.y < self.options.touchStartY + self.options.touchH then
            if event.phase == "began" and self ~= nil then
                self.tmpY = event.y
                self.isTouching = true
                SELF:callRegisteredFunctions("beganTouch")
                SELF.beganDelta = event.y - self.y
                SELF.removeTimer()
            end


            if event.phase == "moved" and self ~= nil then
                self.deltay = event.y - self.tmpY
                if self.canScrollY == true then
                    self.tmpY = event.y
                    SELF:callRegisteredFunctions("movedTouch")
                    if SELF.deltay > 0 and SELF.y < SELF.options.maxY + 100 or SELF.deltay <= 0 and SELF.y > SELF.options.minY - 100 then
                        self.y = event.y - self.beganDelta
                    end
                end
            end

            if event.phase == "ended" and self ~= nil and self.isScrollingY == false and self.isChooseDone == false then
                for i = 1, table.getn(self.elements), 1 do
                    if event.x > self.x and event.x < self.x + self.options.cellW and event.y > self.y + i * self.options.cellH - self.options.cellH and event.y < self.y + i * self.options.cellH + self.options.cellH - self.options.cellH then
                        if self.elements[i].onClick ~= nil then
                            local funct = self.elements[i].onClick
                            funct({ target = self.elements[i] })
                        end
                    end
                end
                self.isTouching = false
                SELF:callRegisteredFunctions("endedTouch")
                SELF.createTimer()
            end
        end
    end
    if event.phase == "ended" and self.isScrollingY == true then
        self.isScrollingY = false
        self.isTouching = false
        SELF:callRegisteredFunctions("cancelledTouch")
        SELF.createTimer()
    end
end


function RNListView:setX(value)
    for i, v in ipairs(self.elements) do
        if v.object ~= nil then
            v.object.x = self.x + self.elements[i].offsetX
        end
    end
    self.options.x = value
end

function RNListView:setY(value)
    for i, v in ipairs(self.elements) do
        if v.object ~= nil then
            v.object.y = self.y + i * self.options.cellH + self.elements[i].offsetY - self.options.cellH
        end
    end
    self.options.y = value
end

function RNListView:remove()
    self:removeTimer()
    RNListeners:removeEventListener("touch", self.touchListener)
    for i, v in ipairs(self.elements) do
        if v.object ~= nil then
            v.object:remove()
        end
    end

    self = nil
    SELF = nil
end



-- elements actions

function RNListView:getElement(value)
    return self.elements[value]
end

function RNListView:getSize()
    return table.getn(self.elements)
end

function RNListView:insertElement(element, number)
    if number ~= nil then
        --the element is add to the end of the list if param number is > of the list size
        if number > self:getSize() then
            self.elements[self:getSize() + 1] = element
        end
        --else the element is inserted in the place [number] and the below elements moved
        if number <= self:getSize() then
            for i = self:getSize(), number, -1 do
                self.elements[i + 1] = self.elements[i]
            end
            self.elements[number] = element
        end
    else
        --the element is add to the end of the list if param number is nil
        self.elements[self:getSize() + 1] = element
    end
end

function RNListView:removeElement(removeRNObject, number)
    if number ~= nil then
        if number > self:getSize() then
            if removeRNObject == true then
                self.elements[self:getSize()].object:remove()
            end
            self.elements[self:getSize()] = nil
        end
        if number <= self:getSize() then
            if removeRNObject == true then
                self.elements[number].object:remove()
            end
            for i = number, self:getSize() - 1, 1 do
                self.elements[i] = self.elements[i + 1]
            end
            self.elements[self:getSize()] = nil
        end
    else
        if removeRNObject == true then
            self.elements[self:getSize()].object:remove()
        end
        self.elements[self:getSize()] = nil
    end
end


function RNListView:swapElements(n1, n2)
    local tempn1 = self.elements[n1]
    local tempn2 = self.elements[n2]

    self.elements[n1] = tempn2
    self.elements[n2] = tempn1
end


function RNListView:getObjectByNumber(value)
    local o
    for i = 1, self:getSize() do
        if i == value then
            o = self.elements[i]
        end
    end

    return o
end


function RNListView:getNumberByObject(value)
    local n
    for i = 1, self:getSize() do
        if self.elements[i].object == value then
            n = i
        end
    end

    return n
end

--

function RNListView:getType()
    return "RNListView"
end


function RNListView:setAlpha(value)
    for i, v in ipairs(self.elements) do
        v.object:setAlpha(value)
    end
end

function RNListView:setVisibility(value)
    for i, v in ipairs(self.elements) do
        v.object.visible = value
    end
end

function RNListView:goToElement(value)
    self.isToScroll = true
    self.postogo = -value * self.options.cellH + self.options.touchStartY + self.options.cellH
    self.createTimer()
end

function RNListView:jumpToElement(value)
    SELF.y = -value * SELF.options.cellH + SELF.options.touchStartY + SELF.options.cellH
    SELF.removeTimer()
end


function RNListView:getTotalHeight()
    return self.options.cellH * (#self.elements)
end

--mocks for groupAdd (Yes, RNListViews can be added to RNGroups ^^)


function RNListView:setIDInGroup()
    --mocked for group adding see RNGroup
end

function RNListView:setLevel()
    --mocked for group adding see RNGroup
end

function RNListView:setParentGroup()
    --mocked for group adding see RNGroup
end



return RNListView
