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


RNGraphicsManager = {}
RNGraphicsManager.gfx = {}


function RNGraphicsManager:allocateDeck2DGfx(path)
    local object = {}
    object.path = path

    --texture for getting size
    local texture = MOAITexture.new()
    texture:load(path)
    local sizex, sizey = texture:getSize()

    object.width = sizex
    object.height = sizey

    object.deck = MOAIGfxQuad2D.new()
    object.deck:setTexture(texture)
    object.deck:setRect(-sizex/2, -sizey/2, sizex/2, sizey/2)
    object.deck:setUVRect(0, 0, 1, 1)

    texture = nil

    RNGraphicsManager.gfx[table.getn(RNGraphicsManager.gfx) + 1] = object

    return object.deck
end

function RNGraphicsManager:allocateTileDeck2DGfx(path, sx, sy, scaleX, scaleY)


    local object = {}
    object.path = path

    --texture for getting size
    local texture = MOAITexture.new()
    texture:load(path)
    local sizex, sizey = texture:getSize()

    object.width = sizex
    object.height = sizey

    local px = sizex / sx
    local py = sizey / sy

    object.deck = MOAITileDeck2D.new()
    object.deck:setTexture(path)
    --deck:setRect(-sx * scaleX / 2, sy * scaleY / 2, sx * scaleX / 2, -sy * scaleY / 2)
    object.deck:setRect(-sx * scaleX / 2, sy * scaleY / 2, sx * scaleX / 2, -sy * scaleY / 2)
    --self.tileDeck:setSize(number width, number height [, number cellWidth, number cellHeight, number xOff, number yOff, number tileWidth, number tileHeight ] )
    object.deck:setSize(px, py, 1 / px, 1 / py, 0, 0, 1 / px, 1 / py)

    texture = nil

    RNGraphicsManager.gfx[table.getn(RNGraphicsManager.gfx) + 1] = object


    return object.deck
end

function RNGraphicsManager:allocateFont(path, charcodes, size, value)
    local object = {}
    object.path = path

    object.font = MOAIFont.new()
    object.font:loadFromTTF(path .. ".TTF", charcodes, size, value)
    object.size = size

    RNGraphicsManager.gfx[table.getn(RNGraphicsManager.gfx) + 1] = object

    return object.font
end



function RNGraphicsManager:getDeckByPath(path)
    local d
    for i, v in ipairs(RNGraphicsManager.gfx) do
        if v.path == path then
            d = v.deck
        end
    end
    return d
end

function RNGraphicsManager:getFontByPath(path)
    local d
    for i, v in ipairs(RNGraphicsManager.gfx) do
        if v.path == path then
            d = v.font
        end
    end
    return d
end


function RNGraphicsManager:getGfxByPath(path)
    local d
    for i, v in ipairs(RNGraphicsManager.gfx) do
        if v.path == path then
            d = v
        end
    end
    return d
end


function RNGraphicsManager:getGfxByDeck(deck)
    local d
    for i, v in ipairs(RNGraphicsManager.gfx) do
        if v.deck == deck then
            d = v
        end
    end
    return d
end

function RNGraphicsManager:getAlreadyAllocated(path)
    local p = false
    for i, v in ipairs(RNGraphicsManager.gfx) do
        if v.path == path then
            p = true
        end
    end
    return p
end

return RNGraphicsManager