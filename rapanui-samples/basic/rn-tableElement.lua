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

--rapanui's tableElement sample. Enjoy the scrolling gesture


background = RNFactory.createImage("images/background-purple.png")
background:sendToBottom()

--function to receive callback to
function getCallBack(event)
    print(event.target, event.text)
end

--create a table of elements: name,style,elements
local tab = RNFactory.createTable("table1", {
    position = { x = 100, y = 0 },
    scrollingY = { active = true, minY = -50, maxY = 370, maxScrollingForceY = 100 },
    style = nil,
    elements = {
        { text = "Rapanui text  table test1", name = "label1", onClick = getCallBack },
        { text = "Rapanui text  table test2", name = "label2", onClick = getCallBack },
        { text = "Rapanui text  table test3", name = "label3", onClick = getCallBack },
        { text = "Rapanui text  table test4", name = "label4", onClick = getCallBack },
        { text = "Rapanui text  table test5", name = "label5", onClick = getCallBack },
    },
})

--this is for table removing
--tab:remove()

--move the tab
tab.x = 0
tab.y = 50

--scrolling property
tab.maxY = 370
tab.minY = -50
tab.canScrollY = true
tab.maxScrollingForceY = 30

--TO DO : setColor and other stuff like this.


--if style is nil a default style is created.
--style sample
--style = { size = 10, font = nil, top = 30, left = 0, width = 500, height = 500,alignment = MOAITextBox.LEFT_JUSTIFY }
--if font is nil, basic RapaNui font will be used

--At the moment you can create only one table at time


