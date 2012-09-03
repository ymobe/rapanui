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




--[[
	  
	  SCENES MUST HAVE 
	  1)a sceneGroup where all instances are inserted
	  2)onCreate function in which we create everything
	  3)onEnd function in which we clean the instance

]] --

aScene = {}

local sceneGroup = RNGroup:new()



--init Scene
function aScene.onCreate()
    --add things to sceneGroup
    local background = RNFactory.createImage("images/background-blue.png", { parentGroup = sceneGroup }); background.x = 160; background.y = 240;
    local text1 = RNFactory.createText("This is the scene three.", { size = 16, top = 150, left = 50, width = 200, height = 500 })
    sceneGroup:insert(text1)
    local button1 = RNFactory.createAnim("images/sceneButtons.png", 128, 64)
    button1.frame = 1
    sceneGroup:insert(button1)
    button1.x = 100; button1.y = 100



    button1:setOnTouchDown(button1Down)


    button1:setOnTouchUp(button1Up)


    --return sceneGroup
    return sceneGroup
end

function button1Down(event)
    event.target.frame = 2
end

function button1Up(event)
    event.target.frame = 1
    director:showScene("rapanui-samples/menu/scene1m", "slidetobottom")
end



function aScene.onEnd()
    sceneGroup:remove()
end

return aScene



