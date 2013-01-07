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

RNPageSwipe = {}


local function fieldChangedListener(self, key, value)

    getmetatable(self).__object[key] = value
    self = getmetatable(self).__object
end


local function fieldAccessListener(self, key)

    local object = getmetatable(self).__object

    return getmetatable(self).__object[key]
end



function RNPageSwipe:new(o)
    local tab = RNPageSwipe:innerNew(o)
    local proxy = setmetatable({}, { __newindex = fieldChangedListener, __index = fieldAccessListener, __object = tab })
    return proxy, tab
end


function RNPageSwipe:innerNew(o)

    o = o or {
        name = "",
        options = { touchLength = 100, mode = MOAIEaseType.SMOOTH, rows = 0, columns = 0, offsetX = 0, offsetY = 0, dividerX = 0, dividerY = 0, cellW = 0, cellW = 0, pageW = 0, touchAreaStartingX = 0, touchAreaStartingY = 0, touchAreaW = 0, touchAreaH = 0, time = 0 },
        elements = {},
        pages = 0,
        tempx = 0,
        forcex = 0,
        currentPage = 1,
        touchListener = nil,
        isMoving = false,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function RNPageSwipe:init()
    self = self
    --calculates pages
    local eleNumber = table.getn(self.elements)
    local pages = math.modf(eleNumber / (self.options.columns * self.options.rows))
    local elementsInLastPage = eleNumber - (self.options.columns * self.options.rows) * pages
    --setting self values
    if elementsInLastPage > 0 then self.pages = pages + 1 else self.pages = pages end
    --arranging objects
    self:arrange()
    --touch listener
    self.touch = function(event)
        local self = self
        if self.canSwipe == true then
            if event.x > self.options.touchAreaStartingX and event.x < self.options.touchAreaW + self.options.touchAreaStartingX and event.y > self.options.touchAreaStartingY and event.y < self.options.touchAreaH + self.options.touchAreaStartingY then
                if event.phase == "began" then
                    self:callRegisteredFunctions("touchSwipeBegan")
                    self.tempx = event.x
                    self.STARTINGX = event.x
                end
                if event.phase == "moved" then
                    self:callRegisteredFunctions("touchSwipeMoved")
                    self.forcex = (event.x - self.tempx)
                    self.tempx = event.x
                    self.isMoving = true
                    --
                    --move elements according to touch
                    for i, v in ipairs(self.elements) do
                        v.object.x = v.object.x + self.forcex
                    end
                    --sets forcex to 0 at the end
                    self.forcex = 0 --
                end

                if event.phase == "ended" then
                    --check current page
                    if self.STARTINGX ~= nil then
                        if math.abs(self.STARTINGX - event.x) > self.options.touchLength then
                            if self.STARTINGX > event.x then
                                if self.currentPage < self.pages then
                                    self.currentPage = self.currentPage + 1
                                end
                            end
                            if self.STARTINGX < event.x then
                                if self.currentPage > 1 then
                                    self.currentPage = self.currentPage - 1
                                end
                            end
                        end
                    end

                    self.forcex = 0
                    self:doSwipe()
                    self.isMoving = false
                    --call registered functions
                    self:callRegisteredFunctions("touchSwipeEnded")
                end

            else
                if event.phase == "ended" then


                    if self.isMoving == true then
                        --check current page
                        if self.STARTINGX ~= nil then
                            if math.abs(self.STARTINGX - event.x) > self.options.touchLength then
                                if self.STARTINGX > event.x then
                                    if self.currentPage < self.pages then
                                        self.currentPage = self.currentPage + 1
                                    end
                                end
                                if self.STARTINGX < event.x then
                                    if self.currentPage > 1 then
                                        self.currentPage = self.currentPage - 1
                                    end
                                end
                            end
                        end


                        self.forceX = 0
                        self:doSwipe()
                        self.isMoving = false
                        self:callRegisteredFunctions("touchSwipeCancelled")
                    end
                end
            end
        end
    end
    self.touchListener = RNListeners:addEventListener("touch", self.touch)
    self.registeredFunctions = {}
    self.canSwipe = true
end

function RNPageSwipe:arrange()
    local col = 1
    local row = 1
    local page = 1
    for i, v in ipairs(self.elements) do
        if col == self.options.columns + 1 then
            col = 1
            row = row + 1
        end
        if row == self.options.rows + 1 then
            row = 1
            page = page + 1
        end
        local o = self.elements[i].object
        o.x = self.options.offsetX + self.options.cellW * (col - 1) + self.options.dividerX * (col - 1) + self.options.pageW * (page - 1)
        o.y = self.options.offsetY + self.options.cellH * (row - 1) + self.options.dividerY * (row - 1)
        col = col + 1
    end
end



function RNPageSwipe:doSwipe()
    self.canSwipe = false
    local maxPage = self.pages
    local col = 1
    local row = 1
    local page = 1
    for i, v in ipairs(self.elements) do
        if col == self.options.columns + 1 then
            col = 1
            row = row + 1
        end
        if row == self.options.rows + 1 then
            row = 1
            page = page + 1
        end
        local trn = RNTransition:new()
        if i == maxPage then
            trn:run(v.object, {
                type = "move",
                mode = self.options.mode,
                time = self.options.time,
                x = self.options.offsetX + self.options.cellW * (col - 1) + self.options.dividerX * (col - 1) + self.options.pageW * (page - 1) - self.options.pageW * (self.currentPage - 1),
                onComplete = function()
                    if self ~= nil then
                        self:callRegisteredFunctions("endedSwipe")
                        self.isMoving = false
                        self.canSwipe = true
                    end
                end
            })
        else
            trn:run(v.object, { type = "move", mode = self.options.mode, time = self.options.time, x = self.options.offsetX + self.options.cellW * (col - 1) + self.options.dividerX * (col - 1) + self.options.pageW * (page - 1) - self.options.pageW * (self.currentPage - 1) })
        end
        col = col + 1
    end
end



function RNPageSwipe:jumpToPage(value)
    if value ~= self.currentPage then
        if value <= self.pages then
            self.currentPage = value
        else
            self.currentPage = self.pages
        end
        self:doJump()
    end
    self:endJump()
end

function RNPageSwipe:doJump()
    local col = 1
    local row = 1
    local page = 1
    for i, v in ipairs(self.elements) do
        if col == self.options.columns + 1 then
            col = 1
            row = row + 1
        end
        if row == self.options.rows + 1 then
            row = 1
            page = page + 1
        end
        v.object.x = self.options.offsetX + self.options.cellW * (col - 1) + self.options.dividerX * (col - 1) + self.options.pageW * (page - 1) - self.options.pageW * (self.currentPage - 1)
        col = col + 1
    end
end

function RNPageSwipe:endJump()
    self:callRegisteredFunctions("endedJump")
end

function RNPageSwipe:registerFunction(funct)
    self.registeredFunctions[#self.registeredFunctions + 1] = funct
    return #self.registeredFunctions
end

function RNPageSwipe:removeRegisteredFunction(id)
    self.registeredFunctions[id] = nil
    for i = id, #self.registeredFunctions do
        self.registeredFunctions[i] = self.registeredFunctions[i + 1]
    end
    self.registeredFunctions[#self.registeredFunctions] = nil
end


function RNPageSwipe:insert(element, number)
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
    --recalculates pages
    self.pages = 0
    local eleNumber = table.getn(self.elements)
    local pages = math.modf(eleNumber / (self.options.columns * self.options.rows))
    local elementsInLastPage = eleNumber - (self.options.columns * self.options.rows) * pages
    --setting self values
    if elementsInLastPage > 0 then self.pages = pages + 1 else self.pages = pages end
    self:arrange()

    if element.object.setScissorRect then element.object:setScissorRect(self.scissorRect) end
end

function RNPageSwipe:callRegisteredFunctions(phase)
    for i = 1, #self.registeredFunctions do
        self.registeredFunctions[i](phase)
    end
end

function RNPageSwipe:removeElementByNumber(removeRNObject, number)
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
    --recalculates pages
    self.pages = 0
    local eleNumber = table.getn(self.elements)
    local pages = math.modf(eleNumber / (self.options.columns * self.options.rows))
    local elementsInLastPage = eleNumber - (self.options.columns * self.options.rows) * pages
    --setting self values
    if elementsInLastPage > 0 then self.pages = pages + 1 else self.pages = pages end
    self:arrange()
end

function RNPageSwipe:removeElementByPageAndNumber(removeRNObject, page, num)
    local number = (self.options.columns * self.options.rows) * (page - 1) + num
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
    --recalculates pages
    self.pages = 0
    local eleNumber = table.getn(self.elements)
    local pages = math.modf(eleNumber / (self.options.columns * self.options.rows))
    local elementsInLastPage = eleNumber - (self.options.columns * self.options.rows) * pages
    --setting self values
    if elementsInLastPage > 0 then self.pages = pages + 1 else self.pages = pages end
    self:arrange()
end


function RNPageSwipe:getElementsInLastPage()
    local eleNumber = table.getn(self.elements)
    local pages = math.modf(eleNumber / (self.options.columns * self.options.rows))
    local elementsInLastPage = eleNumber - (self.options.columns * self.options.rows) * pages
    if elementsInLastPage == 0 then elementsInLastPage = self.options.columns * self.options.rows end
    return elementsInLastPage
end

function RNPageSwipe:swapElementsByNames(n1, n2)
    local nn1 = self:getElementByName(n1).object
    local t, y, globaln1 = self:getPageAndNumberByElement(nn1)
    local nn2 = self:getElementByName(n2).object
    local u, f, globaln2 = self:getPageAndNumberByElement(nn2)

    local tempn1 = self.elements[globaln1]
    local tempn2 = self.elements[globaln2]

    self.elements[globaln1] = tempn2
    self.elements[globaln2] = tempn1

    self:arrange()
end

function RNPageSwipe:swapElementsByObjects(nn1, nn2)
    local t, y, globaln1 = self:getPageAndNumberByElement(nn1)
    local u, f, globaln2 = self:getPageAndNumberByElement(nn2)

    local tempn1 = self.elements[globaln1]
    local tempn2 = self.elements[globaln2]

    self.elements[globaln1] = tempn2
    self.elements[globaln2] = tempn1

    self:arrange()
end

function RNPageSwipe:swapElementsByPageAndNumber(page1, number1, page2, number2)
    local globaln1 = (self.options.columns * self.options.rows) * (page1 - 1) + number1
    local globaln2 = (self.options.columns * self.options.rows) * (page2 - 1) + number2


    local tempn1 = self.elements[globaln1]
    local tempn2 = self.elements[globaln2]

    self.elements[globaln1] = tempn2
    self.elements[globaln2] = tempn1

    self:arrange()
end


function RNPageSwipe:swapElementsByNumbers(n1, n2)
    local tempn1 = self.elements[n1]
    local tempn2 = self.elements[n2]

    self.elements[n1] = tempn2
    self.elements[n2] = tempn1

    self:arrange()
end


function RNPageSwipe:getElementByName(value)
    local o
    for i, v in ipairs(self.elements) do
        if v.name == value then
            o = v
        end
    end
    return o
end


function RNPageSwipe:getPageAndNumberByElement(object)
    local page = 1
    local numberinpage
    local globalnumber
    local k = 1
    local flag = false
    for i, v in ipairs(self.elements) do
        if v.object == object then
            globalnumber = i
            k = i
        end
    end

    while flag == false do
        if k > 6 then
            k = k - (self.options.rows * self.options.columns)
            page = page + 1
        else
            numberinpage = k
            flag = true
        end
    end



    return page, numberinpage, globalnumber
end

function RNPageSwipe:getElementByPageAndNumber(page, number)
    local obj
    local elementsEachPage = self.options.rows * self.options.columns
    obj = self.elements[number + (page - 1) * elementsEachPage]
    return obj
end

function RNPageSwipe:getElementByGlobalNumber(value)
    return self.elements[value]
end

function RNPageSwipe:goToPage(value)
    if value ~= self.currentPage then
        if value <= self.pages then
            self.currentPage = value
        else
            self.currentPage = self.pages
        end
        self:doSwipe()
        self:callRegisteredFunctions("goToPage")
    else
        self:callRegisteredFunctions("endedSwipe")
    end
end

function RNPageSwipe:remove()
    RNListeners:removeEventListener("touch", self.touchListener)
    for i, v in ipairs(self.elements) do
        if v.object ~= nil then
            v.object:remove()
        end
    end

    self = nil
    self = nil
end


function RNPageSwipe:getSize()
    return table.getn(self.elements)
end


--

function RNPageSwipe:getType()
    return "RNPageSwipe"
end

function RNPageSwipe:setScissorRect(scissorRect)
    self.scissorRect = scissorRect
    for i, v in ipairs(self.elements) do
        if v.object.setScissorRect then v.object:setScissorRect(scissorRect) end
    end
end

function RNPageSwipe:setAlpha(value)
    for i, v in ipairs(self.elements) do
        v.object:setAlpha(value)
    end
end

function RNPageSwipe:setVisibility(value)
    for i, v in ipairs(self.elements) do
        v.object.visible = value
    end
end



--mocks for groupAdd (Yes, RNListViews can be added to RNGroups ^^)


function RNPageSwipe:setIDInGroup()
    --mocked for group adding see RNGroup
end

function RNPageSwipe:setLevel()
    --mocked for group adding see RNGroup
end



return RNPageSwipe
