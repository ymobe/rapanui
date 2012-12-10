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


--RapaNui PageSwipe object sample

--RNPageSwipe is a simple object for handling object organization on screen. Change options to familiarize with features.


local image1 = RNFactory.createImage("images/tile1.png")
local image2 = RNFactory.createImage("images/tile2.png")
local image3 = RNFactory.createImage("images/tile3.png")
local image4 = RNFactory.createImage("images/tile4.png")
local image5 = RNFactory.createImage("images/tile5.png")
local image6 = RNFactory.createImage("images/tile6.png")
local image7 = RNFactory.createImage("images/tile7.png")
local image8 = RNFactory.createImage("images/tile8.png")
local image9 = RNFactory.createImage("images/tile9.png")
local image10 = RNFactory.createImage("images/tile0.png")
local image11 = RNFactory.createImage("images/tile1.png")
local image12 = RNFactory.createImage("images/tile2.png")
local image13 = RNFactory.createImage("images/tile3.png")
local image14 = RNFactory.createImage("images/tile4.png")
local image15 = RNFactory.createImage("images/tile5.png")
local image16 = RNFactory.createImage("images/tile6.png")
local image17 = RNFactory.createImage("images/tile7.png")
local image18 = RNFactory.createImage("images/tile8.png")
local image19 = RNFactory.createImage("images/tile9.png")

-- also groups or nested groups can be used as elements

local image1a = RNFactory.createImage("images/image.png")
local image1b = RNFactory.createImage("images/image.png")
local image1c = RNFactory.createImage("images/image.png")


-- also maps can be inserted!
-- to insert a map in a swipe object, add the map to a group , then insert the group.
-- it's the only way at the moment ;D

local mapOne = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/groups/mapone.tmx")
local aTileset = mapOne:getTileset(0)
aTileset:updateImageSource("rapanui-samples/groups/tilesetdemo.png")
mapOne:drawMapAt(0, 0, aTileset)



-- also buttons can be added!
-- to insert a button in a swipe object, add the button to a group , then insert the group.
-- it's the only way at the moment ;D

function button1TouchDown(event)
    event.target:setText("Button 1 touch down!")
end

function button1UP(event)
    event.target:setText("Button 1 touch up")
end

local button = RNFactory.createButton("images/button-plain.png", {
    text = "Main Button 1",
    imageOver = "images/button-over.png",
    size = 16,
    width = 200,
    height = 50,
    onTouchDown = button1TouchDown,
    onTouchUp = button1UP
})




local group1 = RNGroup:new()
local group2 = RNGroup:new()

group1:insert(group2)

group1:insert(image1a, true)
group2:insert(image1b, true)
group2:insert(image1c, true)
group2:insert(button)
group2:insert(mapOne)
image1b.x = 40
image1c.x = 80


local swipeObject = RNFactory.createPageSwipe("pageSwipe", {
    options = { touchLength = 100, mode = MOAIEaseType.LINEAR, rows = 2, columns = 3, offsetX = 50, offsetY = 100, dividerX = 20, dividerY = 10, cellW = 64, cellH = 64, pageW = 400, touchAreaStartingX = 0, touchAreaStartingY = 0, touchAreaW = 320, touchAreaH = 240, time = 500 },
    elements = {
        { object = group1, userData = "userdata test" },
        { object = image1, testField = "testdata" },
        { object = image2, name = "testName1" },
        { object = image3, name = "testName2" },
        { object = image4 },
        { object = image5 },
        { object = image6 },
        { object = image7 },
        { object = image8 },
        { object = image9 },
    },
})

local swipeObject2 = RNFactory.createPageSwipe("pageSwipe2", {
    options = { touchLength = 100, mode = MOAIEaseType.LINEAR, rows = 2, columns = 3, offsetX = 50, offsetY = 300, dividerX = 20, dividerY = 10, cellW = 64, cellH = 64, pageW = 400, touchAreaStartingX = 0, touchAreaStartingY = 240, touchAreaW = 320, touchAreaH = 240, time = 500 },
    elements = {
        { object = image10 },
        { object = image11 },
        { object = image12 },
        { object = image13 },
        { object = image14 },
        { object = image15 },
        { object = image16 },
        { object = image17 },
        { object = image18 },
        { object = image19 },
    },
})







