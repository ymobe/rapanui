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
--]]
local background = RNFactory.createImage("images/background-blue.png")

text = RNFactory.createText("Touch on buttons", { size = 9, top = 200, left = 5, width = 250, height = 50 })


for i = 0, 1000 do

    button = RNFactory.createButton("images/button-plain.png", { text = "Button 1", top = 130, left = 10, size = 10, width = 200, height = 50 })

    local function button1TouchDown(event)
        text:setText("Button touch down!")
    end

    local function button1UP(event)
        text:setText("Button touch up")
    end

    button:setOnTouchDown(button1TouchDown)
    button:setOnTouchUp(button1UP)

    memestatus(true)
    button:remove()
    button = nil
    collectgarbage("collect")
end

print("End")
memestatus(true)