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

RNRuntime = {}

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

    if eventName == "enterFrame" then


        if type(listener) == "table" then
            RNMainThread.getMainThread():addEnterFrame(listener.enterFrame, listener)
            RNMainThread.startMainThread()
        end

        if type(listener) == "function" then
            RNMainThread.getMainThread():addEnterFrame(listener)
            RNMainThread.startMainThread()
        end

    elseif eventName == "touch" then
        RNInputManager.addGlobalListenerToEvent(eventName, listener)
    end
end

function RNRuntime:removeEventListener(eventname, func)
end


RNListeners = RNRuntime:new()