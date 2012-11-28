--
--- @author Janne Sinivirta
--

-- required core global functions
local type = type
local string = string

-- ##############
-- #  Matchers  #
-- ##############

--- Matcher to check == equality
function equal_to(object)
    return {
        matches = function(value) return object == value end,
        describe = "equal to " .. object
    }
end

--- Purely syntactic sugar. You can for example say assert_that(2, is(equal_to(2)))
function is(matcher)
    return {
        matches = function(value) return matcher.matches(value) end,
        describe = matcher.describe
    }
end

--- Matcher to negate the result of enclosed Matcher
function is_not(matcher)
    return {
        matches = function(value) return not matcher.matches(value) end,
        describe = "not " .. matcher.describe
    }
end

--- Matcher for nil. Should be named nil but that is of course a reserved word
function is_nil()
    return {
        matches = function(value) return value == nil end,
        describe = "nil"
    }
end

--- Matcher to check == equality
function of_type(expected_type)
    return {
        matches = function(value)
            return type(value) == expected_type, type(value)
        end,
        describe = "type " .. expected_type
    }
end

--- Matcher to check if string contains a given substring
function contains_string(substring)
    return {
        matches = function(value) return type(value) == "string" and type(substring) == "string" and string.find(value, substring) ~= nil end,
        describe = "contains " .. substring
    }
end

--- Matcher to check if string starts with a given substring
function starts_with(substring)
    return {
        matches = function(value) return type(value) == "string" and type(substring) == "string" and string.find(value, substring) == 1 end,
        describe = "starts with " .. substring
    }
end

--- Matcher to check == equality
function equals_ignoring_case(object)
    return {
        matches = function(value) return type(value) == "string" and type(object) == "string" and string.lower(object) == string.lower(value) end,
        describe = "equal to " .. object .. " ignoring case"
    }
end
