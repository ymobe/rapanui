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

button = RNFactory.createButton("images/button-plain.png", {
    text = "Button1",
    imageOver = "images/button-over.png",
    top = 150,
    left = 10,
    size = 16,
    width = 200,
    height = 50
})
button2 = RNFactory.createButton("images/button-plain.png", {
    text = "Button2",
    imageOver = "images/button-over.png",
    top = 200,
    left = 10,
    size = 16,
    width = 200,
    height = 50
})

local scissorRect = MOAIScissorRect.new()
scissorRect:setRect( 10, 200, 410, 225)
button2:setScissorRect(scissorRect)
