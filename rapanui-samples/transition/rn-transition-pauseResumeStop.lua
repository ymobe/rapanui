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

RNFactory.createText("Touch buttons to toggle\n or stop transition.\nStop will also call\n the onComplete callback", { size = 20, top = -100, left = 5, width = 340, height = 480, alignment = MOAITextBox.CENTER_JUSTIFY })


local image = RNFactory.createImage("images/image.png")
local transition = RNTransition:new()
local toggle = 0

local ACTION = transition:run(image, { type = "move", x = 500, y = 500, time = 10000, onComplete = onComplete })

function onComplete()
    print("Transition completed")
    ACTION = nil
end


function callbackStop(event)
    if event.phase == "began" then
        ACTION:stop()
    end
end

function callbackToggle(event)
    if event.phase == "began" then
        if toggle == 0 then
            ACTION:pause()
            toggle = 1
        else
            ACTION:start()
            toggle = 0
        end
    end
end



RNFactory.createButton("images/button-plain.png", {
    text = "Toggle",
    imageOver = "images/button-over.png",
    top = 300,
    left = 10,
    size = 16,
    width = 200,
    height = 50,
    onTouchDown = callbackToggle,
    font = "arial-rounded.TTF"
})


RNFactory.createButton("images/button-plain.png", {
    text = "Stop",
    imageOver = "images/button-over.png",
    top = 350,
    left = 10,
    size = 16,
    width = 200,
    height = 50,
    onTouchDown = callbackStop,
    font = "arial-rounded.TTF"
})

