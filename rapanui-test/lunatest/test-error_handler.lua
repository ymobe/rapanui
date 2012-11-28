require "lunatest"

-- This should error out with a more meaningful error message
-- than "./lunatest.lua:608: attempt to index local 'e' (a function value)".
function test_foo()
   error(function() return 2 end)
end

lunatest.run()
