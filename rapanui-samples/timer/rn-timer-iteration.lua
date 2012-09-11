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

times = 0
local background = RNFactory.createImage("images/background-purple.png")

local iterations = 10

text = RNFactory.createText("Gone run: ", { size = 20, top = 5, left = 5, width = 200, height = 50 })

local function count()
    times = times + 1
    text:setText("Gone run: " .. times)
end

local actionId = RNMainThread.addTimedAction(0.5, count, iterations)
