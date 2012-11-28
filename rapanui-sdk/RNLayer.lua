-- Author: niom
-- Date: 11/25/12

RNLayer = {
	LAYER_WITH_SAME_NAME_EXISTS = "layer with same name already exists" 

}

function RNLayer:new()
	local layers = {}
	setmetatable(layers,self)
	self.__index = self
	return layers
end

function RNLayer:createLayer(name,viewport)
	local layer = MOAILayer2D.new()
	local index = table.getn(self) + 1
	
	if self:get(name) ~= nil then
		return nil,RNLayer.LAYER_WITH_SAME_NAME_EXISTS
	end

	self[index] = {} 
	self[index].layer = layer
	self[index].name = name
	layer:setViewport(viewport)
	MOAISim.pushRenderPass(layer)

	return layer
end

function RNLayer:get(name)
	for i,container in pairs(self) do
		if container.name == name then
			return container.layer
		end
	end
end

function RNLayer:createLayerWithPartition(name,viewport)
	local layer = self:createLayer(name,viewport)
	local partition = MOAIPartition.new()
	layer:setPartition(partition)
	return layer
end

return RNLayer