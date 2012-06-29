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


--Rapanui sample on how to use atlases exported for moai with Texture Packer

--simple image
RNFactory.createImage("images/image.png")

--atlas creations
RNFactory.createAtlasFromTexturePacker("images/TPAtlasSample.png", "images/TPAtlasSample.lua")
--create some images from atlas
--create tile1 and scale it
local a = RNFactory.createImage("tile1.png", { left = 100 })
a.scaleX = 0.4
a.scaleY = 0.4
--create tile 2 and scale it horizontally and vertically
local b = RNFactory.createImage("tile2.png", { left = 200 })
--flips b
b:flipHorizontal()
b:flipVertical()
local c = RNFactory.createImage("tile3.png", { left = 200, top = 100 })
c.scaleX = -0.3
c.scaleY = -0.7
local d = RNFactory.createImage("tile4.png", { left = 100, top = 100 })
d.scaleX = 0.8
d.scaleY = 0.8



--atlas can be used as spritesheet for animations
--in fact images created from atlas are animations.
local img = RNFactory.createImage("drink.png", { top = 250, left = 150 })
--indexes are images in atlas ordered as exported from Texture Packer
img:newSequence("seq", { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, 3, 5)
img:play("seq")
