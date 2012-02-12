--[[
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
]]

--Lists Tutorial


--add images
background = RNFactory.createImage("rapanui-samples/physics/background-purple.png")
box = RNFactory.createImage("rapanui-samples/physics/box.png"); box.x = 170; box.y = 80;
ball = RNFactory.createImage("rapanui-samples/physics/ball.png"); ball.x = 240; ball.y = 80;
triangle = RNFactory.createImage("rapanui-samples/physics/poly.png"); triangle.x = 80; triangle.y = 80; triangle.rotation = 190
floor = RNFactory.createImage("rapanui-samples/physics/floor.png"); floor.x = 160; floor.y = 400;

--starts simulation
RNPhysics.start()


--set images as physics objects
RNPhysics.createBodyFromImage(box)
RNPhysics.createBodyFromImage(ball, { shape = "circle" })
RNPhysics.createBodyFromImage(triangle, { shape = { -32, 32, 0, -32, 32, 32 }, restitution = 0.3, friction = 0.1 })
RNPhysics.createBodyFromImage(floor, "static", { density = 1, friction = 0.3, restitution = 0, sensor = false, shape = { -128, -16, 128, -16, 128, 16, -128, 16 } }, { density = 1, friction = 0.3, restitution = 0.5, sensor = true, shape = { -32, 32 - 100, 32, 32 - 100, 0, 64 - 100 } })

box.restitution = 0.5
ball.restitution = 0.3
triangle.restitution = 0.3

joint = RNPhysics.createJoint("distance", box, triangle, box.x, box.y, triangle.x, triangle.y)

--set debud draw on screen
RNPhysics.setDebugDraw(RNFactory.screen)

--[[

	Lists are a powefull item to game development.
	With lists you can access to everything in RapaNui physics!

	All lists are updated on objects creation and removal!

]] --

--With those you can access lists of fixtures, joints and bodies!

--Global bodylist (a table containing all the bodies in the world!
print(RNPhysics.bodylist)
--or
print(RNPhysics.getBodyList)


--Global joint list
print(RNPhysics.jointlist)
--Local Joint list
print(box.physicObject.jointlist)


--Local FixtureList
print(box.physicObject.fixturelist)


--Indexes in lists! The place occupied in the lists!
--bodies
print(box.physicObject.indexinlist)
--fixtures
print(box.physicObject.fixturelist[1].indexinlist)
--joints
print(joint.indexingloballist)
print(joint.indexinbodyAlist)
print(joint.indexinbodyBlist)



--to access parent/child objects you can use
--image - body
print(box.physicObject)
--body - image
print(box.physicObject.sprite)
--image -  fixture
print(box.fixture)
--is the same as
print(box.physicObject.fixturelist)


--accessing native objects
print(box.prop)
print(box.physicObject.body)
print(box.fixture[1].fixture)
print(joint.joint)



--so for example if we want to set as sensor only the second fixture of the floor (not the first)
--since it is a complex body, we should use something like
floor.fixture[2].sensor = true

--accessing fixtures (a better way to)
box.fixture[1].name = "testFixture"
--get name from fixture
print(box.fixture[1].name)
--get fixture list from name (a table with all the fixture with the given name is returned)
print(box:getFixtureListByName("testFixture")[1])
--how to change a property for all the fixtures with the same name
box:changeFixturesProperty("testFixture", "restitution", 0.4)
print(box.fixture[1].restitution)

--[[

	 More lists can be used in RapaNui. Check the library to learn more.


]] --


