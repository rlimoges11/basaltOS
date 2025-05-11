
settings.load("../.settings")
if settings.get("LauncherCoordinates") and modem ~= nil and not pocket then
    local LauncherCoordinates = settings.get("LauncherCoordinates") or nil
    local LOW_FUEL_THRESHOLD = settings.get("LOW_FUEL_THRESHOLD") or nil
    local HIGH_FUEL_THRESHOLD = settings.get("HIGH_FUEL_THRESHOLD") or nil
    local MAX_FUEL = settings.get("MAX_FUEL") or nil

	local fuelLevel = math.floor(turtle.getFuelLevel())
	print(fuelLevel)
	if fuelLevel < LOW_FUEL_THRESHOLD then
		local container = peripheral.wrap("top")
	    if container == nil then
			print("ALERT: " .. label .. " fuel chest not found.")
	        return
	    end

	    local function getFuel()
	        for i = 1, container.size(), 1 do
				if(turtle.getFuelLevel() <= HIGH_FUEL_THRESHOLD) then
					turtle.suckUp(1)
					turtle.refuel(1)
					--printFuel()	
					os.sleep(1)
					turtle.dropDown()
				end
	        end
	        return false
	    end

	    while (turtle.getFuelLevel() <= HIGH_FUEL_THRESHOLD) do
			--printFuel()
	        if getFuel() then
	        	turtle.dropDown()
	            break
	        end
	    end
	end
else
	print("error")
	print("fuelLevel")
	print(LOW_FUEL_THRESHOLD)
end