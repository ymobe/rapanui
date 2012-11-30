-- Author: Marko Pukari
-- Date: 11/30/12

function createPartition(name)
	local MockPartition = {
		insertPropCalled = 0,
		name="TEST_PARTITION"
	}

	function MockPartition:insertProp(property)
		MockPartition.insertPropCalled = MockPartition.insertPropCalled + 1
	end

	MockPartition.name = name

	function MockPartition:reset()
		MockPartition.insertPropCalled = 0
	end

	return MockPartition
end

