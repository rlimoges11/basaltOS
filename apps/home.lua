basalt = require("/lib/basalt")

local monitors = { peripheral.find("monitor") }
local frame = nil 
local function initMonitors()
    if #monitors > 0 then
        for _, monitor in pairs(monitors) do
            monitor.setTextScale(0.5)
            monitor.clear()
        end
    else
        
    end

    local tw, th = term.getSize()
    local home = basalt.createFrame()
        :setSize(tw, th - 1)
        :setPosition(1,2)
        :setBackground(colors.gray)

    local b1 = home:addFrame()
        :setSize(5, 1)
        :setPosition(12,19)
        :setBackground(colors.lime)

    local b2 = home:addFrame()
        :setSize(5, 1)
        :setPosition(12,17)
        :setBackground(colors.green)

    local b3 = home:addFrame()
        :setSize(5, 1)
        :setPosition(12,15)
        :setBackground(colors.green)

    local b4 = home:addFrame()
        :setSize(5, 1)
        :setPosition(12,13)
        :setBackground(colors.green)

    local b5 = home:addFrame()
        :setSize(5, 1)
        :setPosition(12,11)
        :setBackground(colors.green)

    local b6 = home:addFrame()
        :setSize(5, 1)
        :setPosition(12,9)
        :setBackground(colors.green)

    local b7 = home:addFrame()
        :setSize(5, 1)
        :setPosition(12,7)
        :setBackground(colors.green)

    local b8 = home:addFrame()
        :setSize(5, 1)
        :setPosition(12,5)
        :setBackground(colors.green)

    local b9 = home:addFrame()
        :setSize(5, 1)
        :setPosition(12,3)
        :setBackground(colors.green)


end

initMonitors()

basalt.run()