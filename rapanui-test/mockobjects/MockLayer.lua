-- Author: Marko Pukari
-- Date: 11/30/12

function createTestLayer(name,viewport,partition)
	local MockLayer = {
		setPartitionCalled = 0,
		setViewportCalled = 0,
		clearCalled = 0,
		insertPropCalled = 0,
		MOAIVIEWPORT = viewport,
		MOAIPARTITION = partition,
		name = name
	}

	function MockLayer:setViewport(viewport)
		MockLayer.setViewportCalled = MockLayer.setViewportCalled + 1
		assert_that(viewport.name,is(equal_to(MockLayer.MOAIVIEWPORT.name)))
	end

	function MockLayer:setPartition(partition)
		assert_that(partition.name,is(equal_to(MockLayer.MOAIPARTITION.name))) 
		MockLayer.setPartitionCalled = MockLayer.setPartitionCalled + 1
	end

	function MockLayer:clear()
		MockLayer.clearCalled=MockLayer.clearCalled + 1
	end

	function MockLayer:insertProp(prop)
		self.insertPropCalled = self.insertPropCalled + 1
		self.MOAIPARTITION:insertProp(prop)
	end

	function MockLayer:reset()
		self.setPartitionCalled = 0
		self.setViewportCalled = 0
		self.clearCalled = 0
		self.insertPropCalled = 0
		self.removePropCalled = 0
	end

	function MockLayer:removeProp(prop)
		self.removePropCalled = self.removePropCalled + 1
		self.MOAIPARTITION:removeProp(prop)
	end


	return MockLayer
end
