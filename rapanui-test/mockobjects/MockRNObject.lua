-- Author: Marko Pukari
-- Date: 11/30/12

function createRNObject(name,prop)
	local MockRNObject = {
		setLocatingModeCalled = 0,
		setParentSceneCalled = 0,
		updateLocationCalled = 0,
		newCalled = 0,
		initWithImage2Called = 0,
		MOAIPROP = prop,
		name = name,
		originalWidth = MockConstants.ORIGINALWIDTH,
		originalHeight = MockConstants.ORIGINALHEIGHT
	}

	function MockRNObject:new()
		self.newCalled = self.newCalled + 1
		return self
	end

	function MockRNObject:initWithImage2(image)
		self.initWithImage2Called = self.initWithImage2Called + 1
		return self,{}

	end

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
		self.newCalled = 0
	end

	return MockRNObject
end
