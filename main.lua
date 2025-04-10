local basalt = require("basalt")
local basaltOS = require("basaltOS")
local monitor = peripheral.wrap("back") 
if monitor then
    term.redirect(monitor)
    monitor.setTextScale(0.5)
end
-- Main initialization
local main = basalt.createFrame()
    :setSize(basalt.getMainFrame():getSize())


-- Create OS instance
local OS = basaltOS(main):start()

basalt.run()