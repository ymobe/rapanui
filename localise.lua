local RN = {}
RN.config = require("RN/config")
RN.Util = require("RN/RNUtil")
RN.Thread = require("RN/RNThread")
RN.Group = require("RN/RNGroup")
RN.Screen = require("RN/RNScreen")
RN.Listeners = require("RN/RNListeners")
RN.Transition = require("RN/RNTransition")
RN.MainThread = require("RN/RNMainThread")
RN.Object = require("RN/RNObject")
RN.Text = require("RN/RNText")
RN.Body = require("RN/RNBody")
RN.Director = require("RN/RNDirector")
RN.Fixture = require("RN/RNFixture")
RN.Joint = require("RN/RNJoint")
RN.Physics = require("RN/RNPhysics")
RN.Unit = require("RN/RNUnit")
RN.WrappedEventListener = require("RN/RNWrappedEventListener")
RN.WrappedTimedAction = require("RN/RNWrappedTimedAction")
RN.Event = require("RN/RNEvent")
RN.socket = require("socket")
RN.Factory = require("RN/RNFactory")
RN.InputManager = require("RN/RNInputManager")

function RN.init()
	RN.Factory.init(RN.config.PW, RN.config.PH, RN.config.SW, RN.config.SH)
end

return RN