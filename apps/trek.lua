local mcars = require("mcars")
local monitors = { peripheral.find("monitor") }
local function initMonitors()
    if #monitors > 0 then
        for _, monitor in pairs(monitors) do
            monitor.clear()
            mcars().start(monitor)
        end
    else
        mcars().start(nil)
    end
end

initMonitors()
basalt.run()