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



--simple demo, a little bit buggy to show how to create a dragable animated button
back = RNFactory.createImage("images/background-purple.png")
back:sendToBottom()

text = RNFactory.createText("Touch on button and drag it", { size = 18, top = 100, left = 5, width = 250, height = 50 })


--physical animation with many sequences
--newAnim(file,sizeX,sizeY[,posx,posy,scaleX,scaleY])
button1 = RNFactory.createAnim("images/rapanui_circles.png", 64, 64, 100, 200, 1, 1)
--newSequence(name,frameOrder,speed,repeatTimes,onStopFunction)
button1:newSequence("default", { 1, 2, 3, 4, 3, 2 }, 12, -1)
button1:newSequence("down", { 5, 6, 7, 8 }, 12, -1)
button1:newSequence("moved", { 9, 10, 11, 12, 11, 10 }, 12, -1)
button1:play("default")
--flag
isMoved = false



--handle local touch listeners
function button1TouchDown(event)
    text:setText("touch down")
    button1:play("down")
end

function button1Moved(event)
    text:setText("touch moved")
    if isMoved == false then
        button1:play("moved")
        isMoved = true
    else
        button1.x = event.x
        button1.y = event.y
    end
end

function button1UP(event)
    text:setText("touch up")
    button1:play("default")
    isMoved = false
end


--call listeners
button1:setOnTouchDown(button1TouchDown)
button1:setOnTouchMove(button1Moved)
button1:setOnTouchUp(button1UP)


