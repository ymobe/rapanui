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

--images,animations,atlases and maps assets cache is handled by RapaNui
--but maybe you want to deallocate assets you won't need no more in your game

--sample on how to deallocate images assets from memory




--uncomment this whole block to see how to remove an image asset from memory
--create an image
image = RNFactory.createImage("images/tile0.png", { left = 100 })


function t(event)
    if event.phase == "began" then
        --onTouch we remove object, asset and create a new image
        image:remove()
        RNFactory.removeAsset("images/tile0.png")
        image = RNFactory.createImage("images/tile0.png", { left = 100 })
    end
end

RNListeners:addEventListener("touch", t)






--uncomment this whole block to see how to remove an animation asset from memory
--[[
--create an animation
anim = RNFactory.createAnim("images/ektor.png", 32, 32, 100, 100)


function t(event)
    if event.phase == "began" then
        --onTouch we remove object, asset and create a new animation
        anim:remove()
        RNFactory.removeAsset("images/ektor.png")
        anim = RNFactory.createAnim("images/ektor.png", 32, 32, 100, 100)
    end
end

RNListeners:addEventListener("touch", t)
]] --





--uncomment this whole block to see how to remove an atlas asset from memory
--[[
--create atlas and image
RNFactory.createAtlasFromTexturePacker("images/TPAtlasSample.png", "images/TPAtlasSample.lua")
image = RNFactory.createImage("tile1.png", { left = 100 })


function t(event)
    if event.phase == "began" then
        --onTouch we remove object, asset and create a new atlas and image
        image:remove()
        RNFactory.removeAsset("images/TPAtlasSample.png")
        RNFactory.createAtlasFromTexturePacker("images/TPAtlasSample.png", "images/TPAtlasSample.lua")
        image = RNFactory.createImage("tile1.png", { left = 100 })
    end
end

RNListeners:addEventListener("touch", t)
]] --




--uncomment this whole block to see how to remove a font asset from memory
--create a text
--[[
text1 = RNFactory.createText("Hello world!", { font = "arial-rounded", size = 10, top = 5, left = 5, width = 200, height = 50 })

--MOAI BUG: FONTS ARE NOT FREED FROM MEMORY
function t(event)
    if event.phase == "began" then
        --onTouch we remove text, font and create a new text
        text1:remove()
        RNFactory.removeAsset("arial-rounded")
        text1 = RNFactory.createText("Hello world!", { font = "arial-rounded", size = 10, top = 5, left = 5, width = 200, height = 50 })
    end
end

RNListeners:addEventListener("touch", t)
]] --





--uncomment this whole block to see how to remove a physics object and relative assets from memory
--[[
--start simulation,create an image, an animation and send them to physics
RNPhysics.start()
image = RNFactory.createImage("images/tile0.png", { left = 100 })
anim = RNFactory.createAnim("images/ektor.png", 32, 32, 100, 100)
RNPhysics.createBodyFromImage(image)
RNPhysics.createBodyFromImage(anim)


function t(event)
    if event.phase == "began" then
        --onTouch we remove objects, assets and create a new ones
        image:remove()
        anim:remove()
        RNFactory.removeAsset("images/tile0.png")
        RNFactory.removeAsset("images/ektor.png")
        image = RNFactory.createImage("images/tile0.png", { left = 100 })
        anim = RNFactory.createAnim("images/ektor.png", 32, 32, 100, 100)
        RNPhysics.createBodyFromImage(image)
        RNPhysics.createBodyFromImage(anim)
    end
end

RNListeners:addEventListener("touch", t)
]] --


--uncomment this whole block to see how to remove a map asset from memory
--create a map
--[[
map = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/maps/rpgmap.tmx")


aTileset = map:getTileset(0)
aTileset:updateImageSource("rapanui-samples/maps/rpgtileset.png")

map:drawMapAt(0, 0, aTileset)


function t(event)
    if event.phase == "began" then
        --onTouch we remove map,tileset and assets. Then we create a newer one
        aTileset:remove()
        map:remove()
        map = nil
        aTileset = nil
        RNFactory.removeAsset("rapanui-samples/maps/rpgtileset.png")
        map = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/maps/rpgmap.tmx")
        aTileset = map:getTileset(0)
        aTileset:updateImageSource("rapanui-samples/maps/rpgtileset.png")
        map:drawMapAt(0, 0, aTileset)
    end
end

RNListeners:addEventListener("touch", t)
]] --