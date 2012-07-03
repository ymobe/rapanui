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

--[[ 
-- Free bitmap fonts by SpicyPixel.NET
-- ]]

local background = RNFactory.createImage("images/background-purple.png")



text1 = RNFactory.createBitmapText("HELLO BITMAP WORLD!", {
    image = "images/kromasky.png",
    charcodes = " ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789:;?!\"%',.",
    top = 55,
    left = 10,
    charWidth = 16,
    charHeight = 16
})


text1.y=200

background:sendToBottom()

