local basalt = require("basalt")
local basaltOS = require("basaltOS")

-- Main initialization
local main = basalt.createFrame()
    :setSize(basalt.getMainFrame():getSize())

-- Create OS instance
local OS = basaltOS(main):start()

basalt.run()