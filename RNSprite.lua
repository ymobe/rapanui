----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------

module(..., package.seeall)

require("RNInputManager")
require("RNUtil")


TOP_LEFT_MODE = 1
CENTERED_MODE = 2



-- Create a new RNSprite Object
function RNSprite:new(o)

    o = o or {
        name = "",
        image = nil,
        screenWidth = 0,
        screenHeight = 0,
        originalHeight = 0,
        originalWidth = 0,
        pow2Widht = 0,
        pow2Height = 0,
        x = 0,
        y = 0,
        locatingMode = CENTERED_MODE,
        gfxQuad = nil,
        shader = nil,
        screenX = 0,
        screenY = 0,
        visible = true,
        touchListener = nil,
        onTouchDownListener = nill,
        texture = nil
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function RNSprite:initWith(image)

    self.name = image
    self.visible = true

    self.gfxQuad = MOAIGfxQuad2D.new()
    self.texture = MOAITexture.new()

    self.image = MOAIImage.new()
    self.image:load(image, MOAIImage.TRUECOLOR + MOAIImage.PREMULTIPLY_ALPHA)

    self.originalWidht, self.originalHeight = self.image:getSize()

    self.image = self.image:padToPow2()
    self.gfxQuad:setTexture(self.image)

    self.pow2Widht, self.pow2Height = self.image:getSize()

    local u = self.originalWidht / self.pow2Widht
    local v = self.originalHeight / self.pow2Height

    self.gfxQuad:setUVRect(0, 0, u, v)

    self.prop = MOAIProp2D.new()
    self.prop:setDeck(self.gfxQuad)
    self.gfxQuad:setRect((self.originalWidht / 2) * (-1), (self.originalHeight / 2) * (-1), (self.originalWidht / 2), (self.originalHeight / 2))

    self.prop:setLoc(0, 0);

    self.shader = MOAIShader.new()

    RNInputManager.addListener(self)

--    self.shader = MOAISimpleShader.new()
--self.prop:setShader(self.shader)
end

function RNSprite:getImageName()
    return self.name
end

function RNSprite:getGfxQuad()
    return self.gfxQuad
end

function RNSprite:getProp()
    return self.prop
end

function RNSprite:setScreenSize(width, height)
    self.screenWidth = width
    self.screenHeight = height
end

function RNSprite:getScreenSize()
    return self.screenWidth, self.screenHeight
end

function RNSprite:updateLocation()
    self:setLocation(self.screenX, self.screenY)
end

function RNSprite:setLocatingMode(mode)
    self.locatingMode = mode
end

function RNSprite:getOriginalWidth()
    return self.originalWidht
end

function RNSprite:getOriginalHeight()
    return self.originalHeight
end


function RNSprite:getLocation()
    return self.x, self.y
end

function RNSprite:getX()
    return self.x
end

function RNSprite:getY()
    return self.y
end

function RNSprite:setAlpha(value)
-- self.shader:setColor(value, value, value, 0)
    self.image:setRGBA(value, value, value, 0)
end


function RNSprite:getShader()
    return self.shader
end

function RNSprite:getImage()
    return self.image
end

function RNSprite:getLocatingMode()
    return self.locatingMode
end

function RNSprite:setVisible(value)
    print("Called on x of " .. self.name .. " setting visibility for sprite ")
    print(value)
    self.visible = value
end

function RNSprite:getVisible()
    return self.visible
end



function RNSprite:setLocation(x, y)

    self.screenX = x;
    self.screenY = y

    if (self.locatingMode == TOP_LEFT_MODE) then
        self.x = x + self.originalWidht / 2
        self.y = y + self.originalHeight / 2
    else
        self.x = x
        self.y = y
    end

    if (self:getProp() ~= nil) then
        self:getProp():setLoc(self.x, self.y);
        local locX, locy = self:getProp():getLoc();
    end
end

function RNSprite:onTouchDown(x, y)

    if (self.locatingMode == TOP_LEFT_MODE) then
        x = x + self.originalWidht / 2
        y = y + self.originalHeight / 2
    else
        self.x = x
        self.y = y
    end

    if self.visible and self.onTouchDownListener ~= nil and x >= self.x and x <= self.x + self.originalWidht and y >= self.y and y <= self.y + self.originalHeight then
        print(os.date() .. "onTouchDown Called on x of " .. self.name)
        self.onTouchDownListener(x, y)
    end
end

function RNSprite:onTouchMove(x, y)
    if self.visible and self.touchListener ~= nil and x >= self.x and x <= self.x + self.originalWidht and y >= self.y and y <= self.y + self.originalHeight then
        print("onTouchMove Called on x of " .. self.name)
        self.onTouchMoveListener(x, y)
    end
end

function RNSprite:onTouchUp(x, y)
    if self.visible and self.touchListener ~= nil and x >= self.x and x <= self.x + self.originalWidht and y >= self.y and y <= self.y + self.originalHeight then
        print("onTouchUp Called on x of " .. self.name)
        self.onTouchUpListener(x, y)
    end
end

function RNSprite:onTouchCancel(x, y)
    if self.visible and self.touchListener ~= nil and x >= self.x and x <= self.x + self.originalWidht and y >= self.y and y <= self.y + self.originalHeight then
        print("onTouchCancel Called on x of " .. self.name)
        self.onTouchCancelListener(x, y)
    end
end

function RNSprite:setOnTouchDown(func)
    print("setOnTouchDown  " .. self.name)
    print_r(func)
    self.onTouchDownListener = func
end

function RNSprite:setOnTouchMove(func)
end

function RNSprite:setOnTouchUp(func)
end

function RNSprite:setOnTouchCancel(func)
end

function RNSprite:getTranslatedLocation(x, y)
end





