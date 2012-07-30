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

function button1TouchDown(event)
    text:setText("Button 1 touch down!")
end

function button1UP(event)
    text:setText("Button 1 touch up")
end

button = RNFactory.createButton("images/button-plain.png", {
    text = "Main Button 1",
    imageOver = "images/button-over.png",
    top = 50,
    left = 10,
    size = 8,
    width = 200,
    height = 50,
    onTouchDown = button1TouchDown,
    onTouchUp = button1UP ,
    font="arial-rounded.TTF"
})

-- second button to show different text alignments

button2 = RNFactory.createButton("images/button-plain.png", {
    text = "Text alignment Button 2",
    top = 150,
    left = 10,
    size = 8,
    width = 200,
    height = 50,
    verticalAlignment = MOAITextBox.LEFT_JUSTIFY,
    horizontalAlignment = MOAITextBox.LEFT_JUSTIFY
})

button3 = RNFactory.createButton("images/button-plain.png", {
    text = "No call back",
    imageOver = "images/button-over.png",
    top = 250,
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


button4 = RNFactory.createButton("images/button-plain.png", {
    imageOver = "images/button-over.png",
    top = 350,
    left = 10,
    size = 8,
    width = 200,
    height = 50,
    onTouchDown = button4TouchDown,
    onTouchUp = button4UP
})



text = RNFactory.createText("Touch on buttons 1", { size = 9, top = 400, left = 5, width = 250, height = 50 })



function button2TouchDown(event)
    text:setText("Button 2 touch down!")
end

function button2UP(event)
    text:setText("Button 2 touch up")
end



button2:setOnTouchDown(button2TouchDown)
button2:setOnTouchUp(button2UP)