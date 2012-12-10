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


-- this sample shows how to set image levels.
-- it only works for images in the same group because each group has its own priority set to 1.

IMG_POS_Y = 0
IMG_POS_X = 0

SHIFT_X = 20
SHIFT_Y = 20

local background = RNFactory.createImage("images/background-purple.png")

anImage1 = RNFactory.createImage("images/tile1.png", { top = IMG_POS_X + SHIFT_X * 4, left = IMG_POS_Y + SHIFT_Y * 4 })
anImage2 = RNFactory.createImage("images/tile2.png", { top = IMG_POS_X + SHIFT_X * 3, left = IMG_POS_Y + SHIFT_Y * 3 })
anImage3 = RNFactory.createImage("images/tile3.png", { top = IMG_POS_X + SHIFT_X * 2, left = IMG_POS_Y + SHIFT_Y * 2 })
anImage4 = RNFactory.createImage("images/tile4.png", { top = IMG_POS_X + SHIFT_X, left = IMG_POS_Y + SHIFT_Y })
anImage5 = RNFactory.createImage("images/tile5.png", { top = IMG_POS_X, left = IMG_POS_X })

anImage5:sendToBottom()

anImage1:bringToFront()

IMG_POS_Y = 150

anImage_B6 = RNFactory.createImage("images/tile6.png", { top = IMG_POS_X + SHIFT_X * 2, left = IMG_POS_Y })
anImage_B7 = RNFactory.createImage("images/tile7.png", { top = IMG_POS_X + SHIFT_X, left = IMG_POS_Y })
anImage_B8 = RNFactory.createImage("images/tile8.png", { top = IMG_POS_X, left = IMG_POS_Y })

anImage_B7:putOver(anImage_B8)

