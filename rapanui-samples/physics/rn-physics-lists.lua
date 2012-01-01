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

--Lists Tutorial

local R = RN
R.Physics.start()
--add images
background = R.Factory.createImage("RN/RapaNui-samples/physics/background-purple.png")
box = R.Factory.createImage("RN/RapaNui-samples/physics/box.png"); box.x = 170; box.y = 80;
ball = R.Factory.createImage("RN/RapaNui-samples/physics/ball.png"); ball.x = 240; ball.y = 80;
triangle = R.Factory.createImage("RN/RapaNui-samples/physics/poly.png"); triangle.x = 80; triangle.y = 80; triangle.rotation = 190
floor = R.Factory.createImage("RN/RapaNui-samples/physics/floor.png"); floor.x = 160; floor.y = 400;

--starts simulation



--set images as physics objects
R.Physics.createBodyFromImage(box)
R.Physics.createBodyFromImage(ball, { shape = "circle" })
R.Physics.createBodyFromImage(triangle, { shape = { -32, 32, 0, -32, 32, 32 }, restitution = 0.3, friction = 0.1 })
R.Physics.createBodyFromImage(floor, "static", { density = 1, friction = 0.3, restitution = 0, sensor = false, shape = { -128, -16, 128, -16, 128, 16, -128, 16 } }, { density = 1, friction = 0.3, restitution = 0.5, sensor = true, shape = { -32, 32 - 100, 32, 32 - 100, 0, 64 - 100 } })

box.restitution = 0.5
ball.restitution = 0.3
triangle.restitution = 0.3

joint = R.Physics.createJoint("distance", box, triangle, box.x, box.y, triangle.x, triangle.y)

--set debud draw on screen
R.Physics.setDebugDraw(R.Factory.screen)

--[[

	Lists are a powefull item to game development.
	With lists you can access to everything in RN/RapaNui physics!

	All lists are updated on objects creation and removal!

]] --

--With those you can access lists of fixtures, joints and bodies!

--Global bodylist (a table containing all the bodies in the world!
print(R.Physics.bodylist)
--or
print(R.Physics.getBodyList)


--Global joint list
print(R.Physics.jointlist)
--Local Joint list
print(box.jointlist)


--Local FixtureList
print(box.fixturelist)


--Indexes in lists! The place occupied in the lists!
--bodies
print(box.indexinlist)
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
print(box.physicObject.image)
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


--[[

	 More lists can be used in RN/RapaNui. Check the library to learn more.


]] --


