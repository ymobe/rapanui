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

module(..., package.seeall)

require("RNThread")

rnThread = RNThread:new()

function addTimedAction(delay, func, iterations)
    rnThread:runFunction(delay, func, iterations)
    rnThread:start()
end

function getMainThread()
    return rnThread
end

function startMainThread()
    rnThread:start()
end