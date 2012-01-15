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

anImage = RNFactory.createImage("images/tile1.png", { top = 64, left = 64 })

trn = RNTransition:new()

function first()
    trn:run(anImage, { type = "rotate", time = 1500, angle = 360, onComplete = second })
end

function second()
    trn:run(anImage, { type = "rotate", time = 1500, angle = -360, onComplete = first })
end

first()