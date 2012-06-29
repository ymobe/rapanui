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

require"socket"
RNWrappedEventListener = {}


function RNWrappedEventListener:new(o)
    o = o or {
        name = "",
        scheduleRemove = false
    }
    setmetatable(o, self)
    self.__index = self
    self.wrappedFunction = nil
    return o
end

function RNWrappedEventListener:getFunction()
    return self.wrappedFunction
end

function RNWrappedEventListener:setTarget(object)
    self.target = object
end

function RNWrappedEventListener:getTarget()
    return self.target
end

function RNWrappedEventListener:scheduleForRemoval()
    self.scheduleRemove = true
end

function RNWrappedEventListener:isToRemove()
    return self.scheduleRemove
end

function RNWrappedEventListener:setFunction(func)
    self.wrappedFunction = func
end

function RNWrappedEventListener:isToCall(x, y)
    if self.target ~= nil then
        return self.target:isInRange(x, y)
    end
    return nil
end

function RNWrappedEventListener:call(event)

    local func = self.wrappedFunction

    event.target = self.target

    if event ~= nil and func ~= nil then
        func(event)
    else
        if event == nil then
            print("[WARN] RNWrappedEventListener: Event was nil")
        end

        if func == nil then
            print("[WARN] RNWrappedEventListener: function was nil")
        end
    end
end

return RNWrappedEventListener
