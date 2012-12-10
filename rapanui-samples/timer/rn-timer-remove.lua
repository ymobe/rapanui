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

times = 0
local background = RNFactory.createImage("images/background-purple.png")

text = RNFactory.createText("Times 0", { size = 20, top = 180, left = 50, width = 200, height = 50 })
textinfo = RNFactory.createText("Touch button1 to remove/add timer", { size = 16, top = 10, left = 5, width = 300, height = 50 })

counting = true

local function count()
    times = times + 1

    text:setText("Times " .. times)

    if times == 100 then
        times = 0
    end
end

actionId = RNMainThread.addTimedAction(0.5, count)

function button1UP(event)
    if counting then
        RNMainThread.removeAction(actionId)
        print("removing", actionId)
        counting = false
    else
        actionId = RNMainThread.addTimedAction(0.5, count)
        print("adding", actionId)
        counting = true
    end
end


buttonOne = RNFactory.createImage("images/tile1.png", { top = 50, left = 120 })
buttonOne:setOnTouchUp(button1UP)


