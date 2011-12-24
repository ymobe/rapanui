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

local RNRuntime = {}
local R
function RNRuntime:new(o)
    o = o or {
        name = ""
    }
    setmetatable(o, self)
    self.__index = self

    self.objects = {}
    return o
end

function RNRuntime:addEventListener(eventName, listener)
if not R then R = RN end
    if eventName == "enterFrame" then


        if type(listener) == "table" then
            R.MainThread.getMainThread():addEnterFrame(listener.enterFrame, listener)
            R.MainThread.startMainThread()
        end

        if type(listener) == "function" then
            R.MainThread.getMainThread():addEnterFrame(listener)
            R.MainThread.startMainThread()
        end

    elseif eventName == "touch" then
        R.InputManager.addGlobalListenerToEvent(eventName, listener)
    end
end

function RNRuntime:removeEventListener(eventname, func)
end


local RNListeners = RNRuntime:new()
return RNListeners