local mcars = require("mcars")
local monitor1, monitor2 = peripheral.find("monitor")

local function initMonitors()
    local l1 = ""
    local l2 = ""

    if settings.get("Layout") ~= nil and settings.get("Layout") == "Holocube" then
        l1 = "Holocube-Top"
        l2 = "Holocube-Bottom"
    end

    if monitor1 ~= nil then
        monitor1.setTextScale(0.5)
        mcars(monitor1, l1).start()
    end
    if monitor2 ~= nil then
        monitor2.setTextScale(0.5)
        mcars(monitor2, l2).start()
    end

    if pocket then
        mcars(term.native()).start()
    end
end

initMonitors()
basalt.run()

