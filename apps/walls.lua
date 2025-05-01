local function createUI(parent, monitor, color)
    local myMonitor = monitor
    local myParent = parent
    term.redirect(myMonitor)
    myMonitor.setTextScale(0.5)

    local tw, th = term.getSize()
    local wall = myParent:addFrame()
        :setSize(tw, th)
        :setPosition(1, 1)
        :setBackground(color)

    local wallInner = wall:addFrame("wallInner")
        :setSize(tw-3, th-3)
        :setPosition(2, 2)
        :setBackground(colors.lightGray)

    local wallInner2 = wallInner:addFrame("wallInner2")
        :setSize(tw-5, th-5)
        :setPosition(2, 2)
        :setBackground(colors.gray)

    local wallInner3 = wallInner2:addFrame("wallInner3")
        :setSize(tw-7, th-7)
        :setPosition(2, 2)
        :setBackground(colors.black)
        :onClick(function(wallInner3)
            wallInner3:setBackground(colors.green)
        end)

    local function updateMonitor()
        term.redirect(myMonitor)
        tw, th = term.getSize()
    end


    local function animations()
        while true do
            updateMonitor()

            myParent:animate()
                :move(2, 14, 0.5)
                :sequence()
                :move(2, 2, 0.5)
                :sequence()
                :move(2, 24, 0.5)

            os.sleep(2)

        end
    end

    return {
        updateMonitor = updateMonitor,
        wall = wall, 
        animations = animations,
        animateBlock = animateBlock,
    }
end

return {
    createUI = createUI
}