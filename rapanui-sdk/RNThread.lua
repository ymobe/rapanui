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

require("rapanui-sdk/RNWrappedTimedAction")

RNThread = {}

thread = MOAIThread.new()

main_thread_started = false
function RNThread:new(o)
    o = o or {
        name = ""
    }
    setmetatable(o, self)
    self.__index = self
    self.wrappedFunctions = {}
    self.wrappedFunctionSize = 0
    self.wproxy = {}
    return o
end


function RNThread:runFunction(delay, func, iterations)
    local wrappedTimedAction = RNWrappedTimedAction:new()
    wrappedTimedAction:setFunction(func)
    wrappedTimedAction:setDelay(delay)
    wrappedTimedAction:setIterations(iterations)

    self.wrappedFunctionSize = self.wrappedFunctionSize + 1
    self.wrappedFunctions[self.wrappedFunctionSize] = wrappedTimedAction
    --create proxy
    self.wproxy[table.getn(self.wproxy) + 1] = self.wrappedFunctionSize

    return self.wrappedFunctionSize
end


function RNThread:resumeAction(actionid)
    local wrappedAction = self.wrappedFunctions[self.wproxy[actionid]]
    wrappedAction:resume()
end

function RNThread:removeAction(actionid)
    self.wrappedFunctions[actionid] = nil
    --search in proxy the index to remove
    local place = nil
    for i = 1, table.getn(self.wproxy) do
        if self.wproxy[i] == actionid then
            place = i
        end
    end
    if place ~= nil then
        --move all
        for i = place, table.getn(self.wproxy) - 1 do
            self.wproxy[i] = self.wproxy[i + 1]
        end
        --nil last one
        self.wproxy[table.getn(self.wproxy)] = nil
    end
end


function RNThread:suspendAction(actionid)
    local wrappedAction = self.wrappedFunctions[self.wproxy[actionid]]
    wrappedAction:suspend()
end

function RNThread:addEnterFrame(func, source)
    local wrappedTimedAction = RNWrappedTimedAction:new()
    wrappedTimedAction:setFunction(func)
    wrappedTimedAction.event = {}
    wrappedTimedAction.event.source = source
    wrappedTimedAction:setDelay(-1)
    wrappedTimedAction:setIterations(-1)

    self.wrappedFunctionSize = self.wrappedFunctionSize + 1
    self.wrappedFunctions[self.wrappedFunctionSize] = wrappedTimedAction
    --create proxy
    self.wproxy[table.getn(self.wproxy) + 1] = self.wrappedFunctionSize

    return self.wrappedFunctionSize
end


function RNThread:start()
    if main_thread_started == false then
        main_thread_started = true
        thread:run(function()
            while true do
                coroutine.yield()
                for i = 1, table.getn(self.wproxy) do
                    local wrappedTimedAction = self.wrappedFunctions[self.wproxy[i]]
                    if wrappedTimedAction ~= nil and wrappedTimedAction:isToCall() then
                        wrappedTimedAction:call()
                    end
                end
            end
        end)
    end
end

return RNThread