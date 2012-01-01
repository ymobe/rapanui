------------------------------------------------------------------------------------------------------------------------
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
--
------------------------------------------------------------------------------------------------------------------------

local M = {}

M.contentCenterX = nil
M.contentCenterY = nil
M.contentHeight = nil
M.contentWidth = nil
M.contentScaleX = nil
M.contentScaleY = nil
M.screenOriginX = nil
M.screenOriginY = nil
M.statusBarHeight = nil
M.viewableContentHeight = nil
M.viewableContentWidth = nil
M.HiddenStatusBar = "HiddenStatusBar"
M.CenterReferencePoint = "CenterReferencePoint"
M.stageWidth = 0
M.stageHeight = 0

local R
function M.init(PW, PH, SW, SH , name)
R = RN


	M.screen = R.Screen:new()

	M.groups = {}
	M.groups_size = 0
	-- extra method call to setup the underlying system

	mainGroup = R.Group:new()


    if name == nil then
        name = "mainwindow"
    end

    MOAISim.openWindow(name, SW, SH)
    M.screen:initWith(PW, PH, SW, SH )

	M.stageWidth = PW
	M.stageHeight = PH

    M.contentWidth = PW
    M.contentHeight = PH
	  
	R.InputManager.setGlobalRNScreen(M.screen)
	R.InputManager.init()
end

function M.showDebugLines()
    MOAIDebugLines.setStyle(MOAIDebugLines.PROPMODEL_BOUNDS, 2, 1, 1, 1)
    MOAIDebugLines.setStyle(MOAIDebugLines.PROP_WORLD_BOUNDS, 2, 0.75, 0.75, 0.75)
end

function M.createImage(filename, params)

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
		if (params.size ~= nil) then
            size = params.size
        end
    end

    if (parentGroup == nil) then
        parentGroup = mainGroup
    end


    local image = R.Object:new()
    image:initWith(filename,size)
    M.screen:addRNObject(image)
    image.x = image.originalWidth *.5 + left
    image.y = image.originalHeight *.5 + top

    if parentGroup ~= nil then
        parentGroup:insert(image)
    end

    return image
end

function M.createImageFromMoaiImage(moaiImage, params)

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


    local image = R.Object:new()
    image:initWithMoaiImage(moaiImage)
    M.screen:addRNObject(image)
    image.x = image.originalWidth *.5 + left
    image.y = image.originalHeight *.5 + top

    if parentGroup ~= nil then
        parentGroup:insert(image)
    end


    return image
end

function M.createMoaiImage(filename)
    local image = MOAIImage.new()
    image:load(filename, MOAIImage.TRUECOLOR + MOAIImage.PREMULTIPLY_ALPHA)
    return image
end

function M.createBlankMoaiImage(width, height)
    local image = MOAIImage.new()
    image:init(width, height)
    return image
end

function M.createCopyRect(moaiimage, params)

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


    local image = R.Object:new()
    image:initCopyRect(moaiimage, params)
    M.screen:addRNObject(image)
    image.x = image.originalWidth *.5 + left
    image.y = image.originalHeight *.5 + top

    if parentGroup ~= nil then
        parentGroup:insert(image)
    end


    return image
end

function M.createAnim(filename, sx, sy, left, top, scaleX, scaleY)

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

    local image = R.Object:new()
    image:initAnimWith(filename, sx, sy, scaleX, scaleY)
    M.screen:addRNObject(image)
    image.x = image.originalWidth *.5 + left
    image.y = image.originalHeight *.5 + top

    if parentGroup ~= nil then
        parentGroup:insert(image)
    end

    return image
end

function M.createText(text, params)

    local top, left, size, font, height, width, alignment

    font = "RN/arial-rounded"
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

    local RNText = R.Text:new()
    RNText:initWithText(text, font, size, left, top, width, height, alignment)
    M.screen:addRNObject(RNText)
    mainGroup:insert(RNText)
    return RNText
end

function M.newRect(x1,y1,x2,y2, params)
    local parentGroup, top, left = nil, x1,y1

    if params then
        if type(params) == "table" then
            parentGroup = params.parentGroup or mainGroups
            top = params.top or 0
            left = params.left or 0
        end
    end
	
	local shape = R.Object:new()
    shape:initWithRect(x1,y1,x2,y2)
    M.screen:addRNObject(shape)
    shape.x = shape.originalWidth *.5 + left
    shape.y = shape.originalHeight *.5 + top
    shape.rotation = 0
    
    if parentGroup ~= nil then
        parentGroup:insert(shape)
    end
    return shape
end

function M.newCircle(x,y,r, params)
    local parentGroup, top, left = nil, x,y

    if params then
        if type(params) == "table" then
            parentGroup = params.parentGroup or mainGroups
            top = params.top or 0
            left = params.left or 0
        end
    end
	
	local shape = R.Object:new()
    shape:initWithCircle(x,y,r)
    M.screen:addRNObject(shape)
    shape.x = shape.originalWidth *.5 + left
    shape.y = shape.originalHeight *.5 + top
    shape.rotation = 0
    
    if parentGroup ~= nil then
        parentGroup:insert(shape)
    end
    return shape
end



return M