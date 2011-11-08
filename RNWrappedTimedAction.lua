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

RNWrappedTimedAction = {}
require"socket"


function RNWrappedTimedAction:new(o)
    o = o or {
        name = ""
    }
    setmetatable(o, self)
    self.__index = self
    self.wrappedFunction = nil
    self.delay = 0
    self.lastTimeCheck = 0
    self.iterations = -1
    self.exectuions = 0
    return o
end

function RNWrappedTimedAction:isToCall()

    if self.iterations == -1 and self.delay == -1 then
        return true
    end

    if self.iterations > 0 and self.exectuions >= self.iterations then
        return false
    end

    if self.lastTimeCheck == 0 then
        self.lastTimeCheck = socket.gettime() * 1000
    end


    if socket.gettime() * 1000 - self.lastTimeCheck > self.delay then
        self.lastTimeCheck = socket.gettime() * 1000
        return true
    else
        return false
    end
end

function RNWrappedTimedAction:getFunction()
    return self.wrappedFunction
end

function RNWrappedTimedAction:setFunction(func)
    self.wrappedFunction = func
end

function RNWrappedTimedAction:getDelay()
    return self.delay
end

function RNWrappedTimedAction:setDelay(delay)
    self.delay = delay
end

function RNWrappedTimedAction:getIterations()
    return self.iterations
end

function RNWrappedTimedAction:setIterations(iterations)
    self.iterations = iterations
end

function RNWrappedTimedAction:call()
    local func = self.wrappedFunction
    if self.event ~= nil and self.event.source ~= nil then
        func(self.event)
    else
        func()
    end
    self.exectuions = self.exectuions + 1
end
