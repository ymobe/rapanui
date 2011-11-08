------------------------------------------------------------------------------------------------------------------------
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
--
------------------------------------------------------------------------------------------------------------------------

require("RNWrappedTimedAction")
require("RNUtil")


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
    return o
end



function RNThread:runFunction(delay, func, iterations)
    local wrappedTimedAction = RNWrappedTimedAction:new()
    wrappedTimedAction:setFunction(func)
    wrappedTimedAction:setDelay(delay)
    wrappedTimedAction:setIterations(iterations)

    self.wrappedFunctions[self.wrappedFunctionSize] = wrappedTimedAction
    self.wrappedFunctionSize = self.wrappedFunctionSize + 1
end

function RNThread:addEnterFrame(func, source)
    local wrappedTimedAction = RNWrappedTimedAction:new()
    wrappedTimedAction:setFunction(func)
    wrappedTimedAction.event = {}
    wrappedTimedAction.event.source = source
    wrappedTimedAction:setDelay(-1)
    wrappedTimedAction:setIterations(-1)

    self.wrappedFunctions[self.wrappedFunctionSize] = wrappedTimedAction
    self.wrappedFunctionSize = self.wrappedFunctionSize + 1
end

function RNThread:start()
    if main_thread_started == false then
        main_thread_started = true
        thread:run(function()
            while true do
                for i = 0, self.wrappedFunctionSize - 1 do

                    local wrappedTimedAction = self.wrappedFunctions[i]
                    if wrappedTimedAction:isToCall() then
                        wrappedTimedAction:call()
                    end
                end

                coroutine.yield()
            end
        end)
    end
end

