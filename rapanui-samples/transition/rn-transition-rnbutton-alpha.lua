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
    text = "Main Button 1",
    imageOver = "images/button-over.png",
    top = 50,
    left = 10,
    size = 16,
    width = 200,
    height = 50
})

trn = RNTransition:new()

function setAlphaToZero()
    trn:run(button, { type = "alpha", alpha = 0, time = 1000, onComplete = setAlphaToOne })
end

function setAlphaToOne()
    trn:run(button, { type = "alpha", alpha = 1, time = 1000, onComplete = setAlphaToZero })
end

setAlphaToZero()


function button1TouchDown(event)
    print("Button 1 touch down!")
end

function button1UP(event)
    print("Button 1 touch up")
end

button:setOnTouchDown(button1TouchDown)
button:setOnTouchUp(button1UP)

