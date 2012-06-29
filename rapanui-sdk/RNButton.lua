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



RNButton = {}


local function fieldChangedListenerRNButton(self, key, value)

    getmetatable(self).__object[key] = value
    self = getmetatable(self).__object


    if key ~= nil and key == "x" then
        local tmpX = value
        local tmpY = self.y

        for key, prop in pairs(self:getAllRNObjectProps()) do
            prop:setLoc(tmpX, tmpY);
        end

        if self.text ~= nil then

            self.text:getProp():setLoc(tmpX - self.rnImageDefault.originalWidth / 2, tmpY - self.rnImageDefault.originalHeight / 2)
        end
    end

    if key ~= nil and key == "y" then

        local tmpX = self.x
        local tmpY = value

        for key, prop in pairs(self:getAllRNObjectProps()) do
            prop:setLoc(tmpX, tmpY);
        end
        if self.text ~= nil then

            self.text:getProp():setLoc(tmpX - self.rnImageDefault.originalWidth / 2, tmpY - self.rnImageDefault.originalHeight / 2)
            --self.text:getProp():setLoc(tmpX, tmpY)
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
        xx, yy = object.rnImageDefault:getProp():getLoc()
        object.x = xx
    end


    if key ~= nil and key == "y" then

        local xx, yy
        xx, yy = object.rnImageDefault:getProp():getLoc()
        object.y = yy
    end

    return getmetatable(self).__object[key]
end

function RNButton:innerNew(o)
    o = o or {
        name = "",
        rntext = nil,
        rnImageDefault = nil,
        rnImageOver = nil,
        x = 0,
        y = 0
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

    if imageOver ~= nil then
        self.rnImageOver = imageOver
    end


    local function defaultOnTouchDownButton(event)
        event.target = self

        if self.rnImageOver ~= nil then

            self.rnImageDefault:setVisible(false)
            self.rnImageOver:setVisible(true)
        end

        if self.onTouchDownFunc ~= nil then
            self.onTouchDownFunc(event)
        end
    end

    self.rnImageDefault:setOnTouchDown(defaultOnTouchDownButton)

    local function defaultOnTouchUp(event)

        event.target = self


        if self.rnImageOver ~= nil then
            self.rnImageOver:setVisible(false)
            self.rnImageDefault:setVisible(true)
        end

        if self.onTouchUpFunc ~= nil then
            self.onTouchUpFunc(event)
        end
    end

    self.rnImageDefault:setOnTouchUp(defaultOnTouchUp)
end


function RNButton:getType()
    return "RNButton"
end

function RNButton:setAlpha(level)


    if self.text ~= nil then
        self.text:setAlpha(level)
    end

    self.rnImageDefault:setAlpha(level)

    if self.rnImageOver ~= nil then
        self.rnImageOver:setAlpha(level)
    end
end

function RNButton:setLevel(level)

    if self.text ~= nil then
        self.text:setLevel(level)
    end

    self.rnImageDefault:setLevel(level)

    if self.rnImageOver ~= nil then
        self.rnImageOver:setLevel(level)
    end
end

function RNButton:setIDInGroup(idInGroup)
    self.idInGroup = idInGroup
end

function RNButton:setParentGroup(group)
    if self.text ~= nil then
        self.text:setParentGroup(group)
    end

    self.rnImageDefault:setParentGroup(group)

    if self.rnImageOver ~= nil then
        self.rnImageOver:setParentGroup(group)
    end

    self.parentGroup = group
end

function RNButton:getLoc()
    return self.rnImageDefault:getProp():getLoc()
end

function RNButton:getRNtext()
    return self.text
end

function RNButton:getAllProps()
    local props = self:getAllRNObjectProps()
    if self.text ~= nil then
        table.insert(props, self.text:getProp())
    end
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
end


function RNButton:setOnTouchUp(func)
    self.onTouchUpFunc = func
end


function RNButton:setText(value)
    if self.text ~= nil then
        self.text:setText(value)
    end
end

function RNButton:remove(func)
    if self.text ~= nil then
        self.text:remove()
    end
    if self.rnImageDefault ~= nil then
        self.rnImageDefault:remove()
    end
    if self.rnImageOver ~= nil then
        self.rnImageOver:remove()
    end

    if (self.parentGroup) then
        self.parentGroup:removeChild(self.idInGroup)
    end
    self.text = nil
    self.rnImageDefault = nil
    self.rnImageOver = nil
    self = nil
end


return RNButton