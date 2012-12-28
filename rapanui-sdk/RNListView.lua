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
        options = { checkElements = false, topLimit = -100, bottomLimit = 480 + 100, timestep = 1 / 60, cellH = 50, cellW = 50, maxScrollingForceY = 30, minY = 0, maxY = 100, touchW = 320, touchH = 480, touchStartX = 0, touchStartY = 0, limit = 100 },
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
    self = self
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
    if self.options.limit == nil then self.options.limit = 100 end
    if self.options.topLimit == nil then self.options.topLimit = 100 end
    if self.options.bottomLimit == nil then self.options.bottomLimit = 480 + 100 end
    if self.options.checkElements == nil then self.options.checkElements = false end


    --organize items
    self:organizeItems()

    self.touchEvent = function(event)
        if event.realTouch == nil then
            event.realTouch = true
        end
        local self = self
        if self.canScrollY == true then
            if event.x > self.options.touchStartX and event.x < self.options.touchStartX + self.options.touchW and
                    event.y > self.options.touchStartY and event.y < self.options.touchStartY + self.options.touchH then
                if event.phase == "began" and self ~= nil then
                    self.tmpY = event.y
                    self.isTouching = true
                    self:callRegisteredFunctions("beganTouch")
                    self.beganDelta = event.y - self.y
                    self.olddeltay = 0
                    if self.needScroll == false then
                        self:removeTimer()
                    end
                    self.deltay = 0
                end


                if event.phase == "moved" and self ~= nil then
                    if self.olddeltay == nil then self.olddeltay = 0 end
                    self.deltay = event.y - self.tmpY
                    if self.canScrollY == true then
                        self.tmpY = event.y
                        self:callRegisteredFunctions("movedTouch")
                        self.scrolled = true
                        if (self.deltay > 0 and self.y < self.options.maxY + self.options.limit) then
                            if self.olddeltay > 0 then
                                if self.beganDelta ~= nil then
                                    self.y = event.y - self.beganDelta
                                end
                            else
                                self.beganDelta = event.y - self.y
                            end
                        end
                        if (self.deltay < 0 and self.y > self.options.minY - self.options.limit) then
                            if self.olddeltay < 0 then
                                if self.beganDelta ~= nil then
                                    self.y = event.y - self.beganDelta
                                end
                            else
                                self.beganDelta = event.y - self.y
                            end
                        end
                    end
                    self.olddeltay = self.deltay


                    --

                    if event.y > self.options.touchStartY then
                    end
                end

                if event.phase == "ended" and self ~= nil and self.isScrollingY == false and self.isChooseDone == false then
                    if self ~= nil then
                        self:createTimer()
                    end
                    if event.realTouch == true then
                        for i = 1, table.getn(self.elements), 1 do
                            if event.x > self.x and event.x < self.x + self.options.cellW and event.y > self.y + i * self.options.cellH - self.options.cellH and event.y < self.y + i * self.options.cellH + self.options.cellH - self.options.cellH then
                                if self.elements[i].onClick ~= nil and self.scrolled == false then
                                    local funct = self.elements[i].onClick
                                    funct({ target = self.elements[i] }, event)
                                end
                            end
                        end
                    end
                    if self ~= nil then
                        self:callRegisteredFunctions("endedTouch")
                    end
                    self.isTouching = false
                    self.scrolled = false
                end
            end
        end
        if event.phase == "ended" and self.isScrollingY == true then
            self:createTimer()
            self.isScrollingY = false
            self.isTouching = false
            self:callRegisteredFunctions("cancelledTouch")
            self.scrolled = false
        end
        if event.phase == "moved" then
            if event.y < self.options.touchStartY then
                local _nEv = {}
                _nEv.y = self.options.touchStartY + 10
                _nEv.x = event.x
                _nEv.phase = "ended"
                _nEv.realTouch = false
                self.touchEvent(_nEv)
                self:callRegisteredFunctions("cancelledTouch")
            elseif event.y > self.options.touchStartY + self.options.touchH - 10 then
                local _nEv = {}
                _nEv.y = self.options.touchStartY + self.options.touchH - 10
                _nEv.x = event.x
                _nEv.phase = "ended"
                _nEv.realTouch = false
                self.touchEvent(_nEv)
                self:callRegisteredFunctions("cancelledTouch")
            end
        end
    end


    --set listeners
    self.touchListener = RNListeners:addEventListener("touch", self.touchEvent)
    self.timerListener = nil
    self:createTimer()

    self.isToScroll = false
    self.postogo = 0

    self.registeredFunctions = {}

    self.scrolled = false
    self.needScroll = false
end

function RNListView:organizeItems()
    for i = 1, table.getn(self.elements), 1 do
        self.elements[i].object.x = self.x + self.elements[i].offsetX
        self.elements[i].object.y = self.y + i * self.options.cellH + self.elements[i].offsetY - self.options.cellH
    end
end


function RNListView:createTimer()
    self.step = function()
        if self ~= nil then
            if #self.elements > 0 then
                if self.canScrollY == true then
                    if self.timerListener ~= nil then
                        self:callRegisteredFunctions("step")
                    end


                    --autoscroll at limits / magnetic effect
                    if self.y > self.options.maxY and self.isTouching == false then
                        self.deltay = 0
                        local value = (self.y - self.options.maxY) / 20
                        self.y = self.y - value
                        self.needScroll = true
                        if value < 0.1 then
                            self:removeTimer()
                            self.needScroll = false
                        end
                    end
                    if self.y < self.options.minY and self.isTouching == false then
                        self.deltay = 0
                        local value = (self.options.minY - self.y) / 20
                        self.y = self.y + value
                        self.needScroll = true
                        if value < 0.1 then
                            self:removeTimer()
                            self.needScroll = false
                        end
                    end

                    if self.deltay >= 0 and self.deltay <= 0.2 then
                        self.deltay = 0
                        if self.needScroll == false then
                            self:removeTimer()
                        end
                    end
                    if self.deltay <= 0 and self.deltay >= -0.2 then
                        self.deltay = 0
                        if self.needScroll == false then
                            self:removeTimer()
                        end
                    end

                    if self.deltay > 0 and self.y < self.options.maxY + self.options.limit then
                        self.y = self.y + self.deltay
                    elseif self.deltay < 0 and self.y > self.options.minY - self.options.limit then
                        self.y = self.y + self.deltay
                    else
                        if self.needScroll == false then
                            self:removeTimer()
                        end
                    end

                    if self.deltay > 1 or self.deltay < -1 then
                        self.isScrollingY = true
                    end



                    --scroll due to postogo, move to function
                    if self.isToScroll == true then
                        if self.y > self.postogo then self.y = self.y - 1 end
                        if self.y <= self.postogo then self.y = self.y + 1 end
                        if math.abs(self.y - self.postogo) < 2 then
                            self.y = self.postogo
                            self.isToScroll = false
                            self:removeTimer()
                        end
                    end

                    if self.deltay > 0 then self.deltay = self.deltay - 0.2 end
                    if self.deltay < 0 then self.deltay = self.deltay + 0.2 end

                    if self.deltay > self.options.maxScrollingForceY then self.deltay = self.options.maxScrollingForceY end
                    if self.deltay < -self.options.maxScrollingForceY then self.deltay = -self.options.maxScrollingForceY end
                end
            end
        end
    end
    if self.timerListener == nil then
        self.timerListener = RNMainThread.addTimedAction(self.options.timestep, self.step)
    end
end

function RNListView:removeTimer()
    if self.timerListener ~= nil then
        RNMainThread.removeAction(self.timerListener)
        self.timerListener = nil
        self:callRegisteredFunctions("endedScroll")
    end
end

function RNListView:callRegisteredFunctions(phase)
    for i = 1, #self.registeredFunctions do
        self.registeredFunctions[i](phase)
    end
end

function RNListView:registerFunction(funct)
    self.registeredFunctions[#self.registeredFunctions + 1] = funct
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
            local postogo = self.y + i * self.options.cellH + self.elements[i].offsetY - self.options.cellH
            if self.options.checkElements == true then
                if postogo > self.options.topLimit and postogo < self.options.bottomLimit then
                    v.object.y = postogo
                end
            else
                v.object.y = postogo
            end
        end
    end
    self.options.y = value
end

function RNListView:remove()
    self:removeTimer()
    if self.touchListener ~= nil then
        RNListeners:removeEventListener("touch", self.touchListener)
    end
    for i, v in ipairs(self.elements) do
        if v.object ~= nil then
            v.object:remove()
        end
    end

    self = nil
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
    self:organizeItems()

    if element.object.setScissorRect then element.object:setScissorRect(self.scissorRect) end
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
    self:organizeItems()
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

function RNListView:setScissorRect(scissorRect)
    self.scissorRect = scissorRect
    for i, v in ipairs(self.elements) do
        if v.object.setScissorRect then v.object:setScissorRect(scissorRect) end
    end
end

function RNListView:goToElement(value)
    self.isToScroll = true
    self.postogo = -value * self.options.cellH + self.options.touchStartY + self.options.cellH
    self:createTimer()
end

function RNListView:jumpToElement(value)
    self.y = -value * self.options.cellH + self.options.touchStartY + self.options.cellH
    self:removeTimer()
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
