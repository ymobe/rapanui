-- Author: Marko Pukari
-- Date: 11/30/12

function createTestLayer(name,viewport,partition)
	local MockLayer = {
		setPartitionCalled = 0,
		setViewportCalled = 0,
		clearCalled = 0,
		VIEWPORT = viewport,
		PARTITION = partition

	}

	function MockLayer:setViewport(viewport)
		MockLayer.setViewportCalled = MockLayer.setViewportCalled + 1
		assert_that(viewport.name,is(equal_to(VIEWPORT.name)))
	end

	function MockLayer:setPartition(partition)
		assert_that(partition.name,is(equal_to(MockLayer.PARTITION.name))) 
		MockLayer.setPartitionCalled = MockLayer.setPartitionCalled + 1
	end

	function MockLayer:clear()
		MockLayer.clearCalled=MockLayer.clearCalled + 1
	end

	function MockLayer:reset()
		self.setPartitionCalled = 0
		self.setViewportCalled = 0
		self.clearCalled = 0	
	end

	MockLayer.name = name
	return MockLayer
end
