------------------------------------------------------------------------------------------------------------------------
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
--
------------------------------------------------------------------------------------------------------------------------
local R = RN
sprite1 = R.Factory.createImage("RN/images/tile1.png")

back = R.Factory.createImage("RN/images/background-purple.png")
back:sendToBottom()

local w, h = R.Factory.stageWidth, R.Factory.stageHeight

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

 R.Listeners:addEventListener("touch", onTouchEvent)
