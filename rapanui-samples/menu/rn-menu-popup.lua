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

local isShown = false


--add things to sceneGroup
local background = RNFactory.createImage("images/background-purple.png", { parentGroup = sceneGroup }); background.x = 160; background.y = 240;
local text1 = RNFactory.createText("Touch the button to show popup!", { size = 10, top = 200, left = 50, width = 200, height = 500 })
local button1 = RNFactory.createAnim("images/rapanui_circles.png", 64, 64, 100, 200, 1, 1) button1.frame = 1
button1.x = 200; button1.y = 100


local popup = require("rapanui-samples/menu/popup")


function showPopup()
    popup.onShow()
end

function hidePopup()
    popup.onHide()
end




function b1touchdown(event)
    event.target.frame = 5
end


button1:setOnTouchDown(b1touchdown)

function b1touchup(event)
    event.target.frame = 1
    if popup.isTransitioning == false then
        if isShown == false then
            showPopup()
            isShown = true
        else
            hidePopup()
            isShown = false
        end
    end
end


button1:setOnTouchUp(b1touchup)