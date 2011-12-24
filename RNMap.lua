------------------------------------------------------------------------------------------------------------------------
--
-- RapaNui
--
-- by Ymobe ltd  (http://ymobe.co.uk)
--
-- LICENSE:
--
-- RapaNui uses the Common Public Attribution License Version 1.0 (CPAL) http://www.opensource.org/licenses/cpal_1.0.
-- CPAL is an Open Source Initiative approved
-- license based on the Mozilla Public License, with the added requirement that you attribute
-- Moai (http://getmoai.com/) and RapaNui in the credits of your program.
--
------------------------------------------------------------------------------------------------------------------------

local RNMap = {}

function RNMap:new(o)
    o = o or {
        name = ""
    }
    setmetatable(o, self)
    self.__index = self
    self.objects = {}
    return o
end

function RNMap:getLayers()
    return self.layers
end

function RNMap:getLayersSize()
    return self.layersSize
end

function RNMap:getObjectGroupSize()
    return self.objectgroupsSize
end

function RNMap:getOrientation()
    return self.orientation
end

function RNMap:getCols()
    return self.width
end

function RNMap:getRows()
    return self.height
end

function RNMap:getTileWidth()
    return self.tilewidth
end

function RNMap:getTileHeight()
    return self.tileheight
end

function RNMap:getTileset(index)
    return self.tilesets[index]
end

function RNMap:getTilesetSize()
    return self.tilesetsSize
end

function RNMap:getProperties()
    return self.properties
end

function RNMap:getProperty(key)
    if self.propertiesSize > 0 then
        for lkey, lvalue in pairs(self.properties) do
            if lkey == key then
                return lvalue
            end
        end
    end
    return ""
end



function RNMap:getFirstTilesetByName(name)
    for key, value in pairs(self.tilesets) do
        if value.name == name then
            return value
        end
    end
    return {}
end

function RNMap:getFirstLayerByName(name)
    for key, value in pairs(self.layers) do
        if value.name == name then
            return value
        end
    end
    return {}
end

function RNMap:getFirstObjectGroupByName(name)
    for key, value in pairs(self.objectgroups) do
        if value.name == name then
            return value
        end
    end
    return nil
end

function RNMap:drawMapAt(x, y, tileset)
    local layersSize = self:getLayersSize()

    for i = 0, layersSize - 1 do
        local layer = self.layers[i]
        layer:drawLayerAt(x, y, tileset)
    end
    self:createPhysicBodiesFromObjecLayer()
    
end


function splitString(pString, pPattern)
   local Table = {} 
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
     table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end



function RNMap:createPhysicBodiesFromObjecLayer()
--[[

	check physicmap.xml
	
	if you want to add physics in your map do as follow:
	
	*create an ObjectLayer
	*add Objects there to create invisible/bounding/world phsyics objecs
	
	NOTE:
	
	BOX BODY:
	to create a box body simply create a box and set "body" as Type.
	(optional you can add a property named bodyType to set the body type)
	
	POLYGON BODY
	to create a polygon body you need to create vertices.
	start with creating the first vertex by creating an object with a vertices
	property.
	now create the other vertices (in CW order in  not convex shape).
	name each vertex and add their names in order in the vertices property of
	the first one, separated by ",".
	Done!


--]]
for g=0,table.getn(self.objectgroups),1 do
aObjectGroup=self.objectgroups[g]
--check each object
for i = 0, aObjectGroup:getObjectsSize() - 1,1 do
	aObject = aObjectGroup:getObject(i)
	
	
	
	--if we have to create a body from a box object
	if aObject.type=="body" then
		--if there are specific properties
		if aObject.properties~=nil then
			--if the bodyType is set
			if aObject.properties.bodyType~=nil then
				RNPhysics.createBodyFromMapObject(aObject,aObject.properties.bodyType)
			else
				RNPhysics.createBodyFromMapObject(aObject,"static")
			end
		else
			RNPhysics.createBodyFromMapObject(aObject,"static")
		end
	end
	
	
	
	--if we have to create a body from vertex points
	if aObject.type=="point" then
		--if it is the first point (so there is a property called vertices)
		if aObject.properties~=nil then
			if aObject.properties.vertices~=nil then
				--save in vertices array the vertices to join in a body				
				vertices=splitString(aObject.properties.vertices,",")
				bodyVertices={}
				--for each vertex in the array and for each object in the layer
				for i=1,table.getn(vertices),1 do
				    currentVertexName=vertices[i]
					for i = 0, aObjectGroup:getObjectsSize() - 1 do
						aVertex = aObjectGroup:getObject(i)
						--if they match
						if aVertex.name==currentVertexName then
						--we create a local object to add to bodyVertices
						v={x=0,y=0}
						v.x=aVertex.x
						v.y=aVertex.y
						table.insert(bodyVertices,v)
						end		
					end
				end
				--now that we have bodyVertices we can create a shape based on vertices
				Vshape={}
				for k=1, table.getn(bodyVertices),1 do
					Vshape[k-1+k]=bodyVertices[k].x
					Vshape[k-1+k+1]=bodyVertices[k].y
				end
				
				--we need a fake object to call the creation
				fakeMapObject={}
				fakeMapObject.x=0
				fakeMapObject.y=0
				fakeMapObject.height=0
				fakeMapObject.width=0
			    RNPhysics.createBodyFromMapObject(fakeMapObject,"static",{shape=Vshape})		
			end
		
		end
	end
	
end

end









end