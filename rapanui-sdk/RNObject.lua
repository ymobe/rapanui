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

--- This is the core object of the RapaNui framework. It wraps Moai props2d and chanche the UV maps so the orgin 0,0 of screen is on TOP LEFT
-- @author Stefano Linguerri
-- @author Mattia Fortunati


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

    if self.isAnim == true then

        if key ~= nil and key == "sizex" then
            self:setTileSizeX(value)
        end

        if key ~= nil and key == "sizey" then
            self:setTileSizeY(value)
        end
        if key ~= nil and key == "scalex" then
            self:setTileScaleX(value)
        end
        if key ~= nil and key == "scaley" then
            self:setTileScaleY(value)
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
    local displayobject = RNObject:innerNew()
    local proxy = setmetatable({}, { __newindex = fieldChangedListener, __index = fieldAccessListener, __object = displayobject })
    return proxy, displayobject
end

-- Create a new RNObject Object
function RNObject:innerNew()

    local o = {
        name = "",
        myName = nil,
        image = nil,
        originalHeight = 0,
        originalWidth = 0,
        pow2Widht = 0,
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
        -- for anims
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

function RNObject:initCopyRect(src, params)
    self.visible = true
    self.childrenSize = 0

    self.alpha = 1
    self:loadCopyRect(src, params)
end

--- Creates a new RNObject RNObject with a blank image
-- @param width width
-- @param height height
function RNObject:initBlank(width, height)

    self.name = image

    self.gfxQuad = MOAIGfxQuad2D.new()

    self.image = MOAIImage.new()
    self.image:init(width, height)


    self.originalWidth, self.originalHeight = self.image:getSize()

    self.image = self.image:padToPow2()
    self.gfxQuad:setTexture(self.image)

    self.pow2Widht, self.pow2Height = self.image:getSize()

    self.prop = MOAIProp2D.new()

    local u = self.originalWidth / self.pow2Widht
    local v = self.originalHeight / self.pow2Height

    self.gfxQuad:setUVRect(0, 0, u, v)


    self.prop:setDeck(self.gfxQuad)
    self.gfxQuad:setRect(-self.originalWidth / 2, -self.originalHeight / 2, (self.originalWidth) / 2, (self.originalHeight) / 2)
    self.prop:setPriority(1)
end

--- Creates a new RNObject doing a Copy Rect from the source image
-- @param src source image
-- @param params table containing {srcXMin, srcYMin, srcXMax, srcYMax, destXMin, destYMin, destXMax, destYMax ,filter}
-- @usage {srcXMin, srcYMin, srcXMax, srcYMax, destXMin, destYMin, destXMax, destYMax ,filter}
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

    self.pow2Widht, self.pow2Height = self.image:getSize()

    self.prop = MOAIProp2D.new()

    local u = self.originalWidth / self.pow2Widht
    local v = self.originalHeight / self.pow2Height

    self.gfxQuad:setUVRect(0, 0, u, v)


    self.prop:setDeck(self.gfxQuad)
    self.gfxQuad:setRect(-self.originalWidth / 2, -self.originalHeight / 2, (self.originalWidth) / 2, (self.originalHeight) / 2)
    self.prop:setPriority(1)
end


--- Initializes the object with the given image path
-- @param image the path of the image to use
function RNObject:initWith(image)
    self.visible = true
    self.childrenSize = 0

    self.alpha = 1
    self:loadImage(image)
end

--- Initializes the object with the given MOAIImage
-- @param moaiImage the MOAIImage
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

    self.pow2Widht, self.pow2Height = self.image:getSize()

    self.prop = MOAIProp2D.new()

    local u = self.originalWidth / self.pow2Widht
    local v = self.originalHeight / self.pow2Height

    self.gfxQuad:setUVRect(0, 0, u, v)


    self.prop:setDeck(self.gfxQuad)
    self.gfxQuad:setRect(-self.originalWidth / 2, -self.originalHeight / 2, (self.originalWidth) / 2, (self.originalHeight) / 2)
    self.prop:setPriority(1)
end


function RNObject:loadImage(image)
    self.name = image

    self.gfxQuad = MOAIGfxQuad2D.new()

    self.image = MOAIImage.new()
    self.image:load(image, MOAIImage.TRUECOLOR + MOAIImage.PREMULTIPLY_ALPHA)

    self.originalWidth, self.originalHeight = self.image:getSize()

    self.image = self.image:padToPow2()
    self.gfxQuad:setTexture(self.image)

    self.pow2Widht, self.pow2Height = self.image:getSize()

    self.prop = MOAIProp2D.new()

    local u = self.originalWidth / self.pow2Widht
    local v = self.originalHeight / self.pow2Height

    self.gfxQuad:setUVRect(0, 0, u, v)


    self.prop:setDeck(self.gfxQuad)
    self.gfxQuad:setRect(-self.originalWidth / 2, -self.originalHeight / 2, (self.originalWidth) / 2, (self.originalHeight) / 2)
    self.prop:setPriority(1)
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

--- Create a new RNObject with a rectangle shape
-- @param width rectangle width
-- @param height rectangle height
-- @param rgb a table with {r=numebr, g=number, b=number}
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


--- Set the pen color for the shape
-- @param r red value for color
-- @param g green value for color
-- @param b blue value for color
-- @param alpha alpha value for color
-- @see RNObject:loadCircle
-- @see RNObject:loadRect
function RNObject:setPenColor(r, g, b, alpha)
    self.shapeR, self.shapeG, self.shapeB = r * 0.00392, g * 0.00392, b * 0.00392
    if alpha ~= nil then
        self.alpha = alpha
    end
end


--- Create a new RNObject with circle shape
-- @param x x position of the circle center
-- @param y y position of the circle center
-- @param r radius of the circle
-- @param rgb a table with {r=numebr, g=number, b=number}
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

    self.pow2Widht, self.pow2Height = r2, r2
    self.prop = MOAIProp2D.new()

    self.prop:setDeck(self.gfxQuad)

    self.prop:setPriority(1)
end


function RNObject:getDebugName()
    return self.name
end


function RNObject:initAnimWith(image, sx, sy, scaleX, scaleY)
    self.visible = true
    self.childrenSize = 0

    self.alpha = 1
    self:loadAnim(image, sx, sy, scaleX, scaleY)
end


function RNObject:setIDInGroup(id)
    self.idInGroup = id
end

--- Return the id of RNObject in the group it belongs to
-- @return id id in the group
function RNObject:getIDInGroup()
    return self.idInGroup
end


function RNObject:setIDInScreen(id)
    self.idInScreen = id
end

--- Creates a new RNObject with animation
-- @param image
-- @param sx
-- @param sy
-- @param scaleX
-- @param scaleY
function RNObject:loadAnim(image, sx, sy, scaleX, scaleY)
    self.name = image

    self.tileDeck = MOAITileDeck2D.new()


    self.image = MOAIImage.new()
    self.image:load(image, MOAIImage.TRUECOLOR + MOAIImage.PREMULTIPLY_ALPHA)
    -- self.image = self.image:padToPow2()
    self.originalWidth, self.originalHeight = self.image:getSize()


    self.image = self.image:padToPow2()


    local oWnotPadded = self.originalWidth
    local oHnotPadded = self.originalHeight


    self.originalWidth, self.originalHeight = self.image:getSize()


    self.tileDeck:setTexture(self.image)
    local px = self.originalWidth / sx
    local py = self.originalHeight / sy
    --self.tileDeck:setSize(number width, number height [, number cellWidth, number cellHeight, number xOff, number yOff, number tileWidth, number tileHeight ] )
    self.tileDeck:setSize(px, py, 1 / px, 1 / py, 0, 0, 1 / px, 1 / py)
    self.prop = MOAIProp2D.new()
    self.prop:setIndex(1)

    self.prop:setDeck(self.tileDeck)

    local oW = self.originalWidth
    local oH = self.originalHeight

    self.tileDeck:setRect(-sx * scaleX, sy * scaleY, sx * scaleX, -sy * scaleY)
    self.originalWidth = sx * scaleX * 2
    self.originalHeight = sy * scaleY * 2
    self.scaleX = scaleX
    self.scaleY = scaleY
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
    RNListeners:addEventListener("enterFrame", self)
end

function RNObject:enterFrame(event)
    --takes self as himself
    self = self.source
    --uptades counter
    self.animCounter = self.animCounter + 1
    --if it's not paused
    if self.pause == false then
        --we check for the right sequence to play
        local rightSequenceToPlay = nil
        if self.sequenceList ~= nil then
            for i = 1, table.getn(self.sequenceList), 1 do
                if self.sequenceList[i].name == self.currentSequence then rightSequenceToPlay = i end
            end
        end
        local rightSequence = self.sequenceList[rightSequenceToPlay]
        --if the counter reachs the sequence speed
        if self.animCounter == rightSequence.speed then
            --we check for the next sequence's frame to play
            local nextSequenceFrame
            if rightSequence.frameOrder[rightSequence.currentFrame + 1] ~= nil then
                nextSequenceFrame = rightSequence.frameOrder[rightSequence.currentFrame + 1]
                rightSequence.currentFrame = rightSequence.currentFrame + 1
            else
                nextSequenceFrame = rightSequence.frameOrder[1]
                rightSequence.currentFrame = 1
            end
            --we upgrade the sequence repeated times, if it is not -1 (infinite loop)
            if rightSequence.reapeatTimes ~= -1 then rightSequence.timeRepeated = rightSequence.timeRepeated + 1 end
            --the object goes to the right frame
            self.frame = nextSequenceFrame
            --the counter goes back to 0
            self.animCounter = 0
            --if we have repeated the sequence enough (-1 to stop on the last frame)
            if rightSequence.timeRepeated == table.getn(rightSequence.frameOrder) * rightSequence.repeatTimes - 1 then
                self.pause = true
                if rightSequence.onStop ~= nil then
                    local funct = rightSequence.onStop
                    funct()
                end
            end
        end
    end
end

--- Pauses the current RNObject animation
function RNObject:togglePause()
    if self.isAnim == true then
        if self.pause == true then self.pause = false else self.pause = true end
    end
end

--- Stops the current RNObject animation
function RNObject:stop()
    if self.isAnim == true then
        self.pause = true
        self.frame = 1
        local rightSequenceToPlay = nil
        if self.sequenceList ~= nil then
            for i = 1, table.getn(self.sequenceList), 1 do
                if self.sequenceList[i].name == self.currentSequence then rightSequenceToPlay = i end
            end
        end
        local rightSequence = self.sequenceList[rightSequenceToPlay]
        rightSequence.timeRepeated = 0
        rightSequence.currentFrame = 1
    end
end

--- Starts playng the current RNObject animation
-- @param sequenceName the name of the anim sequence to play
-- @param speed time for each frame
-- @param repeatTimes time to repeat the sequences
-- @param onStop callback function to call at the end of animation
function RNObject:play(sequenceName, speed, repeatTimes, onStop)
    if self.isAnim == true then
        if sequenceName == nil then sequenceName = "default" end
        self.pause = false
        self.currentSequence = sequenceName

        local rightSequenceToPlay = nil
        if self.sequenceList ~= nil then
            for i = 1, table.getn(self.sequenceList), 1 do
                if self.sequenceList[i].name == sequenceName then rightSequenceToPlay = i end
            end
        end
        local rightSequence = self.sequenceList[rightSequenceToPlay]

        rightSequence.timeRepeated = 0
        rightSequence.currentFrame = 1

        if speed ~= nil then rightSequence.speed = speed end
        if repeatTimes ~= nil then rightSequence.repeatTimes = repeatTimes end
        if onStop ~= nil then rightSequence.onStop = onStop end
    end
end

--- Creates a new sequence animation on the current RNObject animation
-- @param name name of the new animation
-- @param frameOrder table with the number of the frames like {1,2,3, ...}
-- @param speed time of each frame
-- @param repeatTimes time the sequence is repeated
-- @param onStop callback function to call at the end of animation
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

--- Remove the sequence with the given name from RNObject animation
-- @param name name of the animation sequence to remove.
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

--- flip current image Horizontally
function RNObject:flipHorizontal()
    self.scalex = -1
end

--- flip current image Vertically
function RNObject:flipVertical()
    self.scaley = -1
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

--- set the level "Z" axis of the current RNObject
function RNObject:setLevel(value)
    self.prop:setPriority(value)
    self.parentGroup:inserLevel(self:getLevel())
end

--- return the level "Z" axis of the current RNObject
-- @return level number value of the current RNObject level
function RNObject:getLevel()
    return self.prop:getPriority()
end

--- set the level of current RNObject to the lowest value in the group it belongs to: this sends it on the bottom of the RNObject stack
function RNObject:sendToBottom()
    self.parentGroup:sendToBottom(self)
end

--- set the level of current RNObject to the highest value in the group it belongs to: this sends it on the top of the RNObject stack
function RNObject:bringToFront()
    self.parentGroup:bringToFront(self)
end

--- set the level of current RNObject to one more than target RNObject level
-- @param object the target RNObject on which the current RNObject should be put over
function RNObject:putOver(object)
    self.prop:setPriority(object:getLevel() + 1)
    self.parentGroup:inserLevel(self:getLevel())
end

function RNObject:setTileScaleX(value)
    self.originalWidth = (self.originalWidth / 2 / self.scaleX / self.sizex) * value * 2 * self.sizex
    self.tileDeck:setRect(self.originalWidth / 2, self.originalHeight / 2, -self.originalWidth / 2, -self.originalHeight / 2)
end

function RNObject:setTileScaleY(value)
    self.originalHeight = (self.originalHeight / 2 / self.scaleY / self.sizey) * value * 2 * self.sizey
    self.tileDeck:setRect(self.originalWidth / 2, self.originalHeight / 2, -self.originalWidth / 2, -self.originalHeight / 2)
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

--- return the underlying MOAIProp2D
-- @return MOAIProp2D
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

--- returns current RNObject location
-- @return x,y the x y number values
function RNObject:getLocation()
    return self.x, self.y
end

--- returns current RNObject x value
-- @return x number value
function RNObject:getX()
    if self.isPhyisic == false then
        return self.x
    else
        return self.physicObject:getX()
    end
end

--- returns current RNObject y value
-- @return y number value
function RNObject:getY()
    if self.isPhyisic == false then
        return self.y
    else
        return self.physicObject:getY()
    end
end

--- returns current RNObject alpha value
-- @return alpha number value
function RNObject:getAlpha()
    return self.alpha
end

--- sets RNObject alpha value
-- @param alpha number value
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

--- sets the visibility of current RNObject
-- @param value boolean for visibility
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

--- returns the visibility of current RNObject
-- @return value boolean for visibility
function RNObject:getVisible()
    return self.visible
end


function RNObject:TOP_LEFT_MODE()
    return TOP_LEFT_MODE
end

function RNObject:getSDType()
    return "RNObject"
end

--- sets the loation (x,y) for the current RNObject
-- @param x number value
-- @param y number value
function RNObject:setLocation(x, y)

    local tmpX = x
    local tmpY = y

    if (self:getProp() ~= nil) then
        self:getProp():setLoc(tmpX, tmpY);
    end

    self.x = x
    self.y = y
end

--- sets the y for the current RNObject
-- @param y number value
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

--- sets the x for the current RNObject
-- @param x number value
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

--- Sets an event listener for all the physics fixtures in this object
-- @param eventName string: only "collision" available at the moment
-- @param func function : the funcion receiving the callback<br>
-- Self:RNObject and a table event will be received by the function containing:<br>
-- event.phase: "begin","pre_solve","post_solve" or "end" indicating the collision phase <br>
-- event.self,event.other: the objects (RNObjects instances) colliding<br>
-- event.selfFixture,event.otherFixture: the fixtures (RNFixture instances) colliding<br>
-- event.force: the collision impact force<br>
-- event.friction: the collision friction force<br>
-- @usage <code>function onLocalCollide(self,event) --[[handle collision here]]-- end<br>
-- box.collision = onLocalCollide<br>
-- box:addEventListener("collision")</code>
-- @see RNPhysics.addEventListener
function RNObject:addEventListener(eventName, func)
    if eventName == "collision" then
        self.physicObject:addEventListener("collision")
    else
        RNInputManager.addListenerToEvent(eventName, func, self)
    end
end

--- returns if the given (x,y) coords are inside the RNObject
-- @param x number value
-- @param y number value
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
    self.onTouchDownListener = func
end

function RNObject:setOnTouchMove(func)
    self.onTouchMoveListener = func
end

function RNObject:setOnTouchUp(func)
    self.onTouchUpListener = func
end

function RNObject:setOnTouchCancel(func)
    self.onTouchCancelListener = func
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

--- remove current RNObject and let this be removable by garbage collector
function RNObject:remove()
    self.scene:removeRNObject(self)
    --print_r(self.scene)
    if self.isPhysical == true then
        self.physicObject:remove()
    else
        self.prop:setDeck(nil)
    end
    --print("remove", self.idInGroup)
    self.parentGroup:removeChild(self.idInGroup)
end

--- returns if current physic RNObject is Awake
-- @return isAwake boolean value
function RNObject:isAwake()
    return self.physicObject:isAwake()
end

--- sets current physic RNObject as Awake
-- @param value boolean value
function RNObject:setAwake(value)
    self.physicObject:setAwake(value)
end

--- returns if current physic RNObject is Active
-- @return isActive boolean value
function RNObject:isActive()
    return self.physicObject:isActive()
end

--- sets current physic RNObject as Active
-- @param value boolean value
function RNObject:setActive(value)
    self.physicObject:setActive(value)
end

--- returns if current physic RNObject is Bullet
-- @return isBullet boolean value
function RNObject:isBullet()
    return self.physicObject:isBullet()
end

--- sets current physic RNObject as Bullet: a bullet body is under continuous collision checking
-- @param value boolean value
function RNObject:setBullet(value)
    self.physicObject:setBullet(value)
end

--- returns if current physic RNObject has FixedRotation
-- @return isFixedRotation boolean value
function RNObject:isFixedRotation()
    return self.physicObject:isFixedRotation()
end

--- sets current physic RNObject FixedRotation, prevents the body from rotation (true or false)
-- @param value boolean value
function RNObject:setFixedRotation(value)
    self.physicObject:setFixedRotation(value)
end

--- returns current physic RNObject angular velocity
-- @return AngularVelocity number
function RNObject:getAngularVelocity()
    return self.physicObject:getAngularVelocity()
end

--- sets current physic RNObject angular velocity
-- @param value
function RNObject:setAngularVelocity(value)
    self.physicObject:setAngularVelocity(value)
end

--- returns current physic RNObject linear damping
-- @return LinearDamping number
function RNObject:getLinearDamping()
    return self.physicObject:getLinearDamping()
end

--- sets current physic RNObject linear damping
-- @param value number
function RNObject:setLinearDamping(value)
    self.physicObject:setLinearDamping(value)
end

--- returns current physic RNObject angular damping
-- @return AngularDamping number
function RNObject:getAngularDamping()
    return self.physicObject:getAngularDamping()
end

--- sets current physic RNObject angular damping
-- @param value number
function RNObject:setAngularDamping(value)
    self.physicObject:setAngularDamping(value)
end

--- returns current physic RNObject linear velocity
-- @return valuex,valuey numbers
function RNObject:getLinearVelocity()
    return self.physicObject:getLinearVelocity()
end

--- sets current physic RNObject linear velocity
-- @param valuex number
-- @param valuey number
function RNObject:setLinearVelocity(valuex, valuey)
    self.physicObject:setLinearVelocity(valuex, valuey)
end


--- sets all fixture of current physic RNObject as sensors
-- @param value boolean
function RNObject:setSensor(value)
    self.physicObject:setSensor(value)
end

--
-- Additional working accessible proprieties and methods from MOAIbox2d (check moai documentation)
--
--body:getAngle()
--- returns current physic RNObject Angle
-- @return Angle number
function RNObject:getAngle()
    return self.physicObject:getAngle()
end

--body:getLocalCenter()
--- returns current physic RNObject local center
-- @return localcenter
function RNObject:getLocalCenter()
    return self.physicObject:getLocalCenter()
end

--body:getPosition()
--- returns current physic RNObject position
-- @return postion
function RNObject:getPosition()
    return self.physicObject:getPosition()
end

--body:getWorldCenter()
--- returns current physic RNObject world center
-- @return world center
function RNObject:getWorldCenter()
    return self.physicObject:getWorldCenter()
end

--- resets current physic RNObject massdata
function RNObject:resetMassData()
    self.physicObject:resetMassData()
end

--body:setMassData(number mass [, number I, number centerX, number centerY ])
--- sets current physic RNObject massdata
-- @param mass number
-- @param I
-- @param centerX number
-- @param centerY number
function RNObject:setMassData(mass, I, centerX, centerY)
    self.physicObject:setMassData(mass, I, centerX, centerY)
end

--body:setTransform([, number positionX, number positionY, number angle ])
--- sets current physic RNObject transform
-- @param positionX number
-- @param positionY number
-- @param angle number
function RNObject:setTransform(positionX, positionY, angle)
    self.physicObject:setTransform(positionX, positionY, angle)
end

--- sets current physic RNObject angle
-- @param value number
function RNObject:setAngle(value)
    self.physicObject:setAngle(value)
end

--
-- physic bodies common working methods
--

--body:applyForce(number forceX, number forceY [, number pointX, number pointY ] )
--- applies on current physic RNObject the given force effect
-- @param forceX number
-- @param forceY number
-- @param pointX number
-- @param pointY number
function RNObject:applyForce(forceX, forceY, pointX, pointY)
    self.physicObject:applyForce(forceX, forceY, pointX, pointY)
end

--body:applyTorque(number torque)
--- applies on current physic RNObject the given torque effect
-- @param value number
function RNObject:applyTorque(value)
    self.physicObject:applyTorque(value)
end

--body:applyLinearImpulse(number impulseX, number impulseY [, number pointX, number pointY ] )
--- applies on current physic RNObject the given linear impulse
-- @param impulseX number
-- @param impulseY number
-- @param pointX number
-- @param pointY number
function RNObject:applyLinearImpulse(impulseX, impulseY, pointX, pointY)
    self.physicObject:applyLinearImpulse(impulseX, impulseY, pointX, pointY)
end

--body:applyAngularImpulse( number impulse )
--- applies on current physic RNObject the given angular impulse
-- @param value number
function RNObject:applyAngularImpulse(value)
    self.physicObject:applyAngularImpulse(value)
end


-- additional methods from last update
--- returns current physic RNObject inertia
-- @return inertia number
function RNObject:getInertia()
    return self.physicObject:getInertia()
end

--- returns current physic RNObject mass
-- @return mass number
function RNObject:getMass()
    return self.physicObject:getInertia()
end

--- sets current physic RNObject mass
-- @param mass number
-- @param I
-- @param centerX number
-- @param centerY number
function RNObject:setMassData(mass, I, centerX, centerY)
    if I ~= nil then
        self.physicObject:setMassData(mass, I, centerX, centerY)
    else
        self.physicObject:setMassData(mass)
    end
end

--fixture methods
--- returns current physic RNObject fixtures with given name
-- @param name string
-- @return table list of all the RNFixture
-- @see RNFixture
function RNObject:getFixtureListByName(name)
    local tmpFixtureList = {}
    for i, v in ipairs(self.fixture) do
        if name == v.name then
            tmpFixtureList[table.getn(tmpFixtureList) + 1] = v
        end
    end
    return tmpFixtureList
end

--- changes current physic RNObject fixtures properties with given name
-- @param name string, fixture name
-- @param property string, fixture's property name
-- @param value number/string, fixture's property value
-- @see RNFixture
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