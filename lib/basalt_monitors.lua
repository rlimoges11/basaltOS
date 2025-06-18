function logger(el, msg) 
	
end


function recalibrate(monitor)
	local mainFrame = basalt.createFrame()
	local tw, th = main:getSize()
		if scheme == nil then
			scheme=""
		end

		if monitor1 ~= nil then
		    mainFrame:setTerm(monitor)
		        :setSize(tw, th)
		        :setPosition(1,1)
		else
			local turtleFrame = mainFrame:addFrame()
			turtleFrame
				:setForeground(colors.yellow)
				:setBackground(colors.orange)
				:setSize(tw, th)
		        :setPosition(1,1)

			local turtleText = turtleFrame:addLabel()
			turtleText
				:setForeground(colors.blue)
				:setBackground(colors.black)
		
	end

	return turtleText

end

function getTime()
	return tostring(textutils.formatTime(os.time("local"), true))
end 




return { logger = logger(), recalibrate = recalibrate, getTime = getTime() }