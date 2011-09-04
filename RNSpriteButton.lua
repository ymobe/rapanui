----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------

require("RNSprite")
require("RNUtil")

-- Create a new class that inherits from a base class RNSprite
RNSpriteButton = RNSprite:new()



function RNSpriteButton.createButton(params)
    local button = RNSpriteButton:new()
    button:create(params)
    return button
end

function RNSpriteButton:setText(value)
    self.text = value
end


function RNSpriteButton:create(params)

    self.onOverImageName = params.onOverImage

    if self.onOverImageName ~= nil then
        self:loadOnOverImage(self.onOverImageName)
    end

    self:setOnTouchDown(params.onTouchDown)
    self.onOverSprite = RNSprite:new()
    self.onOverSprite:initWith(self.onOverImageName)
    self.onOverSprite:setLocation(-500, -500)

    self:initWithImageAndText(params.image, params.text)
end


function RNSpriteButton:initWith(inmage)
    RNSprite.initWith(self, inmage)
end


function RNSpriteButton:initWithImageAndText(image, text)
    RNSprite.initWith(self, image)
    self:setText(text)
    self.rnspritetext = RNSpriteText:new()
    self.rnspritetext:initWithText(text)
    self.rnspritetext:setSize(self.originalWidth, self.originalHeight)
    self:addChild(self.rnspritetext)
end

function RNSpriteButton:getText()
    return self.text
end


function RNSpriteButton:loadOnOverImage(image)
    self.onOverImageName = image

    self.onOverImageGfxQuad = MOAIGfxQuad2D.new()
    --self.texture = MOAITexture.new()

    self.onOverImageimage = MOAIImage.new()
    self.onOverImageimage:load(image, MOAIImage.TRUECOLOR + MOAIImage.PREMULTIPLY_ALPHA)

    self.onOverImageoriginalWidth, self.onOverImageoriginalHeight = self.onOverImageimage:getSize()

    self.onOverImageimage = self.onOverImageimage:padToPow2()
    self.onOverImageGfxQuad:setTexture(self.onOverImageimage)

    self.onOverImagepow2Widht, self.onOverImagepow2Height = self.onOverImageimage:getSize()

    self.onOverImageProp = MOAIProp2D.new()

    local u = self.onOverImageoriginalWidth / self.onOverImagepow2Widht
    local v = self.onOverImageoriginalHeight / self.onOverImagepow2Height

    self.onOverImageGfxQuad:setUVRect(0, 0, u, v)


    self.onOverImageProp:setDeck(self.onOverImageGfxQuad)
    self.onOverImageGfxQuad:setRect((self.onOverImageoriginalWidth / 2) * (-1), (self.onOverImageoriginalHeight / 2) * (-1), (self.onOverImageoriginalWidth) / 2, (self.onOverImageoriginalHeight) / 2)

    self.onOverImageProp:setLoc(-10000, -10000);
end

function RNSpriteButton:setParentScene(scene)
    RNSprite.setParentScene(scene)
    scene:getLayer():insertProp(self.onOverImageProp)
end

function RNSpriteButton:showOnTouchDownImage()
    self.restoreXprop, self.restoreYprop = self.prop:getLoc()
    self.prop:setLoc(-10000, -10000)
    self.onOverImageProp:setLoc(self.x, self.y)
end

function RNSpriteButton:restoreImage()
    if self.needRestore then
        self.prop:setLoc(self.restoreXprop, self.restoreYprop)
        self.onOverImageProp:setLoc(-10000, -10000)
        self.needRestore = false
    end
end

function RNSpriteButton:setLocation(x, y)
    RNSprite.setLocation(self, x, y)
    if self.rnspritetext ~= nil then
        self.rnspritetext:setLocation(x, y + 15);
    end
end


function RNSpriteButton:onTouchDown(x, y, source)

    local buttonx = x
    local buttony = y
    if (self.locatingMode == TOP_LEFT_MODE) then
        buttonx = buttonx + self.originalWidth / 2
        buttony = buttony + self.originalHeight / 2
    end

    if self.visible and buttonx >= self.x and x <= self.x + self.originalWidth and buttony >= self.y and buttony <= self.y + self.originalHeight then
        self.needRestore = true
        self:showOnTouchDownImage()
    end

    RNSprite.onTouchDown(self, x, y, source)
end

function RNSpriteButton:onTouchMove(x, y, source)
    RNSprite.onTouchMove(self, x, y, source)
end

function RNSpriteButton:onTouchUp(x, y, source)
    self:restoreImage()
    RNSprite.onTouchUp(self, x, y, source)
end

function RNSpriteButton:onTouchCancel(x, y, source)
    RNSprite.onTouchCancel(self, x, y, source)
end
