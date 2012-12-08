module(..., package.seeall)

-- Several random tests, with arguments specified both
-- via functions and via consts.

local seed = os.time()
lunatest.set_seed(seed)
print("Seed is ", seed)

local random_bool, random_int = 
   lunatest.random_bool, lunatest.random_int
local random_float, random_string = 
   lunatest.random_float, lunatest.random_string

function test_random_bool()
   assert_random("bool is t or f",
                 function (b)
                    return b == true or b == false
                 end, true)
end


function test_random_bool2()
   assert_random("bool is t or f",
                 function ()
                    return random_bool()
                 end, true)
end


function test_random_int()
   assert_random({name="pos int", count=1000 },
                 function ()
                    local ri = random_int(1, 10) 
                    return ri >= 1 and ri <= 10
                 end)
end

function test_random_int2()
   assert_random({ name="pos int", count=1000 },
                 function (ri)
                    return ri >= 0 and ri <= 10
                 end, 10)
end

function test_neg_int()
   assert_random({ name="neg int", count=1000 },
                 function ()
                    local ni = random_int(-math.huge, 0)
                    return ni < 0
                 end)
end

function test_neg_or_pos_int()
   assert_random({ name="neg int", count=1000 },
                 function (i)
                    assert_number(i)
                    assert_gte(-400, i) 
                    assert_lte(400, i)
                 end, -400)
end


function test_random_int_trio()
   assert_random({ name="three ints", count=1000 },
                 function ()
                    local ri = random_int
                    local x, y, z = ri(0, 5), ri(10, 50), ri(50, 100)
                    assert_gt(x, y)
                    assert_gte(y, z)
                    assert_lt(z, x)
                 end)
end

function test_random_float()
   assert_random({ name="float", count=1000 },
                 function ()
                    local rf = random_float
                    assert_gt(21.5, rf(30, 40))
                 end)
end

function test_random_float2()
   assert_random({ name="float", count=1000 },
                 function (x)
                    assert_gt(0, x)
                 end, 55.5)
end


function test_random_string()
   assert_random("vowels",
                 function (x)
                    local len = string.len(x)
                    assert_lte(10, len)
                    assert_match("[aeiou]+", x)
                 end, "10 aeiou")
end

function test_random_string2()
   -- In the first argument, .always={...} is a list of seeds
   -- that will be run every trial.
   assert_random( { name="alpha",
                    always={ 6483877599982, 9948212639558 }},
                 function (x)
                    local len = string.len(x)
                    assert_gte(10, len)
                    assert_lte(30, len)
                    assert_match(".+", x)
                 end, "10,30 %a")
end

function test_coinflip()
   local function rbool() return random_bool() end
   -- typically, this would go in a metatable...
   local coin = { __random = rbool }
   assert_random("flip",
                 function(flip)
                    assert_boolean(flip)
                 end, coin)
end


function test_random_int_bounds()
   for run, pair in ipairs{ {1, 2}, {2, 10}, {-1, 1}, 
                            {-100, 100}, {-1, 0}, {0, 1} } do
      assert_random("int_bounds",
                    function()
                       local ri = random_int(pair[1], pair[2])
                       assert_gte(pair[1], ri)
                       assert_lte(pair[2], ri)
                    end)
   end
end

function test_random_int_bounds()
   for run, pair in ipairs{ {1, 2}, {2, 10}, {-1, 1}, 
                            {-100, 100}, {-1, 0}, {0, 1} } do
      assert_random("float_bounds",
                    function()
                       local ri = random_float(pair[1], pair[2])
                       assert_gte(pair[1], ri)
                       assert_lt(pair[2], ri)
                    end)
   end
end


function test_random_str_len()
   local fmt = string.format
   for _,l in ipairs{ 1, 5, 10, 15, 30 } do
      assert_random("strlen",
                    function()
                       local pat = fmt("%d %%l", l)
                       local rs = random_string(pat)
                       assert_len(l, rs)
                       assert_match("^%l+$", rs)
                    end)
   end
end


function test_random_str_range()
   local fmt = string.format
   assert_random("strlen2",
                 function()
                    local pat = fmt("%d a-z", 15)
                    local rs = random_string(pat)
                    assert_len(15, rs)
                    assert_match("^%l+$", rs)
                 end)
end
