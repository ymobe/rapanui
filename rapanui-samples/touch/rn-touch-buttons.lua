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

text = RNFactory.createText("Touch on buttons", { size = 18, top = 200, left = 5, width = 250, height = 50 })

back = RNFactory.createImage("images/background-purple.png")
back:sendToBottom()

buttonOne = RNFactory.createImage("images/tile1.png", { top = 50, left = 50 })


buttonTwo = RNFactory.createImage("images/tile2.png", { top = 50, left = 150 })

buttonTwo.rotation = 30



function button1TouchDown(event)
    text:setText("Button one touch down!")
end

function button1Moved(event)
    text:setText("Button one moved!")
end

function button1UP(event)
    text:setText("Button one touch up")
end

buttonOne:setOnTouchDown(button1TouchDown)
buttonOne:setOnTouchMove(button1Moved)
buttonOne:setOnTouchUp(button1UP)


function button2TouchDown(event)
    text:setText("Button two touch down!")
end

function button2Moved(event)
    text:setText("Button two moved!")
end

function button2Up(event)
    text:setText("Button two touch up")
end

buttonTwo:setOnTouchDown(button2TouchDown)
buttonTwo:setOnTouchMove(button2Moved)
buttonTwo:setOnTouchUp(button2Up)