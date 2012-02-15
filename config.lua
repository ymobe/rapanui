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
-- Moai (http://getmoai.com/) and  RapaNui in the credits of your program.
]]

module(..., package.seeall)

local landscape = false --true
local device = "iPhone"
local sizes = {}
sizes["iPad"] = { 768, 1024, 384, 512 }
sizes["iPadreal"] = { 768, 1024, 768, 1024 }
sizes["iPhone"] = { 320, 480, 320, 480, }


local sw, sh = MOAIEnvironment.getScreenSize()
if sw ~= 0 then
    PW, PH, SW, SH = sw, sh, sw, sh
else
    PW, PH, SW, SH = sizes[device][1], sizes[device][2], sizes[device][3], sizes[device][4]
end
sw, sh = nil, nil

if landscape == true then -- flip Widths and Hieghts
    PW, PH = PH, PW
    SW, SH = SH, SW
end