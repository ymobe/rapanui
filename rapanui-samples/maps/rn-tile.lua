------------------------------------------------------------------------------------------------------------------------
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
--
------------------------------------------------------------------------------------------------------------------------
-- 40 , 40, 80, 80, 0, 0

local params = {
    top = 50,
    left = 160,
    srcXMin = 40,
    srcYMin = 40,
    srcXMax = 80,
    srcYMax = 80,
    destXMin = 0,
    destYMin = 0
}

--destXMax	( number ) Optional. Default value is destXMin + srcXMax - srcXMin;
--destYMax	( number ) Optional. Default value is destYMin + srcYMax - srcYMin;
--filter	( number ) Optional. One of MOAIImage.FILTER_LINEAR, MOAIImage.FILTER_NEAREST. Default value is MOAIImage.FILTER_LINEAR.

anImage = RNFactory.createCopyRect("rapanui-samples/maps/tilesetdemo.png", params)


local params = {
    top = 150,
    left = 160,
    srcXMin = 80,
    srcYMin = 80,
    srcXMax = 120,
    srcYMax = 120,
    destXMin = 0,
    destYMin = 0,
}
src = RNFactory.createMoaiImage("rapanui-samples/maps/tilesetdemo.png")

print(src:getSize())
anImage = RNFactory.createCopyRect(src, params)
