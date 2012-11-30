-- Author: Marko Pukari
-- Date: 11/30/12

function createMockMOAIPartition(partition)
	local MockMOAIPartition = {
		newCalled = 0,
		PARTITION = partition
	}

	function MockMOAIPartition.new()
		MockMOAIPartition.newCalled = MockMOAIPartition.newCalled + 1
		return MockMOAIPartition.PARTITION
	end

	function MockMOAIPartition:reset()
		self.newCalled = 0
	end

	return MockMOAIPartition
end

