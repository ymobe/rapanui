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
local style = { size = 10, font = font, top = 50, left = 0, width = 300, height = 48, alignment = MOAITextBox.LEFT_JUSTIFY }

tab = RNFactory.createTable("table1", {
    position = { x = 0, y = 0 },
    scrollingY = { active = true, minY = -50, maxY = 370, maxScrollingForceY = 100 },
    style = style,
    elements = {
        { text = "Testing item number 1", name = "label1", onClick = getCallBack },
        { text = "Testing item number 2", name = "label2", onClick = getCallBack },
        { text = "Testing item number 3", name = "label3", onClick = getCallBack },
        { text = "Testing item number 4", name = "label4", onClick = getCallBack },
        { text = "Testing item number 5", name = "label5", onClick = getCallBack },
        { text = "Testing item number 6", name = "label6", onClick = getCallBack },
        { text = "Testing item number 7", name = "label7", onClick = getCallBack },
        { text = "Testing item number 8", name = "label8", onClick = getCallBack },
        { text = "Testing item number 9", name = "label9", onClick = getCallBack },
        { text = "Testing item number 10", name = "label10", onClick = getCallBack },
        { text = "Testing item number 11", name = "label11", onClick = getCallBack },
        { text = "Testing item number 12", name = "label12", onClick = getCallBack },
        { text = "Testing item number 13", name = "label13", onClick = getCallBack },
        { text = "Testing item number 14", name = "label14", onClick = getCallBack },

    },
})
tab.x = 10
tab.y = 0
tab.maxY = 1
tab.minY = -210
tab.canScrollY = true
tab.maxScrollingForceY = 30


--this is for table removing
--tab:remove()


--TO DO : setColor and other stuff like this.


--if style is nil a default style is created.
--style sample
--style = { size = 10, font = nil, top = 30, left = 0, width = 500, height = 500,alignment = MOAITextBox.LEFT_JUSTIFY }
--if font is nil, basic RapaNui font will be used

--At the moment you can create only one table at time


