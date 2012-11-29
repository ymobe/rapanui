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

local background = RNFactory.createImage("images/background-purple.png")

text1 = RNFactory.createText("Hello world!", { size = 25, top = 5, left = 5, width = 200, height = 50 })

text2 = RNFactory.createText("Left world!", { alignment = MOAITextBox.LEFT_JUSTIFY, size = 20, top = 50, left = 5, width = 200, height = 50, font="dwarves.TTF"})
text2:setTextSize(40)
text2:setTextColor(15, 40, 200)
text2:setAlpha(0.8)

local scissorRect = MOAIScissorRect.new()
scissorRect:setRect( 5, 50, 205, 65)
text2:setScissorRect(scissorRect)