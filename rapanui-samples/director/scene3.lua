------------------------------------------------------------------------------------------------------------------------
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
--
------------------------------------------------------------------------------------------------------------------------



module(..., package.seeall)
local l = require("localise")
--[[
	  
	  SCENES MUST HAVE 
	  1)a mainGroup where all instances are inserted
	  2)onCreate function in which we create everything
	  3)onEnd function in which we clean the instance

]]--


mainGroup=RNGroup:new()



--init Scene
function onCreate()
	--add things to mainGroup
	background = l.RNFactory.createImage("RN/images/background-blue.png",{parentGroup=mainGroup});background.x=160;background.y=240;
	tile1a = l.RNFactory.createImage("RN/images/tile3.png",{parentGroup=mainGroup});tile1a.x=160;tile1a.y=240;
	tile1b = l.RNFactory.createImage("RN/images/tile3.png",{parentGroup=mainGroup});tile1b.x=100;tile1b.y=140;
	tile1c = l.RNFactory.createImage("RN/images/tile3.png",{parentGroup=mainGroup});tile1c.x=260;tile1c.y=240;
	--retul.RN mainGroup	
	return mainGroup	
end



function onEnd()
	for i=1,table.getn(mainGroup.displayObjects),1 do
		mainGroup.displayObjects[1]:remove();
	end
end




