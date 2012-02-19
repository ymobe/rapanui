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

local background = RNFactory.createImage("images/background-blue.png")

local r, g, b = 0, 255, 0

background:sendToBottom()

rect = RNFactory.createRect(120, 120, 70, 50, { rgb = { 190, 120, 190 } })

rect.rotation = 23


--handling enterFrame
function changeColor()

    rect:setPenColor(r, g, b)

    if r < 255 then
        r, g, b = r + 1, g - 1, b + 1
    else
        r, g, b = 0, 255, 0
    end
end

--set a listener for enterFrame
listenerId = RNListeners:addEventListener("enterFrame", changeColor)
