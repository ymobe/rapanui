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
	background = RNFactory.createImage("images/background-blue.png");background.x=160;background.y=240;
	tile1a = RNFactory.createImage("images/tile3.png");tile1a.x=100;tile1a.y=340;
	tile1b = RNFactory.createImage("images/tile3.png");tile1b.x=100;tile1b.y=240;
	tile1c = RNFactory.createImage("images/tile3.png");tile1c.x=260;tile1c.y=140;
	mainGroup:insert(background)
	mainGroup:insert(tile1a)
	mainGroup:insert(tile1b)
	mainGroup:insert(tile1c)
	--return mainGroup	
	return mainGroup	
end



function onEnd()
	for i=1,table.getn(mainGroup.displayObjects),1 do
		mainGroup.displayObjects[1]:remove();
	end
end



