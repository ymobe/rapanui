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
module(..., package.seeall)

require("RNInputManager")
require("RNObject")
require("RNRectangle")
require("RNText")
require("RNGroup")
require("RNScreen")
require("RNUtil")
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

screen = RNScreen:new()

groups = {}
groups_size = 0

mainGroup = RNGroup:new()



stageWidth = 0
stageHeight = 0

function init(width, height, name)

    if name == nil then
        name = "mainwindow"
    end

    --  width, height from the SDConfig.lua

    MOAISim.openWindow(name, width, height) --960-by-640
    screen:initWith(width, height)

    stageWidth = width
    stageHeight = height

    contentWidth = width
    contentHeight = height


    RNInputManager.setGlobalRNScreen(screen)
end

-- extra method call to setup the underlying system
init(config.width, config.height)

function showDebugLines()
    MOAIDebugLines.setStyle(MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1)
    MOAIDebugLines.setStyle(MOAIDebugLines.PROP_WORLD_BOUNDS, 2, 0.75, 0.75, 0.75)
end

function getCurrentScreen()
    return screen
end


function createImage(filename, params)

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
            parentGroup = mainGroup
        end
    end

    if (parentGroup == nil) then
        parentGroup = mainGroup
    end


    local image = RNObject:new()
    image:initWith(filename)
    screen:addRNObject(image)
    image.x = image.originalWidth / 2 + left
    image.y = image.originalHeight / 2 + top

    if parentGroup ~= nil then
        parentGroup:insert(image)
    end

    return image
end

function createImageFromMoaiImage(moaiImage, params)

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
            parentGroup = mainGroup
        end
    end

    if (parentGroup == nil) then
        parentGroup = mainGroup
    end


    local image = RNObject:new()
    image:initWithMoaiImage(moaiImage)
    screen:addRNObject(image)
    image.x = image.originalWidth / 2 + left
    image.y = image.originalHeight / 2 + top

    if parentGroup ~= nil then
        parentGroup:insert(image)
    end


    return image
end

function createMoaiImage(filename)
    local image = MOAIImage.new()
    image:load(filename, MOAIImage.TRUECOLOR + MOAIImage.PREMULTIPLY_ALPHA)
    return image
end

function createBlankMoaiImage(width, height)
    local image = MOAIImage.new()
    image:init(width, height)
    return image
end

function createCopyRect(moaiimage, params)

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
            parentGroup = mainGroup
        end
    end

    if (parentGroup == nil) then
        parentGroup = mainGroup
    end


    local image = RNObject:new()
    image:initCopyRect(moaiimage, params)
    screen:addRNObject(image)
    image.x = image.originalWidth / 2 + left
    image.y = image.originalHeight / 2 + top

    if parentGroup ~= nil then
        parentGroup:insert(image)
    end


    return image
end

function createAnim(filename, sx, sy, left, top, scaleX, scaleY)

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

    local parentGroup = mainGroup

    local image = RNObject:new()
    image:initAnimWith(filename, sx, sy, scaleX, scaleY)
    screen:addRNObject(image)
    image.x = image.originalWidth / 2 + left
    image.y = image.originalHeight / 2 + top

    if parentGroup ~= nil then
        parentGroup:insert(image)
    end

    return image
end

function createText(text, params)

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
    screen:addRNObject(RNText)
    mainGroup:insert(RNText)
    return RNText
end

function createRect(x, y, width, height, params)
    local parentGroup, top, left
    local rgb = { 225, 225, 225 }

    if params then
        parentGroup = params.parentGroup or mainGroups
        rgb = params.rgb or rgb
    end

    local shape = RNObject:new()
    shape:initWithRect(width, height, rgb)
    screen:addRNObject(shape)
    shape.x = shape.originalWidth * .5 + x
    shape.y = shape.originalHeight * .5 + y
    shape.rotation = 0

    if parentGroup ~= nil then
        parentGroup:insert(shape)
    end
    return shape
end

function createCircle(x, y, r, params)
    local parentGroup, top, left
    local rgb = { 225, 225, 225 }

    if params then
        if type(params) == "table" then
            parentGroup = params.parentGroup or mainGroups
            top = params.top or 0
            left = params.left or 0
            rgb = params.rgb or rgb
        end
    end

    local shape = RNObject:new()
    shape:initWithCircle(x, y, r, rgb)
    screen:addRNObject(shape)
    shape.x = x
    shape.y = y
    shape.rotation = 0

    if parentGroup ~= nil then
        parentGroup:insert(shape)
    end
    return shape
end