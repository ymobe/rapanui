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

text = RNFactory.createText("Touch on buttons", { size = 9, top = 400, left = 5, width = 250, height = 50 })


back = RNFactory.createImage("images/background-purple.png")
back:sendToBottom()

local w, h = RNFactory.stageWidth, RNFactory.stageHeight


anImage = RNFactory.createImage("images/tile1.png", { top = 130, left = 130 })

anImage.name = "DEMO!"


function button1TouchDown(event)
    print("Button one touch down!")
end

function button1Moved(event)
    print("Button one moved")
end

function button1Cancelled(event)
    print("Button one cancelled")
end

anImage:setOnTouchDown(button1TouchDown)
anImage:setOnTouchMove(button1Moved)
anImage:setOnTouchUp(button1Cancelled)

--RNInputManager.addListenerToEvent("touch", anImage.onTouchDown, anImage)


--function onTouchEvent(event)


--    if event.targetProp ~= nil then
--       print("found prop under touch")
--    else
--      text:setText("No button on x: " .. event.x .. " y: " .. event.y)
--    end
--end

--RNListeners:addEventListener("touch", onTouchEvent)
