local basalt = require("basalt")
local basaltOS = require("basaltOS")
basalt.LOGGER.setEnabled(true)

-- Main initialization
local main = basalt.createFrame()
    :setSize(basalt.getMainFrame():getSize())

-- Create UI instance
local ui = basaltOS(main):start()


-- Debug message
main:addLabel("debug")
    :setText("System Ready")
    :setPosition(2, 3)
    :setForeground(colors.lime)

basalt.run()