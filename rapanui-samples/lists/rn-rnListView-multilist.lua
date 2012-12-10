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

--welcome to RNLists sample!
--RNLists are a sequence of vertical cells in which you can insert any of the RNObject.

--NOTE1: at the moment the scrolling gesture is only vertical.
--NOTE2: the touch is got when a cell is touched, not when the object is.
--NOTE3: since RapaNui touch listener doesn't return the target as the enterFrame does,
--       we need to specify SELF in RNListView.lua, and due to this fact
--       only one RNList at once can be created.

--object creation
local image2 = RNFactory.createImage("images/image2.png")
local image3 = RNFactory.createImage("images/image3.png")
local image4 = RNFactory.createImage("images/image4.png")
local image5 = RNFactory.createImage("images/tile0.png")
local image6 = RNFactory.createImage("images/tile1.png")
local image7 = RNFactory.createImage("images/tile2.png")
local image8 = RNFactory.createImage("images/tile3.png")
local image9 = RNFactory.createImage("images/tile4.png")
local anim1 = RNFactory.createAnim("images/char.png", 42, 32, 100, 200, 1, 2); anim1:play("default", 12, -1)
local text1 = RNFactory.createText("RapaNui is great!", { size = 20, top = 5, left = 5, width = 200, height = 50 })
local text2 = RNFactory.createText("Moai is great!", { size = 20, top = 5, left = 5, width = 200, height = 50 })





-- also maps can be added!
-- maps can be inserted as normal objects, or as child of groups in list. (as in rn-rnPageSwipe)

local mapOne = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/groups/mapone.tmx")
local aTileset = mapOne:getTileset(0)
aTileset:updateImageSource("rapanui-samples/groups/tilesetdemo.png")
mapOne:drawMapAt(0, 0, aTileset)


-- also buttons can be added!
-- buttons can be inserted as normal objects, or as child of groups in list. (as in rn-rnPageSwipe)

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


-- also groups and nested groups can be used as objects in lists

local image1a = RNFactory.createImage("images/image.png")
local image1b = RNFactory.createImage("images/image.png")
local image1c = RNFactory.createImage("images/image.png")

local group1 = RNGroup:new()
local group2 = RNGroup:new()

group1:insert(group2)

group1:insert(image1a, true)
group2:insert(image1b, true)
group2:insert(image1c, true)

image1b.x = 40
image1c.x = 80


local list = RNFactory.createList("testList", {
    options = { checkElements = false, topLimit = -100, bottomLimit = 480 + 100, timestep = 1 / 60, cellH = 64, cellW = 64, maxScrollingForceY = 30, minY = -64 * 4 - 32, maxY = 0, touchStartX = 160, touchStartY = 0, touchW = 160, touchH = 480 }, --minY=-64*6 means it can move down 6 cells since they are 64 in height
    canScrollY = true,
    x = 160,
    y = 0,
    elements = {
        { object = group1, offsetX = 32, offsetY = 32, userValue = "test", userValue2 = "test2" },
        { object = image2, offsetX = 64, offsetY = 32 },
        { object = anim1, offsetX = 32, offsetY = 32, userValue = "this is the anim 1" },
        { object = text1, offsetX = 0, offsetY = 0, userValue = "this is the text 1" },
        { object = image3, offsetX = 32, offsetY = 32 },
        { object = image4, offsetX = 64, offsetY = 32 },
        { object = text2, offsetX = 0, offsetY = 0, userValue = "this is the text 2" },
    },
})



local list2 = RNFactory.createList("testList2", {
    options = { checkElements = false, topLimit = -100, bottomLimit = 480 + 100, timestep = 1 / 60, cellH = 64, cellW = 64, maxScrollingForceY = 30, minY = -64 * 4 - 32, maxY = 0, touchStartX = 0, touchStartY = 0, touchW = 160, touchH = 480 }, --minY=-64*6 means it can move down 6 cells since they are 64 in height
    canScrollY = true,
    x = 0,
    y = 0,
    elements = {
        { object = image5, offsetX = 32, offsetY = 32 },
        { object = image6, offsetX = 32, offsetY = 32 },
        { object = image7, offsetX = 32, offsetY = 32 },
        { object = image8, offsetX = 32, offsetY = 32 },
        { object = image9, offsetX = 32, offsetY = 32 },
        { object = button, offsetX = 32, offsetY = 32 },
        { object = mapOne, offsetX = 32, offsetY = 32 },
    },
})
