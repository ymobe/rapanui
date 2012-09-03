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

text = RNFactory.createText("Touch and drag to update coords", { size = 18, top = 400, left = 5, width = 200, height = 50 })

coords = RNFactory.createText("0,0", { size = 18, top = 400, left = 150, width = 200, height = 50 })

textinfo = RNFactory.createText("Touch button1 to remove/add listener", { size = 16, top = 10, left = 5, width = 300, height = 50 })

buttonOne = RNFactory.createImage("images/tile1.png", { top = 60, left = 120 })


local w, h = RNFactory.stageWidth, RNFactory.stageHeight
local removed = false
listenerId = nil

function button1UP(event)
    if removed == false then
        text:setText("Removed listener: " .. listenerId)
        RNListeners:removeEventListener("touch", listenerId)
        removed = true
    else
        listenerId = RNListeners:addEventListener("touch", onTouchEvent)
        text:setText("Added listener: " .. listenerId)
        removed = false
    end
end

buttonOne:setOnTouchUp(button1UP)


function onTouchEvent(event)
    if event.phase == "moved" then
        coords:setText("" .. event.x .. ", " .. event.y)
    end
end

listenerId = RNListeners:addEventListener("touch", onTouchEvent)
print(listenerId)
