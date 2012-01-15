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
anImage2 = RNFactory.createImage("images/tile2.png", { top = 64, left = 192 })

trn = RNTransition:new()

function first()
    trn:run(anImage, { type = "scale", xScale = 1, yScale = 1, time = 1000, onComplete = second })
    trn:run(anImage2, { type = "scale", xScale = -0.5, yScale = -0.5, time = 1000 })
end

function second()
    trn:run(anImage, { type = "scale", xScale = -1, yScale = -1, time = 1000, onComplete = first })
    trn:run(anImage2, { type = "scale", xScale = 0.5, yScale = 0.5, time = 1000 })
end

first()



