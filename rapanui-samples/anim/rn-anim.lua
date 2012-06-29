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

background = RNFactory.createImage("images/background-purple.png")



liliaChar = RNFactory.createAnim("images/lilia.png", 32, 32, 140, 50, 2, 2)

function onEndS1()
    liliaChar:play("walkBack")
end

function onEndS2()
    liliaChar:play("walkLeft")
end

function onEndS3()
    liliaChar:play("walkRight")
end

function onEndS4()
    liliaChar:stop()
end


liliaChar:newSequence("walkFront", { 1, 2, 3, 2 }, 6, 2, onEndS1)
liliaChar:newSequence("walkBack", { 10, 11, 12, 11 }, 6, 2, onEndS2)
liliaChar:newSequence("walkLeft", { 4, 5, 6, 5 }, 6, 2, onEndS3)
liliaChar:newSequence("walkRight", { 7, 8, 9, 8 }, 6, 2, onEndS4)

liliaChar:play("walkFront")
liliaChar.frame = 1




ektorChar = RNFactory.createAnim("images/ektor.png", 32, 32)
ektorChar2 = RNFactory.createAnim("images/ektor.png", 32, 32)
ektorChar3 = RNFactory.createAnim("images/ektor.png", 32, 32)
ektorChar2.x = 100
ektorChar2.y = 100
ektorChar3.x = 164
ektorChar3.y = 100
ektorChar2.scaleX = -4
ektorChar2.scaleY = -4
ektorChar2.scaleX = -2
ektorChar2.scaleY = -2
ektorChar2.scaleX = 1
ektorChar2.scaleY = 1
ektorChar2.scaleX = 3
ektorChar2.scaleY = 3
ektorChar2.scaleX = 1
ektorChar2.scaleY = 1
ektorChar2.scaleX = -0.5
ektorChar2.scaleY = -0.5



function onEndSEktor()
    ektorChar:flipVertical()

    ektorChar:play("walkFront")
end


ektorChar:newSequence("walkFront", { 1, 2, 3, 2 }, 6, 10, onEndSEktor)

ektorChar.x = 200
ektorChar.y = 250


ektorChar:flipHorizontal()
ektorChar:flipVertical()

ektorChar:play()

ektorChar:play("walkFront", 12, 5)