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
--]]
local background = RNFactory.createImage("images/background-blue.png")

text1 = RNFactory.createBitmapText("SCENE 1", {
    image = "images/kromasky.png",
    charcodes = " ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789:;?!\"%',.",
    top = 55,
    left = 10,
    charWidth = 16,
    charHeight = 16
})

text1:remove()

for i = 0, 1000 do


    text1 = RNFactory.createBitmapText("ISTANCE " .. i, {
        image = "images/kromasky.png",
        charcodes = " ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789:;?!\"%',.",
        top = 55,
        left = 10,
        charWidth = 16,
        charHeight = 16
    })

    memestatus(true)
    text1:remove()
    text1 = nil
    collectgarbage("collect")
end

print("End")
collectgarbage("collect")
memestatus(true)