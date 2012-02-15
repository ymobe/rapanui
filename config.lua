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
--width Moai (http://getmoai.com/) and  RapaNui in the credits of your program.
]]

module(..., package.seeall)

-- Preset for some devices you can add as many as you want
local sizes = {}

sizes["iPadDev"] = { 768, 1024, 384, 512 } -- shrunk for easier viewing
sizes["iPad"] = { 768, 1024, 768, 1024 } -- 1:1 pixel iPad
sizes["custom"] = { 400, 500, 400, 500,} -- 1:1 pixel iPad
sizes["iPhone3G"] = { 320, 480, 320, 480 }
sizes["iPhone3G2X"] = { 320, 480, 640, 960 }


local landscape = false

local device = "iPhone3G"


local screenX, screenY = MOAIEnvironment.getScreenSize()

if screenX ~= 0 then --if physical screen
    width, height, screenWidth, screenHeight = screenX, screenY, screenX, screenY
else
    width, height, screenWidth, screenHeight = sizes[device][1], sizes[device][2], sizes[device][3], sizes[device][4]
end

if landscape == true then -- flip Widths and Hieghts
    width, height = height, width
    screenWidth, screenHeight = screenHeight, screenWidth
end

landscape, device, sizes, screenX, screenY = nil