local basalt = require("basalt")
local basaltOS = require("basaltOS")
local monitor = peripheral.find("monitor") or nil
if monitor ~= nil then
    term.redirect(monitor)
    monitor.setTextScale(0.5)
end
-- Main initialization
local main = basalt.createFrame()
    :setSize(basalt.getMainFrame():getSize())


-- Create OS instance
local OS = basaltOS(main):start(monitor)

basalt.run()