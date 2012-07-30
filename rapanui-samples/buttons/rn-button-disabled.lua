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
local toDisable = true

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
    size = 8,
    width = 200,
    height = 50,
    onTouchDown = button1TouchDown,
    onTouchUp = button1UP,
    font = "arial-rounded.TTF"
})

-- second button to show different text alignments

button2 = RNFactory.createButton("images/button-plain.png", {
    text = "Disable Main Button",
    top = 150,
    left = 10,
    size = 8,
    width = 200,
    height = 50
})

function button4TouchDown(event)
    event.target:setText("Button 4 touched!")
end

function button4UP(event)
    event.target:setText("")
end


text = RNFactory.createText("Touch on buttons 1", { size = 9, top = 400, left = 5, width = 250, height = 50 })




function button2UP(event)
    if toDisable == true then
        text:setText("Disabled Main Button")
        mainButton:disable()
        toDisable = false

    else
        text:setText("Enabled Main Button")
        mainButton:enable()
        toDisable = true
    end
end

button2:setOnTouchUp(button2UP)
