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


--spritesheetlilia = RNFactory.createImage("images/lilia.png")
--spritesheetlilia.x = 48
--spritesheetlilia.y = 64


liliaChar = RNFactory.createAnim("images/lilia.png", 32, 32, 140, 50, 1, 1)

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
--spritesheetlilia.x = 50
--spritesheetlilia.y = 100


--simple animation which plays the default sequence
--ektorspritesheet = RNFactory.createImage("images/ektor.png")

--ektorspritesheet.x = 48
--ektorspritesheet.y = 250


ektorChar = RNFactory.createAnim("images/ektor.png", 32, 32)


function onEndSEktor()
    ektorChar:flipVertical()

    ektorChar:play("walkFront")
end


ektorChar:newSequence("walkFront", { 1, 2, 3, 2 }, 6, 10, onEndSEktor)

ektorChar.x = 200
ektorChar.y = 250


ektorChar.scalex = 2
ektorChar.scaley = 2


ektorChar:flipHorizontal()
ektorChar:flipVertical()

ektorChar:play()

ektorChar:play("walkFront", 12, 5)