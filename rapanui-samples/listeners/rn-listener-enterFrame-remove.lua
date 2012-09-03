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

back = RNFactory.createImage("images/background-purple.png")
back:sendToBottom()


delta = -2

textinfo = RNFactory.createText("Touch button1 to remove/add listener and stop button2", { size = 16, top = 10, left = 5, width = 300, height = 50 })
text = RNFactory.createText("", { size = 18, top = 400, left = 5, width = 200, height = 50 })

buttonOne = RNFactory.createImage("images/tile1.png", { top = 60, left = 120 })
buttonTwo = RNFactory.createImage("images/tile2.png", { top = 220, left = 16 })


local w, h = RNFactory.stageWidth, RNFactory.stageHeight
local removed = false
listenerId = nil

function button1UP(event)
    if removed == false then
        text:setText("Removed listener: " .. listenerId)
        RNListeners:removeEventListener("enterFrame", listenerId)
        removed = true
    else
        listenerId = RNListeners:addEventListener("enterFrame", doIt)
        text:setText("Added listener: " .. listenerId)
        removed = false
    end
end

buttonOne:setOnTouchUp(button1UP)


--handling enterFrame
function doIt()
    if buttonTwo.x >= 320 then
        delta = -delta
    end

    if buttonTwo.x <= 0 then
        delta = -delta
    end

    buttonTwo.x = buttonTwo.x + delta
end

--set a listener for enterFrame
listenerId = RNListeners:addEventListener("enterFrame", doIt)
print("action", listenerId)
text:setText("Added listener: " .. listenerId)

--since enterFrame listener is handled inside a while = true cycle, use it carefully
--to save CPU usage. The use of timers (RNMainThread.addTimedAction(seconds, funct))
--is highly recommend, when possible.
