module(..., package.seeall)

function assertEquals(expected, actual, message)

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

function assertNil(actual, message)

    local fullMessage = "actual should be nil"

    if message ~= nil then
        fullMessage = fullMessage .. ": " .. message
    end
    assert(actual == nil, fullMessage)
end

function assertNotNil(actual, message)

    local fullMessage = "actual should not be nil"

    if message ~= nil then
        fullMessage = fullMessage .. ": " .. message
    end
    assert(actual ~= nil, fullMessage)
end