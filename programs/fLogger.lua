local args = { ... }
local hc = (_G.flogger_colors and _G.flogger_colors.hc) or colors.lime
local fg = (_G.flogger_colors and _G.flogger_colors.fg) or colors.green
local bg = colors.black
term.setTextColor(fg)
term.setBackgroundColor(bg)

function logRandomMessage()
    local logType = math.random(1, 6)  -- Now 6 possible log types
    if logType == 1 then
        -- Reactor status report
        print("Reactor Core #"..math.random(1,8).."\n \136 Operating at "..math.random(75,98).."% capacity. \n"..
               " \136 Neutron flux: "..math.random(10,15).."×10¹³ n/cm²s\n"..
               " \136 Coolant temp: "..math.random(280,320).."°C | Pressure: "..math.random(120,180).." atm\n\n")
        
    elseif logType == 2 then
        -- Emergency alert
        local sector = math.random(1,6)
        local severity = ""
        local response = ""
        
        if math.random(2) == 1 then
            severity = "WARNING"
            response = "Initiate protocol "..math.random(1,5)
            printc(severity .. ":", colors.yellow)

        else
            severity = "CRITICAL"
            response = "EVACUATE sector "..sector
            printc(severity .. ":", colors.red)

        end
        printc("Containment breach Sector "..sector.."!", hc)
    	print("Radiation: "..math.random(50,500).." rem | "..response.."\n"..
               " \136 Seal blast doors and inject boron reserves\n\n")
        
    elseif logType == 3 then
        -- Production update
        local material = ""
        local amount = 0
        
        if math.random(2) == 1 then
            material = "plutonium cores"
            amount = math.random(8,15)
        else
            material = "uranium rods"
            amount = math.random(20,40)
        end
        
        print("Fabricator Unit "..string.char(math.random(65,68)).."-"..math.random(1,12)..":\n"..
              " \136 Produced "..amount.." "..material.." this cycle\n"..
              " \136 Stockpile now at "..math.random(75,200).." units\n\n")
        
    elseif logType == 4 then
        -- Maintenance log
        local system = ""
        local action = ""
        
        if math.random(2) == 1 then
            system = "control rods"
            action = "calibrated"
        else
            system = "coolant pumps"
            action = "serviced"
        end
        
        printc("MAINTENANCE: ", hc)
    	print(" \136 "..math.random(2,8).." "..system.." "..action.." in Reactor #"..math.random(1,4))
      	print(" \136 Next service due in "..math.random(7,30).." days")
        print(" \136 All safety checks completed\n")
        
    elseif logType == 5 then
        -- Research breakthrough
        local project = ""
        local result = ""
        
        if math.random(2) == 1 then
            project = "Laser enrichment"
            result = "efficiency +"..math.random(5,12).."%"
        else
            project = "Neutron reflector"
            result = "yield +"..math.random(8,15).."%"
        end
        
        print("RESEARCH SUCCESS:\n"..project.." project\n"..
               " \136 Achieved "..result.."\n"..
               " \136 Approved for immediate implementation\n\n")
        
    else
        -- Random event
        local events = {
            "Unauthorized access detected\n \136 Security team dispatched",
            "Power surge in transformer bank "..math.random(1,4).."\n \136 Breakers tripped",
            "Radiation suit inventory shows "..math.random(1,5).." missing units",
            "Shift change initiated\n \136 New crew arriving in "..math.random(10,30).." minutes",
            "The Emperor approves our progress\n \136 Double production targets"
        }
        
        printc("EVENT:", hc)
        print(events[math.random(#events)])
    	print(" \136 Log updated: "..os.date("%H:%M").."\n\n")
    end
end

function printc(msg, c)
	term.setTextColor(c)
	print(msg)
	term.setTextColor(fg)
end

while true do
	logRandomMessage()
	sleep(math.random(2.5, 8))
end