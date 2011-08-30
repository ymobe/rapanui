----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------

module(..., package.seeall)
require("RNSprite")

-- Create a new class that inherits from a base class
--
function RNSpriteButton:new(o)

    local baseClass = RNSprite
    -- The following lines are equivalent to the SimpleClass example:

    -- Create the table and metatable representing the class.
    local new_class = { text = "default" }
    local class_mt = { __index = new_class }

    -- Note that this function uses class_mt as an upvalue, so every instance
    -- of the class will share the same metatable.
    --
    function new_class:new()
        local newinst = {}
        setmetatable(newinst, class_mt)
        return newinst
    end

    function new_class:getText()
        return self.text
    end

    function new_class:setText(text)
        self.text = text
    end

    if baseClass then
        setmetatable(new_class, { __index = baseClass })
    end

    return new_class
end



