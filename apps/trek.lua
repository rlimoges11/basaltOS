local mcars = require("mcars")
local monitor1, monitor2 = peripheral.find("monitor")

local function initMonitors()
    if monitor1 ~= nil then
        monitor1.setTextScale(0.5)
        mcars(monitor1).start()
    end
    if monitor2 ~= nil then
        monitor2.setTextScale(0.5)
        mcars(monitor2).start()
    end
    mcars(term).start()
end

initMonitors()
basalt.run()