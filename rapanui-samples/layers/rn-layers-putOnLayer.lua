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

-- you may want to load objects first and put them on layer later.

-- variables to make our work easier
local screen = RNFactory.screen
local layers = screen.layers
local mainlayer = layers:get(RNFactory.MAIN_LAYER)

--create images
local image1 = RNFactory.loadImage("images/image.png")
image1.x = 30
local image2 = RNFactory.loadImage("images/image2.png")
image2.x = 90

--put them on screen
screen:putOnLayer(image1)
--or put them in a specified layer
screen:putOnLayer(image2, mainlayer)

--we can also remove them from layer
--uncomment to check:
--[[
screen:removeFromLayer(image1)
screen:removeFromLayer(image2, mainlayer)
]] --


--this is the same for
--TEXTS:
local text1 = RNFactory.loadText("Hello world!", { size = 25, top = 5, left = 5, width = 200, height = 50 })
screen:putOnLayer(text1)

--BUTTONS:
local button = RNFactory.loadButton("images/button-plain.png", {
    text = "Main Button 1",
    imageOver = "images/button-over.png",
    top = 50,
    left = 10,
    size = 16,
    width = 200,
    height = 50,
    onTouchDown = button1TouchDown,
    onTouchUp = button1UP,
    font = "arial-rounded.TTF"
})
screen:putOnLayer(button)


--or
--GROUPS

local group = RNGroup:new()
local image3 = RNFactory.loadImage("images/image3.png")
image3.y = 200
local image4 = RNFactory.loadImage("images/image4.png")
image4.y = 300

group:insert(image3)
group:insert(image4)

screen:putOnLayer(group)

