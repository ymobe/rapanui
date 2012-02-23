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

RNEvent = {}

function RNEvent:new(o)
    o = o or {
        name = ""
    }
    setmetatable(o, self)
    self.__index = self
    self.x = 0
    self.y = 0
    self.phase = ""
    return o
end

function RNEvent:initWithEventType(eventType)

    if (eventType == MOAITouchSensor.TOUCH_DOWN) then
        self.phase = "began"
    end

    if (eventType == MOAITouchSensor.TOUCH_MOVE) then
        self.phase = "moved"
    end

    if (eventType == MOAITouchSensor.TOUCH_UP) then
        self.phase = "ended"
    end

    if (eventType == MOAITouchSensor.TOUCH_CANCEL) then
        self.phase = "cancelled"
    end
end

return RNEvent
