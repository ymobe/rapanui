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

back = RNFactory.createImage("images/background-blue.png")
back:sendToBottom()

one = RNFactory.createImage("images/tile1.png")
one.x, one.y = 50,200
two = RNFactory.createImage("images/tile2.png")
two.x, two.y = 250,200

function onefunction(e)
	one.x, one.y = e.x, e.y
end

function twofunction(e)
	if e.phase == "began" then
		RNInputManager:setFocus(two) --set's focus. Can not 'lose' if move mouse too fast
	elseif e.phase == "ended" then
		RNInputManager:setFocus() --removes focus
	end
	two.x, two.y = e.x, e.y
end

one:addEventListener("touch", onefunction)
two:addEventListener("touch", twofunction)