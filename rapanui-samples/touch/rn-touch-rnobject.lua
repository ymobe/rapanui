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

eventNumber = 0

text = RNFactory.createText("Touch on buttons", { size = 18, top = 200, left = 5, width = 250, height = 50 })

back = RNFactory.createImage("images/background-purple.png")
back:sendToBottom()

buttonOne = RNFactory.createImage("images/tile1.png", { top = 50, left = 50 })

function button1Touch(event)
    text:setText("Call back touch! " .. eventNumber)
    eventNumber = eventNumber + 1
    print(event.phase)
    print(event.target)
end


buttonOne:addEventListener("touch", button1Touch)