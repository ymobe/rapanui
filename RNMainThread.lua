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


function performWithDelay ( delay, func, repeats, ... )
  local t = MOAITimer.new ()
  t:setSpan (delay/100)
  t:setListener ( MOAITimer.EVENT_TIMER_LOOP,
    function ()
      t:stop ()
      t = nil
      func ( unpack ( arg ))
		if repeats then
			if repeats > 1 then
				M.performWithDelay(delay, func, repeats - 1, unpack ( arg ))
			elseif repeats == 0 then
				M.performWithDelay(delay, func, 0, unpack ( arg ))
			end
		end
    end
  )
  t:start ()
end