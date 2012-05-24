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


popup = { isTransitioning = false }

local trn = RNTransition:new()
local trn = RNTransition:new()



function popup.onShow()
    local background = RNFactory.createImage("images/background-blue.png", { parentGroup = sceneGroup }); background.x = 160; background.y = 720;
    local text1 = RNFactory.createText("Hey there,\n I'm a popup!\n\nPlay with me!", { size = 10, top = 480, left = 0, width = 200, height = 500 })
    trn:run(background, { type = "move", time = 1000, y = 440, onComplete = showThings })
    trn:run(text1, { type = "move", time = 1000, y = 200 })
    popup.group = {}
    popup.group[1] = background
    popup.group[2] = text1
    popup.isTransitioning = true
end

function showThings()
    popup.isTransitioning = false
end

function removeThings()
    popup.isTransitioning = false
    popup.group[1]:remove()
    popup.group[2]:remove()
end


function popup.onHide()
    trn:run(popup.group[1], { type = "move", time = 1000, y = 720, onComplete = removeThings })
    trn:run(popup.group[2], { type = "move", time = 1000, y = 480 })
    popup.isTransitioning = true
end



return popup