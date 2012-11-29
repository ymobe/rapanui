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

--object creation
local image2 = RNFactory.createImage("images/image2.png")
local image3 = RNFactory.createImage("images/image3.png")
local image4 = RNFactory.createImage("images/image4.png")
local image5 = RNFactory.createImage("images/tile0.png")
local image6 = RNFactory.createImage("images/tile1.png")
local image7 = RNFactory.createImage("images/tile2.png")
local image8 = RNFactory.createImage("images/tile3.png")
local image9 = RNFactory.createImage("images/tile4.png")
local image10 = RNFactory.createImage("images/tile5.png")
local image11 = RNFactory.createImage("images/tile6.png")
local image12 = RNFactory.createImage("images/tile7.png")
local image13 = RNFactory.createImage("images/tile8.png")
local image14 = RNFactory.createImage("images/tile9.png")
local anim1 = RNFactory.createAnim("images/char.png", 42, 32, 100, 200, 1, 2); anim1:play("default", 12, -1)
local text1 = RNFactory.createText("RapaNui is great!", { size = 20, top = 5, left = 5, width = 200, height = 50 })
local text2 = RNFactory.createText("Moai is great!", { size = 20, top = 5, left = 5, width = 200, height = 50 })

-- Maps
local mapOne = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/groups/mapone.tmx")
local aTileset = mapOne:getTileset(0)
aTileset:updateImageSource("rapanui-samples/groups/tilesetdemo.png")
mapOne:drawMapAt(0, 0, aTileset)

-- Buttons
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

-- Groups
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

--callback for touch
function getCallBack(event, touchEvent)
    --touchEvent is the basic touch event
    print(touchEvent.x, touchEvent.y, touchEvent.id, touchEvent.tapCount)
    --event is the special one
    for i, v in pairs(event) do print(i, v, v.object.name, v.userValue, v.userValue2) end
end

local list = RNFactory.createList("testList", {
    options = { checkElements = false, topLimit = -100, bottomLimit = 480 + 100, timestep = 1 / 60, cellH = 64, cellW = 64, maxScrollingForceY = 30, minY = -64 * 8 - 32, maxY = 0, touchStartX = 0, touchStartY = 0, touchW = 320, touchH = 480 }, --minY=-64*6 means it can move down 6 cells since they are 64 in height
    canScrollY = true,
    x = 0,
    y = 0,
    elements = {
        { object = group1, offsetX = 32, offsetY = 32, onClick = getCallBack, userValue = "test", userValue2 = "test2" },
        { object = image2, offsetX = 64, offsetY = 32, onClick = getCallBack },
        { object = anim1, offsetX = 32, offsetY = 32, onClick = getCallBack, userValue = "this is the anim 1" },
        { object = text1, offsetX = 0, offsetY = 0, onClick = getCallBack, userValue = "this is the text 1" },
        { object = image3, offsetX = 32, offsetY = 32, onClick = getCallBack },
        { object = image4, offsetX = 64, offsetY = 32, onClick = getCallBack },
        { object = text2, offsetX = 0, offsetY = 0, onClick = getCallBack, userValue = "this is the text 2" },
        { object = image5, offsetX = 32, offsetY = 32, onClick = getCallBack },
        { object = image6, offsetX = 32, offsetY = 32, onClick = getCallBack },
        { object = image7, offsetX = 32, offsetY = 32, onClick = getCallBack },
        { object = image8, offsetX = 32, offsetY = 32, onClick = getCallBack },
        { object = image9, offsetX = 32, offsetY = 32, onClick = getCallBack },
        { object = button, offsetX = 32, offsetY = 32, onClick = getCallBack },
        { object = mapOne, offsetX = 32, offsetY = 32, onClick = getCallBack },--Not working
    },
})

list:insertElement({ object = image10, offsetX = 32, offsetY = 32, onClick = getCallBack }, 9999)
list:insertElement({ object = image11, offsetX = 32, offsetY = 32, onClick = getCallBack })
list:insertElement({ object = image12, offsetX = 32, offsetY = 32, onClick = getCallBack }, 9)

local scissorRect = MOAIScissorRect.new()
scissorRect:setRect( 50, 100, 350, 400)
list:setScissorRect(scissorRect)

--add elements tile8 and tile9 at the end
list:insertElement({ object = image13, offsetX = 32, offsetY = 32, onClick = getCallBack })
list:insertElement({ object = image14, offsetX = 32, offsetY = 32, onClick = getCallBack })
--swap tile8 and tile9 positions
list:swapElements(13, 14)
print_r(list.elements)

local function onListCallBack(phase)
    print(phase)
end

local regID = list:registerFunction(onListCallBack)