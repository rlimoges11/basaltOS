local mcars = require("mcars")
local monitors = { peripheral.find("monitor") }
local function initMonitors()
    for _, monitor in pairs(monitors) do
        monitor.clear()
        mcars().start(monitor)
    end
end
initMonitors()
basalt.run()