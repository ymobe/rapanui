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


local background = RNFactory.createImage("images/background-purple.png")

local text1 = RNFactory.createText("Hello world!\n this is a <style1>special</style1> text\n full of <style2>special</style2> features!\n Have fun!", { size = 25, top = 5, left = 5, width = 320, height = 480 })
text1:spool()
text1:highlight(6, 6, 0, 255, 255, 0.8)
text1:addStyle("style1", "dwarves.TTF", 30)
text1:addStyle("style2", "dwarves.TTF", 40, { 255, 255, 0, 100 })

print(text1.text)

--text1:remove()


