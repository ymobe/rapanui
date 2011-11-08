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

require("RNInputManager")
require("RNUtil")


TOP_LEFT_MODE = 1
CENTERED_MODE = 2

RNRectangle = {}


local function fieldChangedListener(self, key, value)

    getmetatable(self).__object[key] = value
    self = getmetatable(self).__object

    if self.isPhysical == false then

        if key ~= nil and key == "x" then
            local tmpX = self.currentRefX + value
            local tmpY = self.y
        end

        if key ~= nil and key == "y" then
            local tmpX = self.x
            local tmpY = self.currentRefY + value
        end

        if key == "isFocus" and value == true then
            -- TODO: implement focus handling
        end
    end
end


local function fieldAccessListener(self, key)
    local object = getmetatable(self).__object
    return getmetatable(self).__object[key]
end

-- Create a new proxy for RNRectangle Object


function RNRectangle:new(o)
    local displayobject = RNRectangle:innerNew()
    local proxy = setmetatable({}, { __newindex = fieldChangedListener, __index = fieldAccessListener, __object = displayobject })
    return proxy, displayobject
end


function RNRectangle:initWith(left, top, width, height)
end

-- Create a new RNRectangle Object
function RNRectangle:innerNew(o)

    o = o or {
        name = "",
        myName = nil,
        image = nil,
        originalHeight = 0,
        originalWidth = 0,
        pow2Widht = 0,
        pow2Height = 0,
        x = 0,
        y = 0,
        absoluteX = 0,
        absoluteY = 0,
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
        --physic metamerge
        isPhysical = false,
        physicObject = nil,
        collision = nil,
        userdata = nil,
        myName = nil,
        isAwake = nil,
        setAwake = nil,
        isActive = nil,
        setActive = nil,
        isBullet = nil,
        setBullet = nil,
        isFixedRotation = nil,
        setFixedRotation = nil,
        getAngularVelocity = nil,
        setAngularVelocity = nil,
        getAngularDamping = nil,
        setAngularDamping = nil,
        getLinearVelocity = nil,
        setLinearVelocity = nil,
        setLinearDamping = nil,
        getLinearDamping = nil,
        isSensor = nil
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

function RNRectangle:loadImage(image)
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
    self.gfxQuad:setRect((self.originalWidth / 2) * (-1), (self.originalHeight / 2) * (-1), (self.originalWidth) / 2, (self.originalHeight) / 2)
end

function RNRectangle:initWith(image)
    self.visible = true
    self.childrenSize = 0
    self.alpha = 1
    self:loadImage(image)
end


function RNRectangle:getSDType()
    return "RNRectangle"
end

function RNRectangle:getChildren()
    return self.children
end

function RNRectangle:getChildat(index)
    return self.children[index]
end

function RNRectangle:addChild(sprite)
    self.children[self.childrenSize] = sprite
    self.childrenSize = self.childrenSize + 1
end

function RNRectangle:setParentScene(scene)
    self.scene = scene
end

function RNRectangle:getChildrenSize()
    return self.childrenSize
end



function RNRectangle:getGfxQuad()
    return self.gfxQuad
end

function RNRectangle:getProp()
    return self.prop
end

function RNRectangle:updateLocation()
    self:setLocation(self.x, self.y)
end

function RNRectangle:setLocatingMode(mode)
    self.locatingMode = mode
end

function RNRectangle:getOriginalWidth()
    return self.originalWidth
end

function RNRectangle:getOriginalHeight()
    return self.originalHeight
end


function RNRectangle:getLocation()
    return self.x, self.y
end

function RNRectangle:getX()
    if self.isPhyisic == false then
        return self.x
    else
        return self.physicObject:getX()
    end
end

function RNRectangle:getY()
    if self.isPhyisic == false then
        return self.y
    else
        return self.physicObject:getY()
    end
end

function RNRectangle:getAlpha()
    return self.alpha
end

function RNRectangle:setAlpha(value)
    self.alpha = value
    self.prop:setColor(1, 1, 1, value, 0)
end

function RNRectangle:getShader()
    return self.shader
end

function RNRectangle:getImage()
    return self.image
end

function RNRectangle:getLocatingMode()
    return self.locatingMode
end

function RNRectangle:setVisible(value)
    self.visible = value
end

function RNRectangle:getVisible()
    return self.visible
end


function RNRectangle:TOP_LEFT_MODE()
    return TOP_LEFT_MODE
end

function RNRectangle:setLocation(x, y)

    local tmpX = x
    local tmpY = y

    if (self:getProp() ~= nil) then
        self:getProp():setLoc(tmpX, tmpY);
    end

    self.x = x
    self.y = y
end

function RNRectangle:setY(y)

    if self.isPhysical == false then
        local tmpX = self.x
        local tmpY = self.currentRefY + y

        if (self:getProp() ~= nil) then
            self:getProp():setLoc(tmpX, tmpY);
        end
    else
        self.physicObject:setY()
    end

    self.y = y
end

function RNRectangle:setX(x)

    if self.isPhysical == false then
        local tmpX = self.currentRefX + x
        local tmpY = self.y


        if (self:getProp() ~= nil) then
            self:getProp():setLoc(tmpX, tmpY);
        end
    else
        self.physicObject:setX()
    end
    self.x = x
end

function RNRectangle:addEventListener(eventName, func)
    if eventName == "collision" then
        self.physicObject:addEventListener("collision")
    else
        RNInputManager.addListenerToEvent(eventName, func)
    end
end

function RNRectangle:isInRange(x, y)

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

function RNRectangle:onTouchDown(x, y, source)

    x = x + self.originalWidth / 2
    y = y + self.originalHeight / 2

    if self.visible and self.onTouchDownListener ~= nil and x >= self.x and x <= self.x + self.originalWidth and y >= self.y and y <= self.y + self.originalHeight then
        self.onTouchDownListener(x, y, source)
        return true
    end
end

function RNRectangle:onTouchMove(x, y, source)
    if self.visible and self.touchListener ~= nil and x >= self.x and x <= self.x + self.originalWidth and y >= self.y and y <= self.y + self.originalHeight then
        self.onTouchMoveListener(x, y, source)
        return true
    end
end

function RNRectangle:onTouchUp(x, y, source)
    if self.visible and self.touchListener ~= nil and x >= self.x and x <= self.x + self.originalWidth and y >= self.y and y <= self.y + self.originalHeight then
        self.onTouchUpListener(x, y, source)
        return true
    end
end

function RNRectangle:onTouchCancel(x, y, source)
    if self.visible and self.touchListener ~= nil and x >= self.x and x <= self.x + self.originalWidth and y >= self.y and y <= self.y + self.originalHeight then
        self.onTouchCancelListener(x, y, source)
        return true
    end
end

function RNRectangle:setOnTouchDown(func)
    self.onTouchDownListener = func
end

function RNRectangle:setOnTouchMove(func)
end

function RNRectangle:setOnTouchUp(func)
    self.onOnTouchUpListener = func
end

function RNRectangle:setOnTouchCancel(func)
end

function RNRectangle:getTranslatedLocation(x, y)
end

function RNRectangle:setParentGroup(group)
    self.parentGroup = group
end

function RNRectangle:setFillColor(r, g, b)
end


function RNRectangle:setLevel(value)
    self.level = value
end

function RNRectangle:getLevel()
    return self.level
end