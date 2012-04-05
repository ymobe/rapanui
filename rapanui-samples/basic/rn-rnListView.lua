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
local image1 = RNFactory.createImage("images/image.png")
local image2 = RNFactory.createImage("images/image2.png")
local image3 = RNFactory.createImage("images/image3.png")
local image4 = RNFactory.createImage("images/image4.png")
local image5 = RNFactory.createImage("images/tile0.png")
local image6 = RNFactory.createImage("images/tile1.png")
local image7 = RNFactory.createImage("images/tile2.png")
local image8 = RNFactory.createImage("images/tile3.png")
local image9 = RNFactory.createImage("images/tile4.png")
local anim1 = RNFactory.createAnim("images/char.png", 42, 32, 100, 200, 0.27, 0.5); anim1:play("default", 12, -1)
local text1 = RNFactory.createText("RapaNui is great!", { size = 10, top = 5, left = 5, width = 200, height = 50 })
local text2 = RNFactory.createText("Moai is great!", { size = 10, top = 5, left = 5, width = 200, height = 50 })

--callback for touch
function getCallBack(event)
    for i, v in pairs(event) do print(i, v, v.object.name, v.userValue, v.userValue2) end
end

--create the list
--field in options are optional
--x,y and canScrollY are optional
--offsetX,offsetY and onClick are optional
--you can set as many userValues as needed. They all will be received in the callBack funcion
-- (call them as you want all the touched elements is passed to that funcion)

--cellW and cellH are really important:
--1) cells are the things returning the callback
--2) the list is created cell by cell. So the cellH is quite important defining objects vertical distances and
--   list height.

--cells cannot be moved by offsets. Offsets only affect objects in cells. Cells are always created one below the other.

--maxScrollingForceY,minY and maxY affect directly the scrolling gesture.

local list = RNFactory.createList("testList", {
    options = { cellH = 64, cellW = 64, maxScrollingForceY = 30, minY = -64 * 4 - 32, maxY = 0 },
    canScrollY = true,
    x = 0,
    y = 0,
    elements = {
        { object = image1, offsetX = 32, offsetY = 32, onClick = getCallBack, userValue = "test", userValue2 = "test2" },
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
    },
})


--WORKING CALLS AND METHODS:

--list.x=0
--list.y=0
--list.alpha=0
--list.visible=false
--list:remove()