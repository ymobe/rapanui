-- Author: Marko Pukari
-- Date: 11/30/12

function createRNObject(name,prop)
	local MockRNObject = {
		setLocatingModeCalled = 0,
		setParentSceneCalled = 0,
		updateLocationCalled = 0,
		MOAIPROP = prop,
		name = name
	}

	function MockRNObject:getProp()
		return self.MOAIPROP
	end

	function MockRNObject:setLocatingMode(mode)
		self.setLocatingModeCalled = self.setLocatingModeCalled + 1
	end

	function MockRNObject:setParentScene(object)
		self.setParentSceneCalled = self.setParentSceneCalled + 1
	end

	function MockRNObject:updateLocation()
		self.updateLocationCalled = self.updateLocationCalled + 1
	end

	function MockRNObject:reset()
		self.setLocatingModeCalled = 0
		self.setParentSceneCalled = 0
		self.updateLocationCalled = 0
	end

	return MockRNObject
end
