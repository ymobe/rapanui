-- Author: Marko Pukari
-- Date: 11/30/12

function createPartition(name)
	local MockPartition = {
		insertPropCalled = 0,
		removePropCalled = 0,
		name="TEST_PARTITION"
	}

	function MockPartition:insertProp(prop)
		self.insertPropCalled = self.insertPropCalled + 1
	end

	function MockPartition:removeProp(prop)
		self.removePropCalled = self.removePropCalled + 1
	end

	MockPartition.name = name

	function MockPartition:reset()
		self.insertPropCalled = 0
		self.removePropCalled = 0
	end

	return MockPartition
end

