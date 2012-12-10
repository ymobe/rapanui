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
local toShow = true

function button1TouchDown(event)
    text:setText("Main Button touch down!")
end

function button1UP(event)
    text:setText("Main Button touch up")
end

mainButton = RNFactory.createButton("images/button-plain.png", {
    text = "Main Button",
    imageOver = "images/button-over.png",
    imageDisabled = "images/button-disabled.png",
    top = 50,
    left = 10,
    size = 22,
    width = 200,
    height = 50,
    onTouchDown = button1TouchDown,
    onTouchUp = button1UP,
    font = "arial-rounded.TTF"
})

-- second button to show different text alignments

button2 = RNFactory.createButton("images/button-plain.png", {
    text = "Hide Main Button",
    top = 150,
    left = 10,
    size = 22,
    width = 200,
    height = 50
})



text = RNFactory.createText("Touch on buttons 1", { size = 18, top = 400, left = 5, width = 250, height = 50 })




function button2UP(event)
    if toShow == true then
        button2:setText("View Main Button")
        mainButton:setVisible(false)
        toShow = false

    else
        button2:setText("Hide Main Button")
        mainButton:setVisible(true)
        toShow = true
    end
end

button2:setOnTouchUp(button2UP)
