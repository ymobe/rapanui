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
-- width Moai (http://getmoai.com/) and  RapaNui in the credits of your program.
--]]

--module(..., package.seeall)

config = {}
config.sizes = {}

-- Preset for some devices you can add as many as you want
-- WARNING
-- if the size of the moai window it's bigger than your real screen size (the computer on which you dev)
-- there are bugs on RNObject placement and on touch input x,y coords so try to stay in your computer resolution
--

config.sizes["iPadDev"] = { 768, 1024, 384, 512 } -- shrunk for easier viewing
config.sizes["iPad"] = { 768, 1024, 768, 1024 } -- 1:1 pixel iPad
config.sizes["iPhone3G"] = { 320, 480, 320, 480 }
config.sizes["iPhone4Full"] = { 640, 960, 640, 960 }
config.sizes["iPhone3G_500_750"] = { 320, 480, 500, 750 } -- 3G screen ratio upscaled to 500x750
config.sizes["AcerLiquidMetal"] = { 480, 800, 480, 800 }
config.sizes["test"] = { 700, 1024, 700, 1024 }
config.sizes["test2"] = { 200, 400, 200, 400 }
config.sizes["test3"] = { 100, 500, 100, 500 }



--set lanscape mode and device
config.landscape = false
config.device = "iPhone3G"

--set stretch and graphics design
--this will stretch your graphics to fit device screen size
--but you need to set for which sizes your assets are originally designed for
--letterbox is to enable letterboxing
--drawOnBlackBars is to writing on blackBars
--change values with care if you are on landscape


config.stretch = { status = false, letterbox = false, drawOnBlackBars = false, graphicsDesign = { w = 640, h = 960 } }

--this is for iOS. Set it to true if you enabled the status bar in your Moai xCode Project, to keep screen touch configured properly.
config.iosStatusBar = false

return config
