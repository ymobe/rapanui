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

sprite1 = RNFactory.createImage("images/tile1.png")

back = RNFactory.createImage("images/background-purple.png")
back:sendToBottom()

local w, h = RNFactory.stageWidth, RNFactory.stageHeight

function onTouchEvent(event)
    if event.phase == "began" then
        sprite1.x = event.x
        sprite1.y = event.y
    end

    if event.phase == "moved" then
        sprite1.x = event.x
        sprite1.y = event.y
    end
end

local listenerId = RNListeners:addEventListener("touch", onTouchEvent)
print("Listener ID", listenerId)
