----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------

require("RNSprite")

-- Create a new class that inherits from a base class
--
--SpecialAccount = Account:new()
RNSpriteButton = RNSprite:new()


function RNSpriteButton:setText(value)
    print("text: " .. value)
    self.text = value
end

function RNSpriteButton:getText()
    return self.text
end

function RNSpriteButton:addTextbox(top, height, alignment)

    local textbox = MOAITextBox.new()
    textbox:setString(text)
    textbox:setFont(font)
    textbox:setTextSize(font:getScale())
    textbox:setRect(-150, top - height, 150, top)
    textbox:setAlignment(alignment)
    textbox:setYFlip(true)
    --layer:insertProp(textbox)
end

