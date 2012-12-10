--- This is the core object of the RapaNui framework. It wraps Moai props2d and chanche the UV maps so the orgin 0,0 of screen is on TOP LEFT
-- @author Stefano Linguerri
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
--
]]
require("rapanui-sdk/RNInputManager")

TOP_LEFT_MODE = 1
CENTERED_MODE = 2

RNObject = {}

local function fieldChangedListener(self, key, value)

    getmetatable(self).__object[key] = value
    self = getmetatable(self).__object

    if key ~= nil and key == "visible" then
        self:setVisible(value)
    end


    if key ~= nil and key == "isVisible" then
        self:setVisible(value)
    end

    if key ~= nil and key == "scaleX" then
        self:setScaleX(value)
    end
    if key ~= nil and key == "scaleY" then
        self:setScaleY(value)
    end

    if self.isAnim == true then

        if key ~= nil and key == "sizex" then
            self:setTileSizeX(value)
        end

        if key ~= nil and key == "sizey" then
            self:setTileSizeY(value)
        end
        if key ~= nil and key == "frame" then
            self.prop:setIndex(value)
        end
    end

    if self.isPhysical == false then

        if key ~= nil and key == "x" then
            local tmpX = self.currentRefX + value
            local tmpY = self.y

            if (self:getProp() ~= nil) then
                self:getProp():setLoc(tmpX, tmpY);
            end
        end

        if key ~= nil and key == "y" then
            local tmpX = self.x
            local tmpY = self.currentRefY + value

            if (self:getProp() ~= nil) then
                self:getProp():setLoc(tmpX, tmpY);
            end
        end

        if key ~= nil and key == "rotation" then
            self:getProp():setRot(value)
        end

        if key == "isFocus" and value == true then
            -- TODO: implement focus handling
        end
    end

    if self.isPhysical == true then
        if key ~= nil and key == "name" then
            self.physicObject.name = value
        end

        if key ~= nil and key == "rotation" then
            self.physicObject:setAngle(value)
        end

        if key ~= nil and key == "collision" then
            self.physicObject.collision = value
        end

        if key ~= nil and key == "x" then
            self.physicObject:setX(value)
        end

        if key ~= nil and key == "y" then
            self.physicObject:setY(value)
        end

        if key ~= nil and key == "awake" then
            self.physicObject:setAwake(value)
        end

        if key ~= nil and key == "active" then
            self.physicObject:setActive(value)
        end

        if key ~= nil and key == "bullet" then
            self.physicObject:setBullet(value)
        end

        if key ~= nil and key == "fixedRotation" then
            self.physicObject:setFixedRotation(value)
        end

        if key ~= nil and key == "angularVelocity" then
            self.physicObject:setAngularVelocity(value)
        end

        if key ~= nil and key == "angularDamping" then
            self.physicObject:setAngularDamping(value)
        end

        if key ~= nil and key == "linearVelocityX" then
            self.physicObject:setLinearVelocity(value, self.linearVelocityY)
        end

        if key ~= nil and key == "linearVelocityY" then
            self.physicObject:setLinearVelocity(self.linearVelocityX, value)
        end

        if key ~= nil and key == "linearDamping" then
            self.physicObject:setLinearDamping(value)
        end

        if key ~= nil and key == "isSensor" then
            self.physicObject:setSensor(value)
        end

        if key ~= nil and key == "isSleepingAllowed" then
            print("isSleepingAllowed not available at the moment")
        end
        if key ~= nil and key == "bodyType" then
            print("bodyType not available at the moment")
        end
        if key ~= nil and key == "restitution" then
            self:setAllFixture("restitution", value)
        end
        if key ~= nil and key == "friction" then
            self:setAllFixture("friction", value)
        end
        if key ~= nil and key == "density" then
            self:setAllFixture("density", value)
        end
        if key ~= nil and key == "filter" then
            self:setAllFixture("filter", value)
        end
        if key ~= nil and key == "sensor" then
            self:setAllFixture("sensor", value)
        end
    end
end


local function fieldAccessListener(self, key)

    local object = getmetatable(self).__object


    if key ~= nil and key == "isVisible" then
        object.isVisible = object.visible
    end

    if object.isAnim == true then

        if key ~= nil and key == "frame" then
            object.frame = object.prop:getIndex()
        end
    end

    if object.isPhysical == false then

        if key ~= nil and key == "x" then
            local xx, yy = object:getProp():getLoc()
            object.x = xx
            object.y = yy
        end

        if key ~= nil and key == "y" then
            local xx, yy = object:getProp():getLoc()
            object.x = xx
            object.y = yy
        end

        if key ~= nil and key == "rotation" then
            object.rotation = object:getProp():getRot()
        end
    end

    if object.isPhysical == true then

        if key ~= nil and key == "rotation" then
            object.rotation = object.physicObject:getAngle()
        end


        if key ~= nil and key == "x" then
            object.x = object.physicObject:getX()
        end

        if key ~= nil and key == "y" then
            object.y = object.physicObject:getY()
        end

        if key ~= nil and key == "collision" then
            object.collision = object.physicObject.collision
        end


        if key ~= nil and key == "isAwake" then
            object.isAwake = object.physicObject:isAwake()
        end

        if key ~= nil and key == "isBodyActive" then
            object.isActive = object.physicObject:isActive()
        end

        if key ~= nil and key == "isBullet" then
            object.isBullet = object.physicObject:isBullet()
        end

        if key ~= nil and key == "isFixedRotation" then
            object.isFixedRotation = object.physicObject:isFixedRotation()
        end

        if key ~= nil and key == "angularVelocity" then
            object.angularVelocity = object.physicObject:getAngularVelocity()
        end

        if key ~= nil and key == "angularDamping" then
            object.angularDamping = object.physicObject:getAngularDamping()
        end

        if key ~= nil and key == "linearVelocityX" then
            object.linearVelocityX, object.linearVelocityY = object.physicObject:getLinearVelocity()
        end

        if key ~= nil and key == "linearVelocityY" then
            object.linearVelocityX, object.linearVelocityY = object.physicObject:getLinearVelocity()
        end

        if key ~= nil and key == "linearDamping" then
            object.linearDamping = object.physicObject:getLinearDamping()
        end
        if key ~= nil and key == "isSleepingAllowed" then
            print("isSleepingAllowed not available at the moment")
        end
        if key ~= nil and key == "bodyType" then
            print("bodyType not available at the moment")
        end
        if key ~= nil and key == "fixture" then
            object.fixture = object.physicObject.fixturelist
        end
        if key ~= nil and key == "restitution" then
            object.restitution = object.fixture[1].restitution
        end
        if key ~= nil and key == "friction" then
            object.friction = object.fixture[1].friction
        end
        if key ~= nil and key == "filter" then
            object.filter = object.fixture[1].filter
        end
        if key ~= nil and key == "density" then
            object.density = object.fixture[1].density
        end
        if key ~= nil and key == "sensor" then
            object.sensor = object.fixture[1].sensor
        end
    end

    return getmetatable(self).__object[key]
end

-- Create a new proxy for RNObject Object

--- Create a new RNObject
function RNObject:new()
    local displayobject = RNObject:innerNew(nil)
    local proxy = setmetatable({}, { __newindex = fieldChangedListener, __index = fieldAccessListener, __object = displayobject })
    return proxy, displayobject
end

-- Create a new RNObject Object
function RNObject:innerNew(o)

    o = o or {
        name = "",
        myName = nil,
        image = nil,
        originalHeight = 0,
        originalWidth = 0,
        pow2Width = 0,
        pow2Height = 0,
        x = 0,
        y = 0,
        gfxQuad = nil,
        shader = nil,
        screenX = 0,
        screenY = 0,
        visible = true,
        touchListener = nil,
        onTouchDownListener = nil,
        children = {},
        childrenSize = 0,
        currentRefX = 0,
        currentRefY = 0,
        isVisible = true,
        tileDeck = nil,
        rotation = 0,
        touchable = false,
        swapImage = nil,
        xInGroup = 0,
        yInGroup = 0,
        --physic metamerge
        isPhysical = false,
        physicObject = nil,
        collision = nil,
        userdata = nil,
        bodyType = "",
        myName = nil,
        isAwake = nil,
        awake = nil,
        isActive = nil,
        active = nil,
        isBullet = nil,
        setBullet = nil,
        fixedRotation = nil,
        angularVelocity = nil,
        angularDamping = nil,
        linearVelocityX = nil,
        linearVelocityY = nil,
        linearDamping = nil,
        isSensor = nil,
        isSleepingAllowed = true,
        fixture = {},
        restitution = nil,
        friction = nil,
        density = nil,
        filter = nil,
        sensor = nil,
        --per l'anim
        scaleX = nil,
        scaleY = nil,
        sizex = nil,
        sizey = nil,
        isAnim = false,
        frame = nil,
        speed = nil,
        pause = true,
        animCounter = 0,
        sequenceList = {},
        currentSequence = nil,
        frameNumberTotal = 0,
    }

    self.stageBounds = {
        xMin = 0,
        yMin = 0,
        xMax = 0,
        yMax = 0
    }

    self.isFocus = false

    setmetatable(o, self)
    self.__index = self
    return o
end

--- Crete a new RNObject doing aCopyRect from the source image
---
function RNObject:initCopyRect(src, params)
    self.visible = true
    self.childrenSize = 0

    self.alpha = 1
    self:loadCopyRect(src, params)
end


function RNObject:initBlank(width, height)

    self.name = image

    self.gfxQuad = MOAIGfxQuad2D.new()

    self.image = MOAIImage.new()
    self.image:init(width, height)


    self.originalWidth, self.originalHeight = self.image:getSize()

    self.image = self.image:padToPow2()
    self.gfxQuad:setTexture(self.image)

    self.pow2Width, self.pow2Height = self.image:getSize()

    self.prop = MOAIProp2D.new()

    local u = self.originalWidth / self.pow2Width
    local v = self.originalHeight / self.pow2Height

    self.gfxQuad:setUVRect(0, 0, u, v)


    self.prop:setDeck(self.gfxQuad)
    self.gfxQuad:setRect(-self.originalWidth / 2, -self.originalHeight / 2, (self.originalWidth) / 2, (self.originalHeight) / 2)
    self.prop:setPriority(1)
end

function RNObject:loadCopyRect(src, params)

    local image

    if (type(src) == "string") then
        image = MOAIImage.new()
        image:load(src, MOAIImage.TRUECOLOR + MOAIImage.PREMULTIPLY_ALPHA)
    elseif (type(src) == "userdata") then -- light check should be a MOAIImage.
        image = src
    end

    self.name = ""

    self.gfxQuad = MOAIGfxQuad2D.new()

    self.image = MOAIImage.new()

    local tmpWidth = params.srcXMax - params.srcXMin
    local tmpEight = params.srcYMax - params.srcYMin

    self.image:init(tmpWidth, tmpEight)

    self.image:copyRect(image, params.srcXMin, params.srcYMin, params.srcXMax, params.srcYMax, params.destXMin, params.destYMin, params.destXMax, params.destYMax, params.filter)

    -- self.image.

    self.originalWidth, self.originalHeight = self.image:getSize()

    self.image = self.image:padToPow2()
    self.gfxQuad:setTexture(self.image)

    self.pow2Width, self.pow2Height = self.image:getSize()

    self.prop = MOAIProp2D.new()

    local u = self.originalWidth / self.pow2Width
    local v = self.originalHeight / self.pow2Height

    self.gfxQuad:setUVRect(0, 0, u, v)


    self.prop:setDeck(self.gfxQuad)
    self.gfxQuad:setRect(-self.originalWidth / 2, -self.originalHeight / 2, (self.originalWidth) / 2, (self.originalHeight) / 2)
    self.prop:setPriority(1)
end




function RNObject:initWithMoaiImage(moaiImage)
    self.visible = true
    self.childrenSize = 0

    self.alpha = 1
    self.name = ""

    self.gfxQuad = MOAIGfxQuad2D.new()

    self.image = moaiImage

    self.originalWidth, self.originalHeight = self.image:getSize()

    self.image = self.image:padToPow2()
    self.gfxQuad:setTexture(self.image)

    self.pow2Width, self.pow2Height = self.image:getSize()

    self.prop = MOAIProp2D.new()

    local u = self.originalWidth / self.pow2Width
    local v = self.originalHeight / self.pow2Height

    self.gfxQuad:setUVRect(0, 0, u, v)


    self.prop:setDeck(self.gfxQuad)
    self.gfxQuad:setRect(-self.originalWidth / 2, -self.originalHeight / 2, (self.originalWidth) / 2, (self.originalHeight) / 2)
    self.prop:setPriority(1)
end


function RNObject:initWithImage2(image)

    local deck = image
    local numberInAtlas

    if type(image) == "string" then
        if RNGraphicsManager:getAlreadyAllocated(image) then
            deck, numberInAtlas = RNGraphicsManager:getDeckByPath(image)
        else
            deck = RNGraphicsManager:allocateDeck2DGfx(image)
        end
    end


    if RNGraphicsManager:getGfxByPath(image).isInAtlas then
        self.originalWidth = RNGraphicsManager:getGfxByPath(image).sizes[numberInAtlas].w
        self.originalHeight = RNGraphicsManager:getGfxByPath(image).sizes[numberInAtlas].h
    else
        self.originalWidth = RNGraphicsManager:getGfxByPath(image).width
        self.originalHeight = RNGraphicsManager:getGfxByPath(image).height
    end


    if type(image) == "string" then self.name = image else self.name = "" end
    self.prop = MOAIProp2D.new()
    self.prop:setDeck(deck)
    self.prop:setPriority(1)
    if RNGraphicsManager:getGfxByPath(image).isInAtlas then
        self.prop:setIndex(numberInAtlas)

        self.isAnim = true
        --we check for default sequence frame Order
        local defaultFrameOrder = {
            1
        }

        --we create a new sequence
        self:newSequence("default", defaultFrameOrder, 12, 1, nil)
        --and set it as current
        self.currentSequence = "default"
        self.frame = numberInAtlas
    end

    self.scaleX = 1
    self.scaleY = 1

    return self, deck
end

function RNObject:initWithAnim2(image, sx, sy, scaleX, scaleY)

    local deck = image
    local path = image

    if type(image) == "string" then
        if RNGraphicsManager:getAlreadyAllocated(image) then
            deck = RNGraphicsManager:getDeckByPath(image)
        else
            deck = RNGraphicsManager:allocateTileDeck2DGfx(image, sx, sy)
        end
    else
        path = RNGraphicsManager:getGfxByDeck(deck)
    end


    local oW = RNGraphicsManager:getGfxByPath(path).width
    local oH = RNGraphicsManager:getGfxByPath(path).height

    self.prop = MOAIProp2D.new()
    self.prop:setIndex(1)
    self.prop:setPriority(1)


    self.prop:setDeck(deck)
    self.deck = deck

    if type(image) == "string" then self.name = image else self.name = "" end
    self.originalWidth = sx * scaleX
    self.originalHeight = sy * scaleY
    self.originalScaleX = scaleX
    self.originalScaleY = scaleY
    self.scaleX = scaleX
    self.scaleY = scaleY
    self:setScaleX(scaleX)
    self:setScaleY(scaleY)
    self.sizex = sx
    self.sizey = sy
    self.isAnim = true
    self.frameNumberTotal = oW / sx * oH / sy

    --we check for default sequence frame Order
    local defaultFrameOrder = {}
    for j = 1, self.frameNumberTotal, 1 do defaultFrameOrder[j] = j end

    --we create a new sequence
    self:newSequence("default", defaultFrameOrder, 12, 1, nil)
    --and set it as current
    self.currentSequence = "default"
    self.frame = 1




    return self, deck
end



function RNObject:initWithRect(width, height, rgb)
    self.visible = true
    self.childrenSize = 0
    self.alpha = 1
    self:loadRect(width, height, rgb)
end


function RNObject:initWithCircle(x, y, r, rgb)
    self.visible = true
    self.childrenSize = 0
    self.alpha = 1
    self:loadCircle(x, y, r, rgb)
end


function RNObject:loadRect(width, height, rgb)
    self.name = "shape"
    local x = width * .5
    local y = height * .5

    self.shapeR, self.shapeG, self.shapeB = rgb[1] * 0.00392, rgb[2] * 0.00392, rgb[3] * 0.00392

    local function onDraw()

        MOAIGfxDevice.setPenColor(self.shapeR, self.shapeG, self.shapeB, self.alpha)
        MOAIDraw.fillRect(-x, -y, x, y)
    end

    self.gfxQuad = MOAIScriptDeck.new()
    self.gfxQuad:setRect(-x, -y, x, y)
    self.gfxQuad:setDrawCallback(onDraw)

    self.originalWidth, self.originalHeight = width, height

    self.prop = MOAIProp2D.new()

    self.prop:setDeck(self.gfxQuad)

    self.prop:setPriority(1)
end

function RNObject:setScissorRect(scissorRect)
    if self.prop and self.prop.setScissorRect then self.prop:setScissorRect(scissorRect) end
end

function RNObject:setPenColor(r, g, b, alpha)
    self.shapeR, self.shapeG, self.shapeB = r * 0.00392, g * 0.00392, b * 0.00392
    if alpha ~= nil then
        self.alpha = alpha
    end
end


function RNObject:loadCircle(x, y, r, rgb)
    self.name = "shape"

    self.shapeR, self.shapeG, self.shapeB = rgb[1] * 0.00392, rgb[2] * 0.00392, rgb[3] * 0.00392

    local function onDraw()
        MOAIGfxDevice.setPenColor(self.shapeR, self.shapeG, self.shapeB, 0.5)
        MOAIDraw.fillCircle(0, 0, r, 32)
    end

    self.gfxQuad = MOAIScriptDeck.new()
    self.gfxQuad:setRect(-r, -r, r, r)

    self.gfxQuad:setDrawCallback(onDraw)
    local r2 = r * 2
    self.originalWidth, self.originalHeight = r2, r2

    self.pow2Width, self.pow2Height = r2, r2
    self.prop = MOAIProp2D.new()

    self.prop:setDeck(self.gfxQuad)

    self.prop:setPriority(1)
end


function RNObject:getDebugName()
    return self.name
end



function RNObject:setIDInGroup(id)
    self.idInGroup = id
end

function RNObject:getIDInGroup()
    return self.idInGroup
end


function RNObject:setIDInScreen(id)
    --    self.idInScreen = id
end

function RNObject:animate(keyframe, executed, value)
    --print("keyframe " .. keyframe)
    --print("executed " .. executed)
    --get self from timer
    self = self.obj
    --we check for the right sequence to play
    local rightSequenceToPlay
    if self.sequenceList ~= nil then
        for i = 1, table.getn(self.sequenceList), 1 do
            if self.sequenceList[i].name == self.currentSequence then rightSequenceToPlay = i end
        end
    end
    --get right sequence from list
    local rightSequence = self.sequenceList[rightSequenceToPlay]
    --set current Frame of animation
    self.frame = rightSequence.frameOrder[keyframe]
    --if we meet execution times
    --print(executed, rightSequence.repeatTimes, #rightSequence.frameOrder)
    if rightSequence.repeatTimes ~= -1 then
        if executed >= rightSequence.repeatTimes then
            --print("stopped")
            --stop and deallocate timer
            self.timer:stop()
            self.timer = nil
            --get right sequence from list
            local rightSequence = self.sequenceList[rightSequenceToPlay]
            --call onEnd function
            if rightSequence.onStop ~= nil then
                local funct = rightSequence.onStop
                funct()
            end
            --stops animation
        end
    end
end

function RNObject:stop()
    --stops timer
    if self.timer ~= nil then self.timer:stop(); self.timer = nil end
end

function RNObject:togglePause()
    if self.isAnim == true and self.timer ~= nil then
        if self.pause == true then
            self.pause = false
            self.timer:start()
        else
            self.pause = true
            self.timer:stop()
        end
    end
end



function RNObject:play(sequenceName, speed, repeatTimes, onStop)
    self:stop()
    self.currentSequence = nil

    --get sequence name
    if sequenceName == nil then sequenceName = "default" end
    self.currentSequence = sequenceName
    --get sequence from sequence list
    local rightSequenceToPlay
    if self.sequenceList ~= nil then
        for i = 1, table.getn(self.sequenceList), 1 do
            if self.sequenceList[i].name == sequenceName then rightSequenceToPlay = i end
        end
    end
    local rightSequence = self.sequenceList[rightSequenceToPlay]
    --set sequence values
    rightSequence.timeRepeated = 0
    rightSequence.currentFrame = 0
    if speed ~= nil then rightSequence.speed = speed end
    if repeatTimes ~= nil then rightSequence.repeatTimes = repeatTimes end
    if onStop ~= nil then rightSequence.onStop = onStop end


    --stop eventual previous animation
    if self.timer ~= nil then self.timer = nil end
    if self.curve ~= nil then self.curve = nil end

    --create new timer and stop
    self.timer = MOAITimer.new()
    self.timer:setMode(MOAITimer.CONTINUE)
    --create new curve
    self.curve = MOAIAnimCurve.new()
    --assign the curve to the timer
    self.timer:setCurve(self.curve)
    self.timer.obj = self

    local timer = self.timer
    local curve = self.curve

    --create keys
    local framesInSequence = table.getn(rightSequence.frameOrder)
    curve:reserveKeys(framesInSequence)
    for i = 1, framesInSequence do
        curve:setKey(i, i, i, MOAIEaseType.LINEAR, 1)
    end

    --set timer spans
    timer:setSpan(framesInSequence)
    timer:setSpeed(rightSequence.speed)
    --set listener
    timer:setListener(MOAITimer.EVENT_TIMER_KEYFRAME, self.animate)
    --start timer
    timer:start()
    --unset pause
    self.pause = false
end






function RNObject:newSequence(name, frameOrder, speed, repeatTimes, onStop)
    if self.isAnim == true then
        local listn = table.getn(self.sequenceList)
        local sequence = {}
        if speed == nil then speed = 24 end
        if repeatTimes == nil then repeatTimes = 1 end
        if frameOrder == nil then frameOrder = self.sequenceList[1].frameOrder end
        sequence.name = name
        sequence.frameOrder = frameOrder
        sequence.speed = speed
        sequence.repeatTimes = repeatTimes
        sequence.onStop = onStop
        sequence.currentFrame = 1
        sequence.timeRepeated = 0

        self.sequenceList[listn + 1] = sequence
    end
end

function RNObject:removeSequence(name)
    if name ~= "default" then
        if self.isAnim == true then
            local tempValue
            if self.sequenceList ~= nil then
                for i = 1, table.getn(self.sequenceList), 1 do
                    if self.sequenceList[i].name == name then
                        tempValue = i
                    end
                end
            end
            for k = tempValue, table.getn(self.sequenceList), 1 do
                if k < table.getn(self.sequenceList) then
                    self.sequenceList[k] = self.sequenceList[k + 1]
                else
                    self.sequenceList[k] = nil
                end
            end
        end
    end
end

function RNObject:flipHorizontal()
    self.scaleX = -self.scaleX
end

function RNObject:flipVertical()
    self.scaleY = -self.scaleY
end

function RNObject:setTileSizeX(value)
    self.tileDeck:setSize(value, self.scaleY)
end

function RNObject:setTileSizeY(value)
    self.tileDeck:setSize(self.scaleX, value)
end

function RNObject:setSize(Sx, Sy)
    self.tileDeck:setSize(Sx, Sy)
end

function RNObject:setLevel(value)
    self.prop:setPriority(value)
    self.parentGroup:inserLevel(self:getLevel())
end

function RNObject:getLevel()
    return self.prop:getPriority()
end

function RNObject:sendToBottom()
    self.parentGroup:sendToBottom(self)
end

function RNObject:bringToFront()
    self.parentGroup:bringToFront(self)
end

function RNObject:putOver(object)
    self.prop:setPriority(object:getLevel() + 1)
    self.parentGroup:inserLevel(self:getLevel())
end

function RNObject:setTileScaleX(value)
    self.originalWidth = self.originalWidth * value
    self.deck:setRect(-self.originalWidth / 2, self.originalHeight / 2, self.originalWidth / 2, -self.originalHeight / 2)
end

function RNObject:setTileScaleY(value)
    self.originalHeight = self.originalHeight * value
    self.deck:setRect(-self.originalWidth / 2, self.originalHeight / 2, self.originalWidth / 2, -self.originalHeight / 2)
end


function RNObject:setScaleX(value)
    local xs, ys = self.prop:getScl()
    self.prop:setScl(value, ys)
    self.originalWidth = self.originalWidth * value
end

function RNObject:setScaleY(value)
    local xs, ys = self.prop:getScl()
    self.prop:setScl(xs, value)
    self.originalHeight = self.originalHeight * value
end

function RNObject:getChildren()
    return self.children
end

function RNObject:getChildat(index)
    return self.children[index]
end

function RNObject:addChild(sprite)
    self.children[self.childrenSize] = sprite
    self.childrenSize = self.childrenSize + 1
end

function RNObject:setParentScene(scene)
    self.scene = scene
end

function RNObject:getChildrenSize()
    return self.childrenSize
end

function RNObject:getImageName()
    return self.name
end

function RNObject:getGfxQuad()
    return self.gfxQuad
end

function RNObject:getProp()
    return self.prop
end

function RNObject:updateLocation()
    self:setLocation(self.x, self.y)
end

function RNObject:setLocatingMode(mode)
    self.locatingMode = mode
end

function RNObject:getOriginalWidth()
    return self.originalWidth
end

function RNObject:getOriginalHeight()
    return self.originalHeight
end


function RNObject:getLocation()
    return self.x, self.y
end

function RNObject:getX()
    if self.isPhyisic == false then
        return self.x
    else
        return self.physicObject:getX()
    end
end

function RNObject:getY()
    if self.isPhyisic == false then
        return self.y
    else
        return self.physicObject:getY()
    end
end

function RNObject:getAlpha()
    return self.alpha
end

function RNObject:setAlpha(value)

    self.alpha = value
    self.prop:setColor(value, value, value, value, 0)
end

function RNObject:getShader()
    return self.shader
end

function RNObject:getImage()
    return self.image
end

function RNObject:getLocatingMode()
    return self.locatingMode
end

function RNObject:setVisible(value)
    if self.isPhysical == false then
        if self.prop ~= nil then
            --print(self,self.prop,typeof(value))
            self.prop:setVisible(value)
        end
    else
        if self.prop ~= nil then
            self.prop:setVisible(value)
            if value == true then
                self.prop:setParent(self.physicObject.body)
            else
                self.prop:setParent(nil)
            end
        end
    end
end

function RNObject:getVisible()
    return self.visible
end


function RNObject:TOP_LEFT_MODE()
    return TOP_LEFT_MODE
end

function RNObject:getSDType()
    return "RNObject"
end

function RNObject:setLocation(x, y)

    local tmpX = x
    local tmpY = y

    if (self:getProp() ~= nil) then
        self:getProp():setLoc(tmpX, tmpY);
    end

    self.x = x
    self.y = y
end


function RNObject:setY(y)

    if self.isPhysical == false then
        local tmpX = self.x
        local tmpY = self.currentRefY + y

        if (self:getProp() ~= nil) then
            self:getProp():setLoc(tmpX, tmpY);
        end
    else
        self.physicObject:setY()
    end

    self.y = self.currentRefY + y
end

function RNObject:setX(x)

    if self.isPhysical == false then
        local tmpX = self.currentRefX + x
        local tmpY = self.y


        if (self:getProp() ~= nil) then
            self:getProp():setLoc(tmpX, tmpY);
        end
    else
        self.physicObject:setX()
    end
    self.x = self.currentRefX + x
end

function RNObject:setTouchable(value)

    if value then
        self.touchable = true
    else
        self.touchable = false
    end
end

function RNObject:isTouchable()
    return self:getProp().touchable
end

function RNObject:addEventListener(eventName, func)
    local index
    if eventName == "collision" then
        self.physicObject:addEventListener("collision")
    else
        self:setTouchable(true)
        local aListener = RNWrappedEventListener:new()
        aListener:setFunction(func)
        aListener:setTarget(self)

        self.onTouchCallBackFunction = aListener
        --index = RNInputManager.addGlobalListenerToEvent(eventName, func, { target = self })
    end
    return index
end

function RNObject:addGlobalEventListener(eventName, func)
    local index
    if eventName == "collision" then
        self.physicObject:addEventListener("collision")
    else
        index = RNInputManager.addGlobalListenerToEvent(eventName, func, { target = self })
    end
    return index
end

-- Todo: check to remove.
function RNObject:isInRange(x, y)

    local buttonx = x
    local buttony = y

    buttonx = x + self.originalWidth / 2
    buttony = y + self.originalHeight / 2

    if self.visible
            and buttonx >= self.x
            and buttonx <= self.x + self.originalWidth
            and buttony >= self.y
            and buttony <= self.y + self.originalHeight
    then

        return true
    end

    return false
end

function RNObject:isListening()
    return self.onTouchDownListener ~= nil or self.onTouchMoveListener ~= nil or self.onTouchUpListener ~= nil or self.onTouchDownListener ~= nil
end

function RNObject:onEvent(event)

    if event.phase == "began" and self.visible and self.onTouchDownListener ~= nil then
        self.onTouchDownListener(event)
        return true
    end

    if event.phase == "moved" and self.visible and self.onTouchMoveListener ~= nil then
        self.onTouchMoveListener(event)
        return true
    end

    if event.phase == "ended" and self.visible and self.onTouchUpListener ~= nil then
        self.onTouchUpListener(event)
        return true
    end

    if event.phase == "cancelled" and self.visible and self.onTouchUpListener ~= nil then
        self.onTouchUpListener(event)
        return true
    end
end

function RNObject:onTouchMove(x, y, source)
    if self.visible and self.touchListener ~= nil and x >= self.x and x <= self.x + self.originalWidth and y >= self.y and y <= self.y + self.originalHeight then
        self.onTouchMoveListener(x, y, source)
        return true
    end
end

function RNObject:setOnTouchDown(func)
    self:setTouchable(true)
    self.onTouchDownListener = func
end

function RNObject:setOnTouchMove(func)
    self:setTouchable(true)
    self.onTouchMoveListener = func
end

function RNObject:setOnTouchUp(func)
    self:setTouchable(true)
    self.onTouchUpListener = func
end

function RNObject:setOnTouchCancel(func)
    self:setTouchable(true)
    self.onTouchCancelListener = func
end

function RNObject:setGlobalTouchListener(func)
    self:setOnTouchDown(func)
    self:setOnTouchMove(func)
    self:setOnTouchUp(func)
    self:setOnTouchCancel(func)
end

function RNObject:getTranslatedLocation(x, y)
end

function RNObject:setParentGroup(group)
    self.parentGroup = group
end

function RNObject:getType()
    return "RNObject"
end


function RNObject:setAllFixture(field, value)

    for i = 1, table.getn(self.fixture), 1 do
        if field == "restitution" then
            self.fixture[i].restitution = value
        elseif field == "friction" then
            self.fixture[i].friction = value
        elseif field == "filter" then
            self.fixture[i].filter = value
        elseif field == "density" then
            self.fixture[i].density = value
        elseif field == "sensor" then
            self.fixture[i].sensor = value
        end
    end
end

--
-- calls to phsyic object methods
--
function RNObject:remove()

    if self.timer ~= nil then self.timer:stop(); self.timer = nil end
    if self.curve ~= nil then self.curve = nil end

    if self.tmplistener ~= nil then RNListeners:removeEventListener("enterFrame", self.tmplistener) end

    if self.layer ~= nil then
        self.scene:removeRNObject(self)
    end
    --print_r(self.scene)
    if self.isPhysical == true then
        self.physicObject:remove()
    else
        self.prop:setDeck(nil)
    end
    --print("remove", self.idInGroup)
    if (self.parentGroup) then
        self.parentGroup:removeChild(self.idInGroup)
    end
    if self.font ~= nil then
        self.font = nil
    end
    if self.textbox ~= nil then
        self.textbox = nil
    end

    if self.style ~= nil then
        self.style = nil
    end

    if self.stylesList ~= nil then
        for i = 1, #self.stylesList do
            print(i)
            self.stylesList[i] = nil
        end
        self.styleList = nil
    end

    self:setOnTouchUp(nil)
    self:setOnTouchDown(nil)
    self:setOnTouchMove(nil)

    self.prop:setDeck(nil)
    self.prop = nil
    self.deck = nil
    self.tileDeck = nil
    self = nil
    --    collectgarbage()
end

--if it's awake (returns boolean)
function RNObject:isAwake()
    return self.physicObject:isAwake()
end

--sets the body as awake (true or false)
function RNObject:setAwake(value)
    self.physicObject:setAwake(value)
end


--if it's active (returns boolean)

function RNObject:isActive()
    return self.physicObject:isActive()
end

--sets the body as active (true or false)
function RNObject:setActive(value)
    self.physicObject:setActive(value)
end


--if it's bullet
function RNObject:isBullet()
    return self.physicObject:isBullet()
end


--sets the body as bullet[a bullet body is under continuous collision checking] (true or false)
function RNObject:setBullet(value)
    self.physicObject:setBullet(value)
end

--if its rotation is fixed (returns boolean)
function RNObject:isFixedRotation()
    return self.physicObject:isFixedRotation()
end

--prevents the body from rotation (true or false)
function RNObject:setFixedRotation(value)
    self.physicObject:setFixedRotation(value)
end

--gets the angular velocity
function RNObject:getAngularVelocity()
    return self.physicObject:getAngularVelocity()
end

--sets the angular velocity
function RNObject:setAngularVelocity(value)
    self.physicObject:setAngularVelocity(value)
end

--gets the linear damping
function RNObject:getLinearDamping()
    return self.physicObject:getLinearDamping()
end

--sets the linear damping
function RNObject:setLinearDamping(value)
    self.physicObject:setLinearDamping(value)
end

--gets the angular damping
function RNObject:getAngularDamping()
    return self.physicObject:getAngularDamping()
end

--sets the angular damping
function RNObject:setAngularDamping(value)
    self.physicObject:setAngularDamping(value)
end


--gets the linear velocity
function RNObject:getLinearVelocity()
    return self.physicObject:getLinearVelocity()
end

--sets the linear velocity
function RNObject:setLinearVelocity(valuex, valuey)
    self.physicObject:setLinearVelocity(valuex, valuey)
end


--sets all fixture of this body as sensors
function RNObject:setSensor(value)
    self.physicObject:setSensor(value)
end

--
-- Additional working accessible proprieties and methods from MOAIbox2d (check moai documentation)
--
--body:getAngle()
function RNObject:getAngle()
    return self.physicObject:getAngle()
end

--body:getLocalCenter()
function RNObject:getLocalCenter()
    return self.physicObject:getLocalCenter()
end

--body:getPosition()
function RNObject:getPosition()
    return self.physicObject:getPosition()
end

--body:getWorldCenter()
function RNObject:getWorldCenter()
    return self.physicObject:getWorldCenter()
end

--body:resetMassData()
function RNObject:resetMassData()
    self.physicObject:resetMassData()
end

--body:setMassData(number mass [, number I, number centerX, number centerY ])
function RNObject:setMassData(mass, I, centerX, centerY)
    self.physicObject:setMassData(mass, I, centerX, centerY)
end


--body:setTransform([, number positionX, number positionY, number angle ])
function RNObject:setTransform(positionX, positionY, angle)
    self.physicObject:setTransform(positionX, positionY, angle)
end

function RNObject:setAngle(Angle)
    self.physicObject:setAngle(Angle)
end

--
-- physic bodies common working methods
--

--body:applyForce(number forceX, number forceY [, number pointX, number pointY ] )
function RNObject:applyForce(forceX, forceY, pointX, pointY)
    self.physicObject:applyForce(forceX, forceY, pointX, pointY)
end

--body:applyTorque(number torque)
function RNObject:applyTorque(value)
    self.physicObject:applyTorque(value)
end

--body:applyLinearImpulse(number impulseX, number impulseY [, number pointX, number pointY ] )
function RNObject:applyLinearImpulse(impulseX, impulseY, pointX, pointY)
    self.physicObject:applyLinearImpulse(impulseX, impulseY, pointX, pointY)
end

--body:applyAngularImpulse( number impulse )
function RNObject:applyAngularImpulse(value)
    self.physicObject:applyAngularImpulse(value)
end




-- additional methods from last update

function RNObject:getInertia()
    return self.physicObject:getInertia()
end

function RNObject:getMass()
    return self.physicObject:getInertia()
end

function RNObject:setMassData(mass, I, centerX, centerY)
    if I ~= nil then
        self.physicObject:setMassData(mass, I, centerX, centerY)
    else
        self.physicObject:setMassData(mass)
    end
end

--fixture methods

function RNObject:getFixtureListByName(name)
    local tmpFixtureList = {}
    for i, v in ipairs(self.fixture) do
        if name == v.name then
            tmpFixtureList[table.getn(tmpFixtureList) + 1] = v
        end
    end
    return tmpFixtureList
end


function RNObject:changeFixturesProperty(name, property, value)
    for i, v in ipairs(self:getFixtureListByName(name)) do
        if property == "restitution" then
            v.restitution = value
        end

        if property == "density" then

            v.density = value
        end

        if property == "friction" then

            v.friction = value
        end

        if property == "sensor" then

            v.sensor = value
        end

        if property == "filter" then
            v.filter = value
        end

        if property == "name" then

            v.name = value
        end
    end
end

return RNObject