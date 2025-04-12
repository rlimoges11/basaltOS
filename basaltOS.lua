basalt = require("basalt")




return function(parentFrame)
    local tw, th = term.getSize()
    local api = {}
    local frame = parentFrame:addFrame()
        :setSize(tw, th)
        :setBackground(colors.gray)        


    function api.drawDesktop()
        desktop = frame:addFrame("desktop")
            :setPosition(1, 2)
            :setSize(tw, th)
            :setBackground(colors.gray)
    end

    function api.animateWindow()
        windowContainer:setY(-5)
        windowContainer:animate()
            :resize(1, 1, 0) 
            :sequence()
            :move(3, 3, 0.5)  -- Move down
            :resize(1, 14, 1.25) 
            :sequence()
            :resize(23, 14, 0.5) 
            :sequence()
            :start()
    end

    function api.drawMenuBar()
        menuBar = frame:addFrame("menuBar")
            :setPosition(1, 1)
            :setSize(tw, 1)
            :setBackground(colors.gray)

        -- Rainbow title
        local title = "BasaltOS"
        local rainbow = {
            colors.red, colors.orange, colors.yellow, colors.lime,
            colors.green, colors.cyan, colors.blue, colors.blue
        }
        
        for i = 1, #title do
            menuBar:addLabel("title_"..i)
                :setText(title:sub(i,i))
                :setPosition(i, 1)
                :setForeground(rainbow[(i-1) % #rainbow + 1])
        end

        -- Clock
        clock = menuBar:addLabel("clock")
            :setPosition(tw - 8, 1)
            :setForeground(colors.lightBlue)

        function updateClock()
            while true do
                clock:setText(textutils.formatTime(os.time("local"), false) .. " ^")
                os.sleep(30)
            end
        end

        -- Start clock in a coroutine
        basalt.schedule(updateClock)
    end

    function api.drawTaskbar()
        taskbar = desktop:addFrame("taskbar")
            :setPosition(1, th-1)
            :setSize(tw, 1)
            :setBackground(colors.gray)
            :setForeground(colors.lightBlue)
            :onClick(function()
                os.reboot()
            end)

    end


    function api.showWelcomeWindow()
        -- Window dimensions (will auto-adjust to content)
        windowWidth = math.min(40, tw)
        windowHeight = math.min(24, th - 8)
        winX = math.floor((tw - windowWidth) / 2) + 2
        winY = math.floor((th - windowHeight) / 2) + 1
        state = "normal"

        -- Main window container
        windowContainer = desktop:addFrame("welcomeWindow")
            :setPosition(3, winY)
            :setSize(windowWidth, windowHeight)


        -- Create border effect
        borderFrame = windowContainer:addFrame()
            :setSize(23, windowHeight)
            :setBackground(colors.gray)

        -- Main content frame
        welcomeWin = borderFrame:addFrame()
            :setPosition(2, 2)
            :setSize(21, windowHeight-2)
            :setBackground(colors.gray)

        -- Title bar
        borderFrame:addFrame()
            :setPosition(3, 1)
            :setSize(windowWidth-3, 1)
            :setBackground(colors.gray)
            :addLabel("title")
            :setText("Welcome to BasaltOS")
            :setPosition(1, 1)
            :setForeground(colors.white)

        -- Maximize button 
        maxbtn = borderFrame:addButton()
            :setText("\30")
            :setPosition(2, 1)
            :setSize(1, 1)
            :setBackground(colors.gray)
            :setForeground(colors.lightGray)
            :onClick(function()
                if state == "normal" or state == "minimized" then
                    -- maximize
                    windowHeight = th - 3
                    windowContainer:setPosition(1, 1)
                    windowContainer:setSize(tw, windowHeight + 1)
                    borderFrame:setSize(tw, windowHeight+1)
                    welcomeWin:setSize(tw - 2, windowHeight - 1)
                    state = "maximized"
                    minbtn:setText("\31")
                    maxbtn:setText("-")
                else
                    -- normalize
                    windowHeight = 14
                    windowContainer:setPosition(winX, winY)
                        :setSize(windowWidth -2, windowHeight)

                    borderFrame:setSize(windowWidth, windowHeight)

                    welcomeWin:setPosition(2, 2)
                        :setSize(windowWidth-4, 12)

                    minbtn:setText("\31")
                    maxbtn:setText("\30")
                    state = "normal"

                end
            end)

        -- Minimize button 
        minbtn = borderFrame:addButton()
            :setText("\31")
            :setPosition(1,1)
            :setSize(1, 1)
            :setBackground(colors.gray)
            :setForeground(colors.lightGray)
            :onClick(
                function()
                    -- minimize
                    if state == "minimized" then
                        windowHeight = 14
                        -- normalize again (make a function)
                        windowContainer:setPosition(winX, winY)
                            :setSize(windowWidth -2, windowHeight)

                        borderFrame:setSize(windowWidth, 14)

                        welcomeWin:setPosition(2, 2)
                            :setSize(windowWidth-4, 12)

                        maxbtn:setText("\30")
                        minbtn:setText("\31")
                        state = "normal"
                    else
                        windowHeight = 1
                        windowContainer:setPosition(1, th-1)
                        windowContainer:setSize(10,1)
                        borderFrame:setSize(10,1)

                        maxbtn:setText("\30")
                        minbtn:setText("-")
                        state = "minimized"
                    end
                end
            )

        -- Text content with word wrapping
        local textContent = "BasaltOS is a lightweight Lua environment for ComputerCraft that combines classic computing nostalgia with modern functionality."
        
        -- Word wrapping function
        local function wrapText(text, maxWidth)
            local lines = {}
            local line = ""
            
            for word in text:gmatch("%S+") do
                if #line + #word + 1 <= maxWidth then
                    line = line .. (line == "" and "" or " ") .. word
                else
                    table.insert(lines, line)
                    line = word
                end
            end
            table.insert(lines, line)
            return lines
        end

 
        -- Add wrapped text
        local wrappedText = wrapText(textContent, windowWidth-3)
        for i, line in ipairs(wrappedText) do
                welcomeWin:addLabel("line_"..i)
                    :setText(line)
                    :setPosition(2, i + 1)
                    :setForeground(colors.white)
        end

        -- OK button 
        welcomeButton = welcomeWin:addButton()
            :setText(" OK ")
            :setPosition(math.floor((windowWidth-4)/2)-2, windowHeight-3)
            :setSize(8, 1)
            :setBackground(colors.gray)
            :setForeground(colors.white)
            :onClick(function()
                windowContainer:destroy()
            end)

        -- Make window draggable
        local dragX, dragY
        welcomeWin:addFrame("dragBar")
            :setPosition(-10, 1)
            :setSize(1, 1)
            :setBackground(colors.blue)
            :onDrag(function(event, btn, x, y)
                if event == "mouse_click" then
                    dragX, dragY = x, y
                elseif event == "mouse_drag" then
                    windowContainer:setPosition(
                        windowContainer:getX() + (x - dragX),
                        windowContainer:getY() + (y - dragY))
                    dragX, dragY = x, y
                end
            end)
        end

    function api.addBG()
        local images = {
            "images/gate.bimg",
            "images/wiz.bimg",
            "images/wiz2.bimg",
            "images/illager.bimg",
            "images/helios.bimg",
            "images/helios-2.bimg",
            "images/helios-3.bimg",
            "images/basalty.bimg",
            "images/basalt2.bimg",
            "images/basalt3.bimg",
            "images/dragon.bimg",
            "images/sunset.bimg",
            "images/prominence2.bimg",
            "images/prominence3.bimg",
            "images/tantalius.bimg",
            "images/spooky.bimg"
        }

        -- Shuffle the images array
        for i = #images, 2, -1 do
            local j = math.random(i)
            images[i], images[j] = images[j], images[i]
        end

        local file = fs.open(images[1], "r")
        if file then
            img = textutils.unserialize(file.readAll())
            file:close()
        end

        bgImg = desktop:addImage()
            :setBimg(img)
            :setSize(tw, th)
            :setCurrentFrame(1)
            :setX(1)
            :setY(1)
            :setBackground(colors.gray)
            :setVisible(false)

    end

    function api.animateBG()
        bgImg:setVisible(true)
        bgImg:setY(-80)
        bgImg:animate()
            :move(1, 1, 1)  -- Move down
            :start()

    end

    function api.start()
        basalt.schedule(function()
            api.drawMenuBar()
            api.drawDesktop()
            api.addBG()
            os.sleep(0.5)

            api.animateBG()
            os.sleep(1)

            api.drawTaskbar()
            os.sleep(0.5)

            api.showWelcomeWindow()
            os.sleep(0.5)

            api.animateWindow()
        end)
    

        return api
    end

    return api
end