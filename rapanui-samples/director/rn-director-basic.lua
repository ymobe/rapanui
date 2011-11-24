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

--RNDirector test , remove comments to test effects.

background1 = RNFactory.createImage("images/background-purple.png")
background2 = RNFactory.createImage("images/background-green.png")
background3 = RNFactory.createImage("images/background-blue.png")
tile1 = RNFactory.createImage("images/tile1.png");tile1.x=160;tile1.y=240;
tile2 = RNFactory.createImage("images/tile2.png");tile2.x=160;tile2.y=240;
tile3 = RNFactory.createImage("images/tile3.png");tile3.x=160;tile3.y=240;

director=RNDirector:new()

group1=RNGroup:new()
group2=RNGroup:new()
group3=RNGroup:new()

group1.name="group1"
group2.name="group2"
group3.name="group3"

group1:insert(background1)
group2:insert(background2)
group3:insert(background3)
group1:insert(tile1)
group2:insert(tile2)
group3:insert(tile3)

--add groups to director.
--automatically they will set to visible = false
director:addScene(group1)
director:addScene(group2)
director:addScene(group3)

--check if they are inside the director
for i,v in ipairs(director.scenes) do print(i,v.name) end


--Set director's time
director:setTime(1000)






--[[  POP TEST 

--show scene (name, effect)
director:showScene("group1","pop")
--hide scene (name,effect)
director:hideScene("group1","pop")

]]--







--[[ POP CHANGE TEST 

--show group2
director:showScene("group2","pop")
--change scene from group2 to group3 with the given effect (name1,name2,effect)
director:changeScene("group2","group3","pop")

]]--







--[[  FADE TEST
 
--fadeOut group3
director:hideScene("group3","fade")
--fadeIn group1
director:showScene("group1","fade")

]]--







--[[ SCALE IN TEST

--scaleIn group1
director:showScene("group1","scale")

]]--







--[[ SCALE OUT TEST
--pop group3
director:showScene("group3","pop")
--scaleOut group3
director:hideScene("group3","scale")

]]--






--[[ SCALE CHANGE TEST

--pop group2
director:showScene("group2","pop")
--scale change group2 with group1
director:changeScene("group2","group1","scale")


]]--







--[[ COMBO TEST

--Yes, you can perform combinations of effects
--pop group1
director:showScene("group1","pop")
--combination of scaleOut and FadeOut
director:hideScene("group1","fade")
director:hideScene("group1","scale")

]]--








--[[ COMBO TEST#2
--pop group2
director:showScene("group2","pop")
--combination of scale and fade during changeScene
director:changeScene("group2","group3","fade")
director:changeScene("group2","group3","scale")
]]--