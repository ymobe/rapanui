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

local background = RNFactory.createImage("images/background-blue.png")

text = RNFactory.createText("Hello world!", { size = 10, top = 0, left = 0, width = 200, height = 50 })

trn = RNTransition:new()

function goToPointA()
    trn:run(text, { type = "move", time = 1500, alpha = 0, x = 200, y = 200, onComplete = goToPointB })
end

function goToPointB()
    trn:run(text, { type = "move", time = 1500, alpha = 0, x = 0, y = 0, onComplete = goToPointA })
end

goToPointA()

