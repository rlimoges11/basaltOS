local artboard = require("artboard")
local monitor1, monitor2 = peripheral.find("monitor")

local function initMonitors()
    if monitor1 ~= nil then
        monitor1.setTextScale(0.5)
        artboard(monitor1).start()
    end
    if monitor2 ~= nil then
        monitor2.setTextScale(0.5)
        artboard(monitor2).start()
    end
    
end

initMonitors()


basalt.schedule(function()
    os.sleep(15)
    os.reboot()
end)

basalt.run()