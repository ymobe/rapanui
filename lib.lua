--[[
The MIT License (MIT)
Copyright (c) 2011 Reflare UG
https://github.com/reflare/Moai-Libraries
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files 
(the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

local M = {}

------------------------------------------
-- Extended Print for Tables
------------------------------------------
M.originalPrint = print
M.print = function ( data )
	if type(data) == "table" then
		M.originalPrint("\nTable:\n")
		for a,b in pairs(data) do M.originalPrint("\tKey: "..tostring(a), "Value: "..tostring(b)) end
	else
		M.originalPrint(data)
	end
end

------------------------------------------
-- Debug printing
------------------------------------------
M.isDebug = true

M.prnt = function ( data )
	if M.isDebug then
		M.originalPrint( data )
	end
end


local button = {}
function M.makebutton(dir, x, y, func)
	local n = #button + 1
	button[n] = RNFactory.createImage(dir,{parentGroup=mainGroup})
	button[n].x = x
	button[n].y = y
	button[n].active = false
	button[n].action = func
	button[n]:addEventListener("touch", M.buttonTouched)
	return button[n]
end

local function ptInside(obj, x, y)
	local inside = false
	local objx = obj.x - (obj.originalWidth *.5)
	local objy = obj.y - (obj.originalHeight *.5)
	if (x >= objx) and
		(x <= (objx + obj.originalWidth)) and
		(y >= objy) and
		(y <= (objy + obj.originalHeight)) then
		inside = true
	end
	return inside
end

function M.buttonTouched(e)
	local t = e.target
	local function itstarted()
		t:setAlpha(.5)
		t.active = true
		t.y = t.y + 5
	end
	local function itended()
		t.y = t.y - 5
		t.active = false
		t:setAlpha(1)
		t.action()
	end
	if e.phase == "began" then
		itstarted()
	elseif e.phase == "moved" then
		if ptInside(t, e.x, e.y) and not t.active then
			itstarted()
		end
	elseif e.phase == "ended" and t.active then
		itended()
		if ptInside(t, e.x, e.y) then
			things.performWithDelay(100,startgame)
		end
	end
end

return l
