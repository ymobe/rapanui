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

anImage = RNFactory.createImage("images/tile1.png")

trn = RNTransition:new()

function goToPointA()
    trn:run(anImage, { type = "rotate", time = 1500, angle = 720, onComplete = goToPointB })
    trn:run(anImage, { type = "move", time = 1500, alpha = 0, x = 200, y = 400 })
end

function goToPointB()
    trn:run(anImage, { type = "rotate", time = 1500, angle = -720, onComplete = goToPointA })
    trn:run(anImage, { type = "move", time = 1500, alpha = 0, x = 32, y = 32 })
end

goToPointA()


