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
RNFactory.mainGroup.name = "mainGroup"

RNFactory.stageWidth = 0
RNFactory.stageHeight = 0
RNFactory.width = 0
RNFactory.height = 0

function RNFactory.init()

    local lwidth, lheight, screenlwidth, screenHeight
    local screenX, screenY = MOAIEnvironment.screenWidth, MOAIEnvironment.screenHeight

    if screenX ~= nil then --if physical screen
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

    RNFactory.outWidth = RNFactory.width
    RNFactory.outHeight = RNFactory.height

    RNFactory.screenXOffset = 0
    RNFactory.screenYOffset = 0

    RNFactory.screenUnitsX = 0
    RNFactory.screenUnitsY = 0

    --if we have to stretch graphics to screen

    if config.stretch == true then
        local SCREEN_UNITS_X, SCREEN_UNITS_Y
        SCREEN_UNITS_X = config.graphicsDesign.w
        SCREEN_UNITS_Y = config.graphicsDesign.h

        local SCREEN_X_OFFSET = 0
        local SCREEN_Y_OFFSET = 0

        local DEVICE_WIDTH, DEVICE_HEIGHT, gameAspect, realAspect
        DEVICE_WIDTH, DEVICE_HEIGHT = RNFactory.width, RNFactory.height


        local gameAspect = SCREEN_UNITS_Y / SCREEN_UNITS_X
        local realAspect = DEVICE_HEIGHT / DEVICE_WIDTH


        local SCREEN_WIDTH, SCREEN_HEIGHT

        if realAspect > gameAspect then
            SCREEN_WIDTH = DEVICE_WIDTH
            SCREEN_HEIGHT = DEVICE_WIDTH * gameAspect
        else
            SCREEN_WIDTH = DEVICE_HEIGHT / gameAspect
            SCREEN_HEIGHT = DEVICE_HEIGHT
        end

        if SCREEN_WIDTH < DEVICE_WIDTH then
            SCREEN_X_OFFSET = (DEVICE_WIDTH - SCREEN_WIDTH) * 0.5
        end

        if SCREEN_HEIGHT < DEVICE_HEIGHT then
            SCREEN_Y_OFFSET = (DEVICE_HEIGHT - SCREEN_HEIGHT) * 0.5
        end

        RNFactory.screen.viewport:setSize(SCREEN_X_OFFSET, SCREEN_Y_OFFSET, SCREEN_X_OFFSET + SCREEN_WIDTH, SCREEN_Y_OFFSET + SCREEN_HEIGHT)
        RNFactory.screen.viewport:setScale(SCREEN_UNITS_X, -SCREEN_UNITS_Y)

        RNFactory.outWidth = config.graphicsDesign.w
        RNFactory.outHeight = config.graphicsDesign.h

        RNFactory.screenXOffset = SCREEN_X_OFFSET
        RNFactory.screenYOffset = SCREEN_Y_OFFSET

        RNFactory.screenUnitsX = SCREEN_UNITS_X
        RNFactory.screenUnitsY = SCREEN_UNITS_Y
    end



    RNInputManager.setGlobalRNScreen(screen)
end

-- extra method call to setup the underlying system
RNFactory.init()

function RNFactory.removeAsset(path)
    RNGraphicsManager:deallocateGfx(path)
end


function RNFactory.showDebugLines()
    MOAIDebugLines.setStyle(MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1)
    MOAIDebugLines.setStyle(MOAIDebugLines.PROP_WORLD_BOUNDS, 2, 0.75, 0.75, 0.75)
end

function RNFactory.getCurrentScreen()
    return RNFactory.screen
end



function RNFactory.createList(name, params)
    local list = RNListView:new()
    list.name = name
    list.options = params.options
    list.elements = params.elements
    list.x = params.x
    list.y = params.y
    if params.canScrollY ~= nil then list.canScrollY = params.canScrollY else list.canScrollY = true end
    list:init()
    return list
end

function RNFactory.createPageSwipe(name, params)
    local pSwipe = RNPageSwipe:new()
    pSwipe.options = params.options
    pSwipe.elements = params.elements
    pSwipe:init()
    return pSwipe
end

function RNFactory.createImage(image, params)

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


    local o = RNObject:new()
    local o, deck = o:initWithImage2(image)

    o.x = o.originalWidth / 2 + left
    o.y = o.originalHeight / 2 + top

    RNFactory.screen:addRNObject(o)

    if parentGroup ~= nil then
        parentGroup:insert(o)
    end


    return o, deck
end

function RNFactory.createButton(image, params)

    local parentGroup, left, top

    local top, left, size, font, vAlignment, hAlignment

    local xOffset, yOffset = 0, 0

    font = "arial-rounded.TTF"
    size = 15

    vAlignment = MOAITextBox.CENTER_JUSTIFY
    hAlignment = MOAITextBox.CENTER_JUSTIFY

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

        --[[
        if (params.height ~= nil) then
            height = params.height
        end

        if (params.width ~= nil) then
            width = params.width
        end
          ]] --

        if (params.verticalAlignment ~= nil) then
            vAlignment = params.verticalAlignment
        end

        if (params.horizontalAlignment ~= nil) then
            hAlignment = params.horizontalAlignment
        end
    end

    if (params.xOffset ~= nil) then
        xOffset = params.xOffset
    end

    if (params.yOffset ~= nil) then
        yOffset = params.yOffset
    end

    -- init of default RNButtonImage
    local rnButtonImage = RNObject:new()
    local rnButtonImage, deck = rnButtonImage:initWithImage2(image)

    rnButtonImage.x = rnButtonImage.originalWidth / 2 + left
    rnButtonImage.y = rnButtonImage.originalHeight / 2 + top

    RNFactory.screen:addRNObject(rnButtonImage)


    local rnButtonImageOver

    if params.imageOver ~= nil then

        rnButtonImageOver = RNObject:new()
        rnButtonImageOver, deck = rnButtonImageOver:initWithImage2(params.imageOver)

        rnButtonImageOver.x = rnButtonImageOver.originalWidth / 2 + left
        rnButtonImageOver.y = rnButtonImageOver.originalHeight / 2 + top

        rnButtonImageOver:setVisible(false)

        RNFactory.screen:addRNObject(rnButtonImageOver)
    end


    local rnButtonImageDisabled

    if params.imageDisabled ~= nil then

        rnButtonImageDisabled = RNObject:new()
        rnButtonImageDisabled, deck = rnButtonImageDisabled:initWithImage2(params.imageDisabled)

        rnButtonImageDisabled.x = rnButtonImageDisabled.originalWidth / 2 + left
        rnButtonImageDisabled.y = rnButtonImageDisabled.originalHeight / 2 + top

        rnButtonImageDisabled:setVisible(false)

        RNFactory.screen:addRNObject(rnButtonImageDisabled)
    end

    local rnText

    local gFont

    if params.text == nil then
        params.text = ""
    end

    rnText = RNText:new()
    rnText, gFont = rnText:initWithText2(params.text, font, size, rnButtonImage.originalWidth, rnButtonImage.originalHeight, vAlignment, hAlignment)

    RNFactory.screen:addRNObject(rnText)
    --     RNFactory.mainGroup:insert(rnText)
    rnText.x = left
    rnText.y = top




    local rnButton = RNButton:new()
    rnButton.xOffset = xOffset
    rnButton.yOffset = yOffset
    rnButton:initWith(rnButtonImage, rnButtonImageOver, rnButtonImageDisabled, rnText)


    if parentGroup ~= nil then
        parentGroup:insert(rnButton)
    end



    rnButton.x = rnButtonImage.originalWidth / 2 + left
    rnButton.y = rnButtonImage.originalHeight / 2 + top

    if params.onTouchUp ~= nil then
        rnButton:setOnTouchUp(params.onTouchUp)
    end

    if params.onTouchDown ~= nil then
        rnButton:setOnTouchDown(params.onTouchDown)
    end


    return rnButton, deck
end

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

function RNFactory.createAtlasFromTexturePacker(image, file)
    RNGraphicsManager:allocateTexturePackerAtlas(image, file)
end

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

function RNFactory.createAnim(image, sizex, sizey, left, top, scaleX, scaleY)

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


    local o = RNObject:new()
    local o, deck = o:initWithAnim2(image, sizex, sizey, scaleX, scaleY)

    o.x = left
    o.y = top

    local parentGroup = RNFactory.mainGroup

    RNFactory.screen:addRNObject(o)

    if parentGroup ~= nil then
        parentGroup:insert(o)
    end


    return o, deck
end


function RNFactory.createBitmapText(text, params)

    --[[ params.image
    params.charset
    params.top
    params.left
    params.letterWidth
    params.letterHeight
         ]]

    local charcodes, endsizex, sizey, sizex, left, top, scaleX, scaleY, charWidth, charHeight, image, parentGroup



    if params.image ~= nil then
        image = params.image
    end

    if params.charcodes ~= nil then
        charcodes = params.charcodes
    end

    if params.top ~= nil then
        top = params.top
    end

    if params.left ~= nil then
        left = params.left
    end

    if params.charWidth ~= nil then
        charWidth = params.charWidth
    end

    if params.charHeight ~= nil then
        charHeight = params.charHeight
    end

    if params.parentGroup ~= nil then
        parentGroup = params.parentGroup
    else
        parentGroup = RNFactory.mainGroup
    end

    local o = RNBitmapText:new()
    local o, deck = o:initWith(text, image, charcodes, charWidth, charHeight, top, left, hAlignment, vAlignment)

    o.x = left
    o.y = top



    parentGroup:insert(o)

    return o, deck
end

function RNFactory.createText(text, params)

    local top, left, size, font, height, width, alignment

    font = "arial-rounded.TTF"
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

    local rntext = RNText:new()
    local gFont

    rntext, gFont = rntext:initWithText2(text, font, size, width, height, alignment)
    RNFactory.screen:addRNObject(rntext)
    RNFactory.mainGroup:insert(rntext)

    rntext.x = left
    rntext.y = top

    return rntext, gFont
end


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