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


RNFactory = {}

require("config")

contentCenterX = nil
contentCenterY = nil
contentHeight = nil
contentWidth = nil
contentScaleX = nil
contentScaleY = nil
contentWidth = nil
screenOriginX = nil
screenOriginY = nil
statusBarHeight = nil
viewableContentHeight = nil
viewableContentWidth = nil
HiddenStatusBar = "HiddenStatusBar"
CenterReferencePoint = "CenterReferencePoint"


RNFactory.screen = RNScreen:new()

groups = {}
groups_size = 0

RNFactory.mainGroup = RNGroup:new()

RNFactory.stageWidth = 0
RNFactory.stageHeight = 0
RNFactory.width = 0
RNFactory.height = 0

function RNFactory.init()

    local lwidth, lheight, screenlwidth, screenHeight
    local screenX, screenY = MOAIEnvironment.getScreenSize()

    if screenX ~= 0 then --if physical screen
        lwidth, lheight, screenlwidth, screenHeight = screenX, screenY, screenX, screenY
    else
        lwidth, lheight, screenlwidth, screenHeight = config.sizes[config.device][1], config.sizes[config.device][2], config.sizes[config.device][3], config.sizes[config.device][4]
    end

    if config.landscape == true then -- flip lwidths and Hieghts
        lwidth, lheight = lheight, lwidth
        screenlwidth, screenHeight = screenHeight, screenlwidth
    end

    landscape, device, sizes, screenX, screenY = nil


    if name == nil then
        name = "mainwindow"
    end

    --  lwidth, lheight from the SDConfig.lua

    MOAISim.openWindow(name, screenlwidth, screenHeight)
    RNFactory.screen:initWith(lwidth, lheight, screenlwidth, screenHeight)

    RNFactory.width = lwidth
    RNFactory.height = lheight

    contentlwidth = lwidth
    contentHeight = lheight

    RNInputManager.setGlobalRNScreen(screen)
end

-- extra method call to setup the underlying system
RNFactory.init()

--- turns on debug lines
function RNFactory.showDebugLines()
    MOAIDebugLines.setStyle(MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1)
    MOAIDebugLines.setStyle(MOAIDebugLines.PROP_WORLD_BOUNDS, 2, 0.75, 0.75, 0.75)
end

function RNFactory.getCurrentScreen()
    return RNFactory.screen
end

--- creates an new RNObject image with given filename and params
-- @param filename string: the path of the file
-- @param params table: the table with the params for the image see below: <br>
-- {top=120} to set the distance from the top border of the screen<br>
-- {left=120} to set the distance from the left border of the screen <br>
-- {parentGroup=myGroup} to set the parent group of the new RNObject<br>
-- @usage anImage = RNFactory.createImage("images/image3.png", { top = 130, left = 130 })
function RNFactory.createImage(filename, params)

    local parentGroup, left, top

    top = 0
    left = 0

    if (params ~= nil) then
        if (params.top ~= nil) then
            top = params.top
        end

        if (params.left ~= nil) then
            left = params.left
        end

        if (params.parentGroup ~= nil) then
            parentGroup = params.parentGroup
        else
            parentGroup = RNFactory.mainGroup
        end
    end

    if (parentGroup == nil) then
        parentGroup = RNFactory.mainGroup
    end


    local image = RNObject:new()

    image:initWith(filename)

    RNFactory.screen:addRNObject(image)
    image.x = image.originalWidth / 2 + left
    image.y = image.originalHeight / 2 + top

    if parentGroup ~= nil then
        parentGroup:insert(image)
    end

    return image
end

--- creates an new RNObject image with given MOAIImage and params
-- @param filename string: the path of the file
-- @param params table: the table with the params for the image see below: <br>
-- {top=120} to set the distance from the top border of the screen<br>
-- {left=120} to set the distance from the left border of the screen <br>
-- {parentGroup=myGroup} to set the parent group of the new RNObject<br>
-- @see RNFactory.createMoaiImage
function RNFactory.createImageFromMoaiImage(moaiImage, params)

    local parentGroup, left, top

    top = 0
    left = 0

    if (params ~= nil) then
        if (params.top ~= nil) then
            top = params.top
        end

        if (params.left ~= nil) then
            left = params.left
        end

        if (params.parentGroup ~= nil) then
            parentGroup = params.parentGroup
        else
            parentGroup = RNFactory.mainGroup
        end
    end

    if (parentGroup == nil) then
        parentGroup = RNFactory.mainGroup
    end


    local image = RNObject:new()
    image:initWithMoaiImage(moaiImage)
    RNFactory.screen:addRNObject(image)
    image.x = image.originalWidth / 2 + left
    image.y = image.originalHeight / 2 + top

    if parentGroup ~= nil then
        parentGroup:insert(image)
    end


    return image
end

--- creates an new MOAIImage image from given filename
-- @param filename string: the path of the file
-- @return MOAIImage
function RNFactory.createMoaiImage(filename)
    local image = MOAIImage.new()
    image:load(filename, MOAIImage.TRUECOLOR + MOAIImage.PREMULTIPLY_ALPHA)
    return image
end

function RNFactory.createBlankMoaiImage(width, height)
    local image = MOAIImage.new()
    image:init(width, height)
    return image
end

--- creates an new RNObject image from given MOAIImage
-- @param moaiimage MOAIImage: the path of the file
-- @param params table: the table with the params for the image see below: <br>
-- {top=120} to set the distance from the top border of the screen<br>
-- {left=120} to set the distance from the left border of the screen <br>
-- {parentGroup=myGroup} to set the parent group of the new RNObject<br>
-- {srcXMin=10} source MOAIImage x start value<br>
-- {srcYMin=10} source MOAIImage y start value<br>
-- {srcXMax=10} source MOAIImage x end value<br>
-- {srcYMax=10} source MOAIImage y end value<br>
-- {destXMin=10} destination RNObject x start value<br>
-- {destYMin=10} destination RNObject y start value<br>
-- {destXMax=10} destination RNObject x end value<br>
-- {destYMax=10} destination RNObject y end value<br>
-- {filter} One of MOAIImage.FILTER_LINEAR, MOAIImage.FILTER_NEAREST<br>
-- @return MOAIImage
function RNFactory.createCopyRect(moaiimage, params)

    local parentGroup, left, top

    top = 0
    left = 0

    if (params ~= nil) then
        if (params.top ~= nil) then
            top = params.top
        end

        if (params.left ~= nil) then
            left = params.left
        end

        if (params.parentGroup ~= nil) then
            parentGroup = params.parentGroup
        else
            parentGroup = RNFactory.mainGroup
        end
    end

    if (parentGroup == nil) then
        parentGroup = RNFactory.mainGroup
    end


    local image = RNObject:new()
    image:initCopyRect(moaiimage, params)
    RNFactory.screen:addRNObject(image)
    image.x = image.originalWidth / 2 + left
    image.y = image.originalHeight / 2 + top

    if parentGroup ~= nil then
        parentGroup:insert(image)
    end


    return image
end


--- creates an new RNObject animation with given filename and params
-- @param filename string: the path of the file
-- @param sx number frame pixel width
-- @param sy number frame pixel height
-- @param left number: set the distance from the left border of the screen
-- @param top number : set the distance from the top border of the screen
-- @param scaleX number: the scale x for the animation
-- @param scaleY number: the scale y for the animation
-- @usage <code> liliaChar = RNFactory.createAnim("images/lilia.png", 32, 32, 140, 50, 1, 1) <br>         </code>
-- will place a RNObject animation at x:=140,x=50 with scale 1:1 and widht=32 and height=32
function RNFactory.createAnim(filename, sx, sy, left, top, scaleX, scaleY)

    if scaleX == nil then
        scaleX = 1
    end

    if scaleY == nil then
        scaleY = 1
    end

    if left == nil then
        left = 0
    end

    if top == nil then
        top = 0
    end

    local parentGroup = RNFactory.mainGroup

    local image = RNObject:new()
    image:initAnimWith(filename, sx, sy, scaleX, scaleY)
    RNFactory.screen:addRNObject(image)
    image.x = image.originalWidth / 2 + left
    image.y = image.originalHeight / 2 + top

    if parentGroup ~= nil then
        parentGroup:insert(image)
    end

    return image
end

--- creates an new RNText with given text and params
-- @param text string: the text to be shown
-- @param params table: the table with the params for the RNText see below: <br>
-- {top=120}<br>
-- {font="arial-rounded"}<br>
-- {left=120}<br>
-- {size=}<br>
-- {widht=}<br>
-- {height=}<br>
-- {alignment=}<br>
-- @usage text1 = RNFactory.createText("Hello world!", { size = 10, top = 5, left = 5, width = 200, height = 50 })
function RNFactory.createText(text, params)

    local top, left, size, font, height, width, alignment

    font = "arial-rounded"
    size = 15
    alignment = MOAITextBox.CENTER_JUSTIFY
    --LEFT_JUSTIFY, CENTER_JUSTIFY or RIGHT_JUSTIFY.

    if (params ~= nil) then
        if (params.top ~= nil) then
            top = params.top
        end

        if (params.left ~= nil) then
            left = params.left
        end

        if (params.font ~= nil) then
            font = params.font
        end

        if (params.size ~= nil) then
            size = params.size
        end

        if (params.height ~= nil) then
            height = params.height
        end

        if (params.width ~= nil) then
            width = params.width
        end

        if (params.alignment ~= nil) then
            alignment = params.alignment
        end
    end

    local RNText = RNText:new()
    RNText:initWithText(text, font, size, left, top, width, height, alignment)
    RNFactory.screen:addRNObject(RNText)
    RNFactory.mainGroup:insert(RNText)
    return RNText
end

--- creates an new RNObject rectangle shape
-- @param x
-- @param y
-- @param width
-- @param height
-- @param params
function RNFactory.createRect(x, y, width, height, params)
    local parentGroup, top, left
    local rgb = { 255, 255, 255 }

    if params then
        parentGroup = params.parentGroup or RNFactory.mainGroups
        rgb = params.rgb or rgb
    end

    local shape = RNObject:new()
    shape:initWithRect(width, height, rgb)
    RNFactory.screen:addRNObject(shape)
    shape.x = shape.originalWidth * .5 + x
    shape.y = shape.originalHeight * .5 + y
    shape.rotation = 0

    if parentGroup ~= nil then
        parentGroup:insert(shape)
    end
    return shape
end

--- creates an new RNObject circle shape
-- @param x
-- @param y
-- @param r
-- @param params
function RNFactory.createCircle(x, y, r, params)
    local parentGroup, top, left
    local rgb = { 255, 255, 255 }

    if params then
        if type(params) == "table" then
            parentGroup = params.parentGroup or RNFactory.mainGroups
            top = params.top or 0
            left = params.left or 0
            rgb = params.rgb or rgb
        end
    end

    local shape = RNObject:new()
    shape:initWithCircle(x, y, r, rgb)
    RNFactory.screen:addRNObject(shape)
    shape.x = x
    shape.y = y
    shape.rotation = 0

    if parentGroup ~= nil then
        parentGroup:insert(shape)
    end
    return shape
end

return RNFactory