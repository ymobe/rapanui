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
config = require("config")


RNObject = require("rapanui-sdk/RNObject")

RNText = require("rapanui-sdk/RNText")

RNButton = require("rapanui-sdk/RNButton")

RNEvent = require("rapanui-sdk/RNEvent")
RNScreen = require("rapanui-sdk/RNScreen")
RNWrappedEventListener = require("rapanui-sdk/RNWrappedEventListener")
RNLayer = require("rapanui-sdk/RNLayer")

-- Touch Listeners requires

RNListeners = require("rapanui-sdk/RNListeners")
RNInputManager = require("rapanui-sdk/RNInputManager")

RNUtil = require("rapanui-sdk/RNUtil")
RNUnit = require("rapanui-sdk/RNUnit")
RNGroup = require("rapanui-sdk/RNGroup")


RNTransition = require("rapanui-sdk/RNTransition")
RNPhysics = require("rapanui-sdk/RNPhysics")

RNBody = require("rapanui-sdk/RNBody")
RNJoint = require("rapanui-sdk/RNJoint")
RNFixture = require("rapanui-sdk/RNFixture")


-- Threads requires

RNThread = require("rapanui-sdk/RNThread")
RNMainThread = require("rapanui-sdk/RNMainThread")

-- Director requires

RNDirector = require("rapanui-sdk/RNDirector")

-- Maps requires

RNMap = require("rapanui-sdk/RNMap")
RNMapLayer = require("rapanui-sdk/RNMapLayer")
RNMapObject = require("rapanui-sdk/RNMapObject")
RNMapObjectGroup = require("rapanui-sdk/RNMapObjectGroup")
RNMapTileset = require("rapanui-sdk/RNMapTileset")
RNTiledMapParser = require("rapanui-sdk/RNTiledMapParser")
RNTiledLuaMapParser = require("rapanui-sdk/RNTiledLuaMapParser")

RNMapFactory = require("rapanui-sdk/RNMapFactory")
RNFactory = require("rapanui-sdk/RNFactory")

RNListView = require("rapanui-sdk/RNListView")

RNPageSwipe = require("rapanui-sdk/RNPageSwipe")

RNTimer = require("rapanui-sdk/RNTimer")

RNGraphicsManager = require("rapanui-sdk/RNGraphicsManager")

RNBitmapText = require("rapanui-sdk/RNBitmapText")
--starts main thread
RNMainThread.startMainThread()

