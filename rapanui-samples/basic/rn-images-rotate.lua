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
local l = require("localise")
anImage = l.RNFactory.createImage("RN/images/image.png")

print(anImage.y)
print(anImage.x)

print(anImage.y)
print(anImage.x)

local background = l.RNFactory.createImage("RN/images/background-blue.png")

anImage = l.RNFactory.createImage("RN/images/image2.png", { top = 64, left = 64 })
anImage.rotation = 10
anImage = l.RNFactory.createImage("RN/images/image3.png", { top = 130, left = 130 })
anImage.rotation = 20
anImage = l.RNFactory.createImage("RN/images/image4.png", { top = 194, left = 194 })
anImage.rotation = 30

--aText = l.RNFactory.createImage("Hello World!", 0, 0, native.systemFont, 16)
--aText.x = 50
--aText.y = 100
--aText:setTextColor(255, 255, 255)

--print("Objects in game: " .. display.getCurrentStage().numChildren)