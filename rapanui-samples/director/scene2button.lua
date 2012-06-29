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
    local background = RNFactory.createImage("images/background-green.png", { parentGroup = sceneGroup }); background.x = 160; background.y = 240;

    local tile1a = RNFactory.createImage("images/tile2.png", { parentGroup = sceneGroup }); tile1a.x = 160; tile1a.y = 240;

    local button2 = RNFactory.createButton("images/button-plain.png",

        {
            text = "Go back scene 1",
            parentGroup = sceneGroup,
            imageOver = "images/button-over.png",
            top = 50,
            left = 10,
            size = 8,
            width = 200,
            height = 50
        })


    button2:setOnTouchUp(buttonScene2Up)

    return sceneGroup
end


function buttonScene2Up(event)
    if not director:isTransitioning() then
        director:showScene("rapanui-samples/director/scene1button", "fade")
    end
end


function aScene.onEnd()
    for i = 1, table.getn(sceneGroup.displayObjects), 1 do
        sceneGroup.displayObjects[1]:remove();
    end
end


return aScene