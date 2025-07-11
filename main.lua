local basalt = require("/lib/basalt")
local basaltOS = require("/lib/basaltOS")
local monitors = { peripheral.find("monitor") }
local monitor1, monitor2 = nil

local function initMonitors()
    main = basalt.createFrame()
        :setBackground(colors.orange)
        :setForeground(colors.black)

    if #monitors > 0 then
        monitor1 = basalt.createFrame()
            :setTerm(monitors[1])
            :setForeground(colors.white)
            :setBackground(colors.orange)

    else
        monitor1 = nil
    end    
    if #monitors > 1 then
        monitor2 = basalt.createFrame()
            :setTerm(monitors[2])
            :setForeground(colors.lightBlue)
            :setBackground(colors.blue)
    else
        monitor2 = nil
    end    

    if settings.get("Autorun") ~=nil and modem ~= nil and not pocket then
        main:addProgram()
            :setSize(main:getWidth(),main:getHeight())
            :setPosition(1,1)
            :execute(settings.get("Autorun"))
    else        
        OS = basaltOS(main, monitor1, monitor2):start()
    end
end

initMonitors()

basalt.run()