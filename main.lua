local basalt = require("basalt")
local basaltOS = require("basaltOS")
local main = nil
local monitors = { peripheral.find("monitor") }
local monitor = nil

local function initMonitors()
    for _, monitor in pairs(monitors) do
        monitor.setBackgroundColor(colors.black)
        monitor.setTextScale(0.5)
        monitor.clear()
    end

    monitor = monitors[#monitors]

    if(#monitors > 0) then
        term.redirect(monitor)
    end

    main = basalt.createFrame()
    :setSize(basalt.getMainFrame():getSize())
 
end

initMonitors()

-- Create OS instance
local OS = basaltOS(main):start(monitors)

basalt.run()