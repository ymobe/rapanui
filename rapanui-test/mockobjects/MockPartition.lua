-- Author: Marko Pukari
-- Date: 11/30/12

function createPartition(name)
	local MockPartition = {
		insertPropCalled = false,
		name="TEST_PARTITION"
	}

	function MockPartition:insertProp(property)
		MockPartition.insertPropCalled = true
	end

	MockPartition.name = name

	function MockPartition:reset()
		MockPartition.insertPropCalled = false
	end

	return MockPartition
end

