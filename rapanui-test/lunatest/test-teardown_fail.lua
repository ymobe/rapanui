require "lunatest"

function busywait(n)
   n = n or 10000
   for i=1,n do
      for j=1,n do
         -- no-op
      end
   end
end

function setup(n)
   -- show that test case time does not include setup
   busywait()
end

local teardown_count = 0

function teardown(n)
   teardown_count = teardown_count + 1
   if teardown_count > 1 then error("*boom*") end
end

function test_fail_but_expect_teardown()
   error("fail whale")
end

function test_fail_but_expect_teardown_2()
   error("boom")
end

local caught_teardown_error = false

xpcall(lunatest.run(), function(x)
                          print("ARGH", x)
                          caught_teardown_error = true
                       end)

assert(caught_teardown_error, "Didn't catch teardown failure.")
