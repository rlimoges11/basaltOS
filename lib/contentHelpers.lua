local basalt = basalt or require("basalt") 

return function(el, fg, bg, hc) 
    local api = {}
    el:setForeground(fg)
    el:setBackground(bg)



    function api.printc(msg)
        pre = el:getText()
        
        if pre ~= "" then
            el:setText(pre .. "\n\n" .. msg)
        else
            el:setText(msg)
        end

        local lw, lh = el:getSize()
            el:setY(37 - lh)

    end

    function api.logRandomMessages()
        while true do
            local logType = math.random(1, 6)  -- Now 6 possible log types
            if logType == 1 then
                -- Reactor status report
                api.printc("Reactor Core #" .. math.random(1,8) .. "\n" ..
                           " \136 Operating at "..math.random(75,98).."% capacity.\n" ..
                           " \136 Neutron flux: "..math.random(10,15).."x10\178 n/cm\179\n" ..
                           " \136 Coolant temp: "..math.random(280,320).."\176C | Pressure: " .. math.random(120,180) .. " atm")
                
            elseif logType == 2 then
                -- Emergency alert
                local sector = math.random(1,6)
                local severity = ""
                local response = ""
                
                if math.random(2) == 1 then
                    severity = "WARNING"
                    response = "Initiate protocol "..math.random(1,5)
                    

                else
                    severity = "CRITICAL"
                    response = "EVACUATE sector "..sector
                    

                end
                api.printc(severity .. ":\n" .. 
                    "Containment breach Sector ".. sector.."!\n" ..
                    "Radiation: "..math.random(50,500).." rem | "..response.."\n" ..
                    " \136 Seal blast doors and inject boron reserves\n")
                
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
                
                api.printc("Fabricator Unit "..string.char(math.random(65,68)).."-"..math.random(1,12)..":\n"..
                      " \136 Produced "..amount.." "..material.." this cycle\n"..
                      " \136 Stockpile now at "..math.random(75,200).." units\n")
                
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
                
                api.printc("MAINTENANCE:\n" .. 
                    " \136 "..math.random(2,8).." "..system.." "..action.." in Reactor #"..math.random(1,4) .. "\n" ..
              	    " \136 Next service due in "..math.random(7,30).." days\n" ..
                    " \136 All safety checks completed\n")
                
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
                
                api.printc("RESEARCH SUCCESS:\n" .. 
                    project .. " project\n"..
                    " \136 Achieved "..result.."\n"..
                    " \136 Approved for immediate implementation\n")
                
            else
                -- Random event
                local events = {
                    "Unauthorized access detected\n \136 Security team dispatched",
                    "Power surge in transformer bank "..math.random(1,4).."\n \136 Breakers tripped",
                    "Radiation suit inventory shows "..math.random(1,5).." missing units",
                    "Shift change initiated\n \136 New crew arriving in "..math.random(10,30).." minutes",
                    "The Emperor approves our progress\n \136 Double production targets"
                }
                
                api.printc("EVENT: \n" .. 
                   events[math.random(#events)] .. "\n" .. 
            	   " \136 Log updated: "..os.date("%H:%M"))
            end

            os.sleep(math.random(5,25))
        end
    end

    basalt.schedule(api.logRandomMessages)


    return api
end
