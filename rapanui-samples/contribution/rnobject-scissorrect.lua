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

-- Blue background with scissorRect
local background = RNFactory.createImage("images/background-blue.png")
background:sendToBottom()
local scissorRect = MOAIScissorRect.new ()
scissorRect:setRect( 50, 50, 250, 250)
background:setScissorRect(scissorRect)

-- Circle using the same scissor rectangle as background
local circle = RNFactory.createCircle(250, 0, 125, { rgb = { 100, 120, 100 } })
circle:setScissorRect(scissorRect)

-- Circle with it's own scissor rectangle
local circle2 = RNFactory.createCircle(250, 250, 250, { rgb = { 100, 120, 100 } })
local scissorRect2 = MOAIScissorRect.new()
scissorRect2:setRect( 250, 250, 500, 500)
circle2:setScissorRect(scissorRect2)