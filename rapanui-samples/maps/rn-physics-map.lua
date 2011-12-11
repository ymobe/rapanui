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



--same as rn map autodraw

-- tiles by Daniel Cook (http://www.lostgarden.com)

require("RNMapFactory")
require("RNMap")
require("RNMapLayer")
require("RNMapObject")
require("RNMapObjectGroup")
require("RNMapTileset")
require("RNUtil")


map = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/maps/physicmap.tmx")


aTileset = map:getTileset(0)

aTileset:updateImageSource("rapanui-samples/maps/platformtiles.png")


local layersSize = map:getLayersSize()

print("Layers", layersSize)
local layers = map:getLayers()


memestatus()

map:drawMapAt(0, 0, aTileset)

memestatus()














------start physic simulation and add a physic box

RNPhysics.start()

box = RNFactory.createImage("images/tile1.png"); box.x = 250; box.y = 50;
RNPhysics.createBodyFromImage(box)






---function for splittin a String


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


------Snippet used to create static world objects from the map's object layer
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


aObjectGroup=map:getFirstObjectGroupByName("Object Layer 1")



--check each object
for i = 0, aObjectGroup:getObjectsSize() - 1 do
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











--Debug Draw if you want
--RNPhysics.setDebugDraw(RNFactory.screen)




