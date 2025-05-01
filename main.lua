local basalt = require("basalt")
local basaltOS = require("basaltOS")
local main= nil
local monitors = { peripheral.find("monitor") }
local monitor = nil

local function initMonitors()
    for _, monitor in pairs(monitors) do
        monitor.setBackgroundColor(colors.black)
        monitor.setTextScale(0.5)
        monitor.clear()
    end

    main = basalt.createFrame()

    if #monitors > 0 then
        mon1 = basalt.createFrame()
            :setTerm(monitors[1])
    else
        mon1 = nil
    end    
    if #monitors > 1 then
        mon2 = basalt.createFrame()
            :setTerm(monitors[2])
    else
        mon2 = nil
    end    
        
    -- Create OS instance
    OS = basaltOS(main, mon1, mon2):start()
end

initMonitors()



basalt.run()