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

-- any image, animation or image or animation from atlas or image from physics can be scaled, mirrored or flipped.

local background = RNFactory.createImage("images/background-blue.png")

anImage = RNFactory.createImage("images/image2.png", { top = 64, left = 64 })
--scale
anImage.scaleX = 1.5
anImage.scaleY = 0.5
anImage = RNFactory.createImage("images/image2.png", { top = 204, left = 64 })
--scale
anImage.scaleX = 0.5
anImage.scaleY = 2.5
anImage = RNFactory.createImage("images/image3.png", { top = 130, left = 130 })
--mirror and scale
anImage.scaleX = -0.3
anImage.scaleY = -0.4
anImage = RNFactory.createImage("images/image4.png", { top = 194, left = 194 })
--flip
anImage:flipHorizontal()
anImage:flipVertical()
