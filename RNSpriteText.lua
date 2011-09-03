----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------

require("RNSprite")

-- Create a new class that inherits from a base class RNSprite
RNSpriteText = RNSprite:new()

function RNSpriteText:initWithText(text)

    local top = 230
    local height = 160
    local step = 160

    self.charcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-'

    self.font = MOAIFont.new()
    self.font:loadFromTTF('arial-rounded.TTF', self.charcodes, 10, 163)

    self.locatingMode = CENTERED_MODE
    self.text = text

    self.name = image
    self.visible = true
    self.image = MOAIImage.new()
    self.originalWidth, self.originalHeight = self.image:getSize()

    self.textbox = MOAITextBox.new()
    self.prop = self.textbox

    self.textbox:setString(text)
    self.textbox:setFont(self.font)
    self.textbox:setTextSize(self.font:getScale())
    self.textbox:setRect(0, 0, 120, 60)
    self.textbox:setAlignment(MOAITextBox.LEFT_JUSTIFY)

--RNInputManager.addListener(self)
end

function RNSpriteText:setSize(width, height)
    print("RNSpriteText:setSize x: " .. self.x .. "y: " .. self.y .. " width: " .. width .. " height: " .. height)
    self.textbox:setRect(self.x, self.y, self.x + width, self.y + height)
end


function RNSpriteText:setText(text)
    self.textbox:setString(text)
end