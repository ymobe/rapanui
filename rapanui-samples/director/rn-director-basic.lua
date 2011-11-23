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

--RNDirector test

background1 = RNFactory.createImage("images/background-purple.png")
background2 = RNFactory.createImage("images/background-green.png")
background3 = RNFactory.createImage("images/background-blue.png")

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


--add groups to director.
--automatically they will set to visible = false
director:addScene(group1)
director:addScene(group2)
director:addScene(group3)

--check if they are inside the director
for i,v in ipairs(director.scenes) do print(i,v.name) end

--show scene (name, effect)
director:showScene("group1","pop")
--hide scene (name,effect)
director:hideScene("group1","pop")


--show group2
director:showScene("group2","pop")
--change scene from group2 to group3 with the given effect (name1,name2,effect)
director:changeScene("group2","group3","pop")


--Set director's time
director:setTime(1000)


--pop group3
director:hideScene("group3","fade")
--fadeIn group1
director:showScene("group1","fade")


--change group1 to group2 with a fade
director:changeScene("group1","group2","fade")