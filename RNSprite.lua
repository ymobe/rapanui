----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------

module(..., package.seeall)


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
        texture = nil
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function RNSprite:initWith(image)

    self.name = image

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
    self.shader = MOAISimpleShader.new()
    self.prop:setShader(self.shader)
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
    self.shader:setColor(value, value, value, 0)
end

function RNSprite:getShader()
    return self.shader
end

function RNSprite:getLocatingMode()
    return self.locatingMode
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

function RNSprite:getTranslatedLocation(x, y)
end





