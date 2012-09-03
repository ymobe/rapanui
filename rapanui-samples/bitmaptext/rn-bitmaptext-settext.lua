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


text = RNFactory.createBitmapText("CLICK!", {
    image = "images/kromasky.png",
    charcodes = " ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789:;?!\"%',.",
    top = 55,
    left = 50,
    charWidth = 16,
    charHeight = 16
})


text.y = 200

function buttonUP(event)
    text:setText("TOUCH UP")
end

function buttonTouchDown(event)
    text:setText("TOUCH DOWN")
end

button = RNFactory.createButton("images/button-plain.png", {
    text = "Main Button 1",
    imageOver = "images/button-over.png",
    top = 50,
    left = 10,
    size = 16,
    width = 200,
    height = 50,
    onTouchDown = buttonTouchDown,
    onTouchUp = buttonUP,
    font = "arial-rounded.TTF"
})

background:sendToBottom()