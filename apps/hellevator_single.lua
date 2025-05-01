local basalt = require("../basalt")
local main = basalt.createFrame()
local monitors = { peripheral.find("monitor") }
local myMonitorNum = arg[1]
local myMonitor = nil
local myCol = colors.black
local cracks = nil
local zombie = nil

if myMonitorNum == "1" then
	myMonitor=monitors[1]
	myCol = colors.purple
else
	myMonitor=monitors[2]
	myCol = colors.blue
end
term.redirect(myMonitor)
myMonitor.setTextScale(0.5)
local tw, th = 184, 81
local doorH = 81 - 39

function loadImg(path)
    local file = fs.open(path, "r")
    if file then
        img = textutils.unserialize(file.readAll())
        file:close()
    end

    return img
end

main:setBackground(colors.black)
    :setSize(tw, th)
    :setPosition(1, 1)

wall = main:addFrame()
    :setSize(tw, th)
    :setPosition(1, 1)
    :setBackground(colors.brown)

doorframe = main:addFrame("doorFrame")
	:setSize(40, 40)
    :setPosition(tw / 2 -20, doorH)
    :setBackground(colors.black)


local imgZ = loadImg("images/zombie.bimg")
zombie = doorframe:addFrame("zombie")
zombie:setSize(40,40)
zombie:addImage()
    :setBimg(imgZ)
    :setSize(40, 40)
    :setCurrentFrame(1)
    :setPosition(1, 1)


leftDoor = doorframe:addFrame("leftDoor")
    :setSize(20, 40)
    :setPosition(1, 1)
    :setBackground(colors.gray)
    :onClick(function()
    	openDoors()
	end)

leftDoorInner = leftDoor:addFrame("leftDoorInner")
    :setSize(18, 38)
    :setPosition(2, 2)
    :setBackground(colors.lightGray)

rightDoor = doorframe:addFrame("rightDoor")
    :setSize(20, 40)
    :setPosition(21, 1)
    :setBackground(colors.gray)
    :onClick(function()
    	openDoors()
	end)

rightDoorInner = rightDoor:addFrame("rightDoorInner")
    :setSize(18, 38)
    :setPosition(2, 2)
    :setBackground(colors.lightGray)

	imgC = loadImg("images/cracks.bimg")
	cracks1 = wall:addFrame("cracks1")
		:setSize(20, 13)
		:setPosition(2, 70)

	cracks1:addImage()
	    :setBimg(imgC)
	    :setSize(20, 13)
	    :setCurrentFrame(1)
	    :setPosition(1, 1)


	cracks2 = wall:addFrame("cracks2")
		:setSize(20, 13)
		:setPosition(12, 70)

	cracks2:addImage()
	    :setBimg(imgC)
	    :setSize(20, 13)
	    :setCurrentFrame(1)
	    :setPosition(1, 1)



function openDoors()
	leftDoor:animate()
		:move(-20, 1, 1)
		:sequence()
		:move(1, 1, 1)
        :start()

	rightDoor:animate()
		:move(41, 1, 1)
		:sequence()
		:move(21 , 1, 1)
        :start()
end

function animationLoop()
	while true do 
		local x = math.random(1, 170)
		local x2 = math.random(1, 170)
		cracks1:setPosition(x, 80)
		cracks2:setPosition(x2, 40)
		os.sleep(0.01)

		cracks1:animate()
			:move(x, -20, 1.15)
			:sequence()
			:start()

		cracks2:animate()
			:move(x2, -60, 1.15)
			:sequence()
			:start()

		os.sleep(1.16)
	end
end

basalt.schedule(animationLoop)

basalt.run()