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



--setting up director
director = RNDirector:new()


director:addScene("rapanui-samples/menu/scene1m")
director:addScene("rapanui-samples/menu/scene2m")
director:addScene("rapanui-samples/menu/scene3m")
director:addScene("rapanui-samples/menu/scene4m")

--show scene1m with fade in

director:showScene("rapanui-samples/menu/scene1m","fade")