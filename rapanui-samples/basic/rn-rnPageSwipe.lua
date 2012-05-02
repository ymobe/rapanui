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
--only one RNPageSwipe object can be created at time, at the moment


local image0 = RNFactory.createImage("images/tile0.png")
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
local image20 = RNFactory.createImage("images/image.png")
local image21 = RNFactory.createImage("images/image2.png")
local image22 = RNFactory.createImage("images/image3.png")
local image23 = RNFactory.createImage("images/image4.png")
local image24 = RNFactory.createImage("images/tile0.png")
local image25 = RNFactory.createImage("images/tile1.png")
local image26 = RNFactory.createImage("images/tile2.png")


local swipeObject = RNFactory.createPageSwipe("pageSwipe", {
    options = { rows = 2, columns = 3, offsetX = 50, offsetY = 100, dividerX = 20, dividerY = 10, cellW = 64, cellH = 64, pageH = 400, touchAreaStartingX = 0, touchAreaStartingY = 0, touchAreaW = 320, touchAreaH = 480, time = 500 },
    elements = {
        { object = image0, userData = "userdata test" },
        { object = image1, testField = "testdata" },
        { object = image2, name = "testName1" },
        { object = image3, name = "testName2" },
        { object = image4 },
        { object = image5 },
        { object = image6 },
        { object = image7 },
        { object = image8 },
        { object = image9 },
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

--accessible fields
-- you can access all fields specified in options and elements:
print(swipeObject.elements[1].userData)
print(swipeObject.options.cellH)
--plus:
print(swipeObject.pages)
print(swipeObject.currentPage)
print(swipeObject:getElementsInLastPage())


--you can change all the options and elements values from above at anytime.
swipeObject.elements[1].userData = "userdata test changed!"
print(swipeObject.elements[1].userData)
--just remember to call the arrange() function to make changes to the PageSwipe structure happen instantly
swipeObject.options.dividerY = 20
swipeObject:arrange()


--working methods
--swipeObject:setVisibility(false)
--swipeObject:setAlpha(0.5)
--print(swipeObject:getSize())
--swipeObject:remove()
--swipeObject:goToPage(2)


--advanced methods
--gets the element number 4 in the global list of elements (ignoring pages)
print(swipeObject:getElementByGlobalNumber(4).object.name)
--gets the element number 3 in page 2
print(swipeObject:getElementByPageAndNumber(2, 3).object.name)
--gets page, number in page and number ignoring pages for the given object
--in this case the 4th element in page 3 (global 16th element)
print(swipeObject:getPageAndNumberByElement(image15))
--gets the element by its name
print(swipeObject:getElementByName("testName1"))
--gets the swipe gesture state
print(swipeObject.isMoving)


--managing table methods
--insert an image at the end
swipeObject:insert({ object = image20 })
--insert an image at place 3
swipeObject:insert({ object = image21 }, 3)
--insert an image at place 12
swipeObject:insert({ object = image22 }, 12)
--insert an image at place 15
swipeObject:insert({ object = image23 }, 15)
--insert some images at place 15
swipeObject:insert({ object = image24 }, 15)
swipeObject:insert({ object = image25 }, 15)
swipeObject:insert({ object = image26 }, 15)
--remove last element (true specifies if the RNObject should be removed from screen)
swipeObject:removeElementByNumber(true)
--remove element at place 2
swipeObject:removeElementByNumber(true, 2)
--remove the element from pageSwipe then manually remove it from screen
local objectToRemove = swipeObject:getElementByPageAndNumber(5, 1).object
swipeObject:removeElementByNumber(false)
objectToRemove:remove()
--remove the element from page 1 at place 2
swipeObject:removeElementByPageAndNumber(true, 1, 2)
--swap between objects:
--by names
swipeObject:swapElementsByNames("testName1", "testName2")
--by global numbers
swipeObject:swapElementsByNumbers(1,2)
--by object instance
swipeObject:swapElementsByObjects(image0,image2)
--by pages and numbers (page1, number1, page2, number2)
swipeObject:swapElementsByPageAndNumber(2,2,2,6)



