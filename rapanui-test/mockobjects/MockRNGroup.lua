-- Author: Marko Pukari
-- Date: 12/2/12

function createMockRNGroup()
	MockRNGroup = {
		newCalled = 0,
		insertCalled = 0
	}

	function MockRNGroup:new()
		self.newCalled = self.newCalled + 1 
		return self
	end
	
	function MockRNGroup:insert(rnobject)
		assert_equal(rnobject,RNObject)
		self.insertCalled = self.insertCalled + 1
	end
	
	function MockRNGroup:reset()
		self.newCalled = 0
		self.insertCalled = 0
	end

	return MockRNGroup
end