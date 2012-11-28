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
	
	
	self[index] = {} 
	self[index].layer = layer
	self[index].name = name
	layer:setViewport(viewport)
	MOAISim.pushRenderPass(layer)

	return layer
end

return RNLayer