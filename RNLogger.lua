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
]]

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

