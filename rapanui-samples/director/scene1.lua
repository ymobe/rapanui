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



module(..., package.seeall)

--[[
	  
	  SCENES MUST HAVE 
	  1)a sceneGroup where all instances are inserted
	  2)onCreate function in which we create everything
	  3)onEnd function in which we clean the instance

]] --


local sceneGroup = RNGroup:new()



--init Scene
function onCreate()
    --add things to sceneGroup
    local background = RNFactory.createImage("images/background-purple.png", { parentGroup = sceneGroup }); background.x = 160; background.y = 240;
    local tile1a = RNFactory.createImage("images/tile1.png", { parentGroup = sceneGroup }); tile1a.x = 160; tile1a.y = 240;
    local tile1b = RNFactory.createImage("images/tile1.png", { parentGroup = sceneGroup }); tile1b.x = 100; tile1b.y = 340;
    local tile1c = RNFactory.createImage("images/tile1.png", { parentGroup = sceneGroup }); tile1c.x = 260; tile1c.y = 240;
    --return sceneGroup
    return sceneGroup
end



function onEnd()
    for i = 1, table.getn(sceneGroup.displayObjects), 1 do
        sceneGroup.displayObjects[1]:remove();
    end
end



