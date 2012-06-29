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

RNMainThread = {}

RNMainThread.rnThread = RNThread:new()

function RNMainThread.addTimedAction(delay, func, iterations)
    --local actionid = RNMainThread.rnThread:runFunction(delay, func, iterations)
    --return actionid
    local timerObject = RNTimer:new()
    delay = 1 / delay
    timerObject:init(delay, func, iterations)
    return timerObject
end

function RNMainThread.suspendAction(actionid)
    actionid:pause()
end

function RNMainThread.resumeAction(actionId)
    actionId:unpause()
end

function RNMainThread.removeAction(actionid)
    actionid:remove()
end

function RNMainThread.getMainThread()
    return RNMainThread.rnThread
end

function RNMainThread.startMainThread()
    RNMainThread.rnThread:start()
end

return RNMainThread