----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------

RNLogger = {}

-- Create a new RNSprite Object
function RNLogger:new(o)

    o = o or {
        enabled = true
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function RNLogger:log(text)
    if self.enabled then
        print(text)
    end
end

