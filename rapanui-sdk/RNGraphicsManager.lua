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
    object.deck:setRect(-sizex / 2, -sizey / 2, sizex / 2, sizey / 2)
    object.deck:setUVRect(0, 0, 1, 1)

    texture = nil
    object.isInAtlas = false

    RNGraphicsManager.gfx[table.getn(RNGraphicsManager.gfx) + 1] = object

    return object.deck
end

function RNGraphicsManager:allocateTileset(image, tileW, tileH)

    local object = {}

    -- check the new size of the image and update the width height
    object.path = image
    local moaiimage = MOAIImage.new()
    moaiimage:load(image, MOAIImage.TRUECOLOR + MOAIImage.PREMULTIPLY_ALPHA)
    object.width, object.height = moaiimage:getSize()

    object.deck = MOAITileDeck2D.new()
    object.deck:setTexture(object.path)
    object.deck:setSize(object.width / tileW, object.height / tileH)
    object.deck:setRect(-0.5, 0.5, 0.5, -0.5)

    moaiimage = nil

    RNGraphicsManager.gfx[table.getn(RNGraphicsManager.gfx) + 1] = object

    return object
end

function RNGraphicsManager:deallocateGfx(path, garbagecollect)
    local indexToRemove
    for i, v in ipairs(self.gfx) do
        if v.path == path then
            indexToRemove = i
        end
    end
    if indexToRemove ~= nil then
        local object = self.gfx[indexToRemove]
        for i = indexToRemove, #self.gfx - 1 do
            self.gfx[i] = self.gfx[i + 1]
        end
        self.gfx[#self.gfx] = nil
        object.deck = nil
        object = nil

        if garbagecollect then
            --free memory and OpenGL
            MOAISim.forceGarbageCollection()
        end
    end
end

function RNGraphicsManager:loadAtlas(lua, png)
    local frames = dofile(lua).frames

    local tex = MOAITexture.new()

    tex:load(png)
    local xtex, ytex = tex:getSize()

    -- Construct the deck
    local deck = MOAIGfxQuadDeck2D.new()
    deck:setTexture(tex)
    deck:reserve(#frames)
    local names = {}
    local sizes = {}


    -- Annotate the frame array with uv quads and geometry rects
    for i, frame in ipairs(frames) do
        -- convert frame.uvRect to frame.uvQuad to handle rotation
        local uv = frame.uvRect
        local q = {}
        if not frame.textureRotated then
            -- From Moai docs: "Vertex order is clockwise from upper left (xMin, yMax)"
            q.x0, q.y0 = uv.u0, uv.v0
            q.x1, q.y1 = uv.u1, uv.v0
            q.x2, q.y2 = uv.u1, uv.v1
            q.x3, q.y3 = uv.u0, uv.v1
        else
            -- Sprite data is rotated 90 degrees CW on the texture
            -- u0v0 is still the upper-left
            q.x3, q.y3 = uv.u0, uv.v0
            q.x0, q.y0 = uv.u1, uv.v0
            q.x1, q.y1 = uv.u1, uv.v1
            q.x2, q.y2 = uv.u0, uv.v1
        end
        frame.uvQuad = q

        -- convert frame.spriteColorRect and frame.spriteSourceSize
        -- to frame.geomRect.  Origin is at x0,y0 of original sprite
        local cr = frame.spriteColorRect
        local r = {}
        r.x0 = cr.x - cr.width / 2
        r.y1 = cr.y - cr.height / 2
        r.x1 = cr.x + cr.width / 2
        r.y0 = cr.y + cr.height / 2
        frame.geomRect = r

        local q = frame.uvQuad
        local r = frame.geomRect
        names[frame.name] = i
        sizes[i] = { w = frame.spriteSourceSize.width, h = frame.spriteSourceSize.height }
        deck:setUVQuad(i, q.x0, q.y0, q.x1, q.y1, q.x2, q.y2, q.x3, q.y3)
        deck:setRect(i, r.x0, r.y0, r.x1, r.y1)
    end

    return deck, names, sizes
end

function RNGraphicsManager:allocateTexturePackerAtlas(image, file)
    local deck, names, sizes = self:loadAtlas(file, image)
    local object = {}
    object.deck = deck
    object.names = names
    object.sizes = sizes
    object.isInAtlas = true
    object.path = image



    RNGraphicsManager.gfx[table.getn(RNGraphicsManager.gfx) + 1] = object
end

function RNGraphicsManager:allocateTileDeck2DGfx(path, sx, sy)

    local scaleX = 1
    local scaleY = 1

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
    object.isInAtlas = false


    RNGraphicsManager.gfx[table.getn(RNGraphicsManager.gfx) + 1] = object



    return object.deck
end

function RNGraphicsManager:allocateFont(path)
    local object = {}
    object.path = path

    object.font = MOAIFont.new()
    object.font:load(path)
    object.isInAtlas = false


    RNGraphicsManager.gfx[table.getn(RNGraphicsManager.gfx) + 1] = object

    return object.font
end



function RNGraphicsManager:getDeckByPath(path)
    local d
    local n
    for i, v in ipairs(RNGraphicsManager.gfx) do
        if v.path == path then
            d = v.deck
        end
        --if it is in altas
        if v.names ~= nil then
            for j, k in pairs(v.names) do
                if j == path then
                    d = v.deck
                    n = k
                end
            end
        end
    end
    return d, n
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
        --if it's in atlas
        if v.names ~= nil then
            for j, k in pairs(v.names) do
                if j == path then
                    d = v
                end
            end
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
        --if it's in atlas
        if v.names ~= nil then
            for j, k in pairs(v.names) do
                if j == path then
                    p = true
                end
            end
        end
    end
    return p
end


return RNGraphicsManager