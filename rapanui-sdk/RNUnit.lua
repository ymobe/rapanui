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
RNUnit = {}

function RNUnit.assertEquals(expected, actual, message)

    local fullMessage = "expected and actual are different"

    if (type(actual) == "string" or type(actual) == "number" or type(actual) == "nil") and
            (type(expected) == "string" or type(expected) == "number" or type(expected) == "nil") then

        local actualMessage = actual
        local expectedMessage = expected

        if actual == nil then
            actualMessage = "nil"
        end

        if expected == nil then
            expectedMessage = "nil"
        end

        fullMessage = "expected [" .. expectedMessage .. "] actual [" .. actualMessage .. "]"
    end

    if message ~= nil then
        fullMessage = fullMessage .. ": " .. message
    end
    assert(actual == expected, fullMessage)
end

function RNUnit.assertNil(actual, message)

    local fullMessage = "actual should be nil"

    if message ~= nil then
        fullMessage = fullMessage .. ": " .. message
    end
    assert(actual == nil, fullMessage)
end

function RNUnit.assertNotNil(actual, message)

    local fullMessage = "actual should not be nil"

    if message ~= nil then
        fullMessage = fullMessage .. ": " .. message
    end
    assert(actual ~= nil, fullMessage)
end

return RNUnit