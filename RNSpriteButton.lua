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


function RNSpriteButton:setText(value)
    print("text: " .. value)
    self.text = value
end

function RNSpriteButton:create(params)
    print("Create")
    print_r(props)


    self.onOverImage = params.onOverImage --= "buttonBlueOver.png",
    self:setOnTouchDown(params.onTouchDown)

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




function RNSpriteButton:setLocation(x, y)

    print("setlocation override")
    RNSprite.setLocation(self, x, y)
    if self.rnspritetext ~= nil then
        self.rnspritetext:setLocation(x, y + 15);
    end
--self.screenX = x;
--self.screenY = y

--if (self.locatingMode == TOP_LEFT_MODE) then
--        self.x = x + self.originalWidth / 2
--        self.y = y + self.originalHeight / 2
--    else
--        self.x = x
--        self.y = y
--   end

--    if (self:getProp() ~= nil) then
--        self:getProp():setLoc(self.x, self.y);
--        local locX, locy = self:getProp():getLoc();
--    end
end