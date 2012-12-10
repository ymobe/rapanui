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

RNTimer = {}

local function fieldChangedListener(self, key, value)

    getmetatable(self).__object[key] = value
    self = getmetatable(self).__object
end


local function fieldAccessListener(self, key)

    local object = getmetatable(self).__object

    return getmetatable(self).__object[key]
end



function RNTimer:new(o)
    local tab = RNTimer:innerNew(o)
    local proxy = setmetatable({}, { __newindex = fieldChangedListener, __index = fieldAccessListener, __object = tab })
    return proxy, tab
end


function RNTimer:innerNew(o)

    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function RNTimer:callback(keyframe, executed)
    self = self.obj
    --print(executed)
    --print(keyframe)
    --to perform action
    if self.toRepeat == false then
        if keyframe == self.iterations then
            self.timer:stop()
            --self.timer = nil
            --self.curve = nil
        end
    end
    if self ~= nil then self.funct() end
end

function RNTimer:remove()
    if self.timer ~= nil then
        self.timer:stop()
        --self.timer = nil
    end
    --if self.curve ~= nil then self.curve = nil end
    if self ~= nil then self = nil end
end

function RNTimer:pause()
    if self.timer ~= nil then self.timer:stop() end
end

function RNTimer:unpause()
    if self.timer ~= nil then self.timer:start() end
end

function RNTimer:init(delay, funct, iterations)
    local timer
    local curve
    self.toRepeat = false

    if iterations == nil or iterations == -1 then
        iterations = 1
        self.toRepeat = true
    end

    timer = MOAITimer.new()
    timer:setMode(MOAITimer.LOOP)

    curve = MOAIAnimCurve.new()
    curve:reserveKeys(iterations)
    for i = 1, iterations do
        curve:setKey(i, i, i, MOAIEaseType.LINEAR, 1)
    end

    timer:setCurve(curve)

    timer:setListener(MOAITimer.EVENT_TIMER_KEYFRAME, self.callback)
    timer:setSpan(iterations)
    timer:setSpeed(delay)
    timer:start()

    timer.obj = self
    self.timer = timer
    self.curve = curve
    self.delay = delay
    self.funct = funct
    self.iterations = iterations
end


return RNTimer