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

background:sendToBottom()

rect = RNFactory.createRect(20, 50, 70, 50, { rgb = { 190, 120, 190 } })

rect.rotation = 30

circle = RNFactory.createCircle(0, 0, 30 ,{ rgb = { 100, 120, 100 } })

circle.x = 50
circle.y = 150
circle:setAlpha(0.5)
