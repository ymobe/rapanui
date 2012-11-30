-- Author: Marko Pukari
-- Date: 11/30/12

function createRNObject(name,prop)
	local MockRNObject = {
		setLocatingModeCalled = false,
		setParentSceneCalled = false,
		updateLocationCalled = false,
		PROP = prop
	}
	
	function MockRNObject:getProp()
		return self.PROP
	end

	function MockRNObject:setLocatingMode(mode)
		self.setLocatingModeCalled = true
	end

	function MockRNObject:setParentScene(object)
		self.setParentSceneCalled = true
	end

	function MockRNObject:updateLocation()
		self.updateLocationCalled = true
	end

	return MockRNObject
end
