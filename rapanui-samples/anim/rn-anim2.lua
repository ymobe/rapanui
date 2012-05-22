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

background = RNFactory.createImage("images/background-purple.png")



--display.newAnim(filename,sizex,sizey[,posx,posy,scaleX,scaleY])
--size is the size of each frame;scale is the size of the rect containing the animation.
--if scale is changed after the anim become physical, the physical body size won't change.
--animObject.frame is the current animation frame.Change this and the animation will jump
--to that frame.

--setting up a sequence brench for char
function onEndS1()
    char:play("walkBack")
end

function onEndS2()
    char:play("walkLeft")
end

function onEndS3()
    char:play("walkRight")
end

function onEndS4()
    char:stop()
end

--physical animation with many sequences
--newAnim(file,sizeX,sizeY[,posx,posy,scaleX,scaleY])
char = RNFactory.createAnim("images/char.png", 42, 32, 100, 300, 2, 3)
--newSequence(name,frameOrder,speed,repeatTimes,onStopFunction)
char:newSequence("walkFront", { 7, 8, 9 }, 6, 10, onEndS1)
char:newSequence("walkBack", { 1, 2, 3 }, 6, 10, onEndS2)
char:newSequence("walkLeft", { 4, 5, 6 }, 6, 10, onEndS3)
char:newSequence("walkRight", { 10, 11, 12 }, 6, 10, onEndS4)
char:play("walkFront")




--simple animation which plays the default sequence
char2 = RNFactory.createAnim("images/char2.png", 42, 32)
char2.x = 100; char2.y = 100; char2.rotation = 30;
char2.scalex = 1; char2.scaley = 2
char2.frame = 1
char2:flipHorizontal()
char2:flipVertical()
--here default sequence will be used
char2:play() --plays the default sequence
char2:togglePause() --pause
char2:togglePause() --unpause
char2:togglePause() --pause
char2:play("default", 12, 5) --plays "default" sequence by calling it and sets a new speed and repeat times to it.

char2:newSequence("try") --adds a newSequence
char2:removeSequence("try") --removes the sequence



--[[

	RapaNui animation are under development.
	
	At the moment
	char.sequenceList
	contains a table for each sequence.
	each table/sequence has
    name
    frameOrder
    speed
    repeatTimes
    onStop
    currentFrame
    timeRepeated
    fields you can access.
    
    so for example if you want to change the char walkBack sequence speed to 12
    you can do it this way:
    
    char.sequenceList[3].speed=12
    
	Animations will be improved soon.
    
    
]] --