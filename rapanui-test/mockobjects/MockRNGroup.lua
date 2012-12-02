-- Author: Marko Pukari
-- Date: 12/2/12

function createMockRNGroup()
	MockRNGroup = {
		newCalled = 0
	}

	function MockRNGroup:new()
		self.newCalled = self.newCalled + 1 
		return self
	end
	
	return MockRNGroup
end