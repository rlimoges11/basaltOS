basalt = require("basalt")

return function(parentFrame)
    local tw, th = term.getSize()
    local api = {}
    local frame = parentFrame:addFrame()
        :setSize(tw, th)
        :setBackground(colors.lightGray)        

    function api.drawDesktop()
        desktop = frame:addFrame("desktop")
            :setPosition(1, 2)
            :setSize(tw, th)
            :setBackground(colors.lightGray)
    end

    function api.animateWindow()
        windowContainer:setY(-10)
        windowContainer:setVisible(true)
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

    function api.getRandomBG()
        local images = {
            
            "images/gate.bimg",
            "images/wiz.bimg",
            "images/wiz2.bimg",
            "images/illager.bimg",
            "images/helios.bimg",
            "images/helios-2.bimg",
            "images/helios-3.bimg",
            "images/basalt2.bimg",
            "images/basalt3.bimg",
            "images/dragon.bimg",
            "images/sunset.bimg",
            "images/tantalius.bimg",
            "images/spooky.bimg",
            "images/guardian.bimg",
            "images/kerrigan.bimg",
            "images/ps1.bimg",
            "images/friona.bimg",
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

        return img
    end


    function api.loadImg(path)
        local file = fs.open(path, "r")
        if file then
            img = textutils.unserialize(file.readAll())
            file:close()
        end

        return img
    end

    function api.drawMenuBar()
        menuBar = frame:addFrame("menuBar")
            :setPosition(-tw+1, 1)
            :setSize(tw, 1)
            :setBackground(colors.gray)
            :setVisible(false)
            os.sleep(0.5)


        menuBar:setVisible(true)
        menuBar:animate()
            :move(1,1,0.5)
            :sequence()
            :start()
            os.sleep(0.5)

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
            :setPosition(tw - 9, 1)
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
            :setPosition(-tw+1, th-1)
            :setSize(tw, 1)
            :setBackground(colors.gray)
            :setForeground(colors.lightBlue)
            :onClick(function()
                frame:setVisible(false)

                --os.reboot()
                local trek = parentFrame:addProgram()
                :setSize(164,th)
                :execute("trek.lua")
            end)
            os.sleep(0.1)

            taskbar:animate()
                :move(1,th-1,0.5)
                :sequence()
                :start()
            os.sleep(0.5)

    end


    function api.showWelcomeWindow()
        -- Window dimensions (will auto-adjust to content)
        windowWidth = math.min(40, tw)
        windowHeight = math.min(24, th - 7)
        winX = math.floor((tw - windowWidth) / 2) + 2
        winY = math.floor((th - windowHeight) / 2) + 1
        state = "normal"

        -- Main window container
        windowContainer = desktop:addFrame("welcomeWindow")
            :setPosition(3, winY)
            :setSize(windowWidth, windowHeight)
            :setVisible(false)


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
            :onClick(function()
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
        end

    function api.addBG(img)
        bgImg = desktop:addImage()
            :setBimg(img)
            :setSize(tw, th)
            :setCurrentFrame(1)
            :setX(1)
            :setY(1)
            :setBackground(colors.gray)
            :setVisible(false)
            :onClick(function()
                api.changeBG()
            end)
    end

    function api.animateBG(offsetY)
        bgImg:setVisible(true)
        bgImg:setY(offsetY)
        
        bgImg:animate()
            :move(1, 1, 1)  -- Move down
            :start()
    end

    function api.changeBG()
        if tw > 57 then
            api.addBG(api.getRandomBG())
            api.animateBG(-th+1)
        else
            api.addBG(api.loadImg("images/basalty.bimg"))
            api.animateBG(-th+1)
        end
    end

    function api.drawIcon(ox, oy, ifg, ibg, filename)
        local icon = desktop:addFrame("icon")
            :setBackground(ibg)
            :setSize(8, 5)
            :setPosition(ox,oy)

        local iconArea = icon:addFrame("iconArea")
            :setBackground(ibg)
            :setSize(8, 4)
            :setPosition(1,1)

        iconArea:addLabel("line_"..1)
            :setText("\151\8\8\8\8\8\8\139")
            :setPosition(1, 1)
            :setForeground(ifg)
        iconArea:addLabel("line_"..2)
            :setText("\149\127\127\127\127\127\127\138")
            :setPosition(1, 2)
            :setForeground(ifg)

        iconArea:addLabel("line_"..3)
            :setText("\149\127\127\127\127\127\127\138")
            :setPosition(1, 3)
            :setForeground(ifg)
        iconArea:addLabel("line_"..4)
            :setText("\141\8\8\8\8\8\8\142")
            :setPosition(1, 4)
            :setForeground(ifg)

        local filename = icon:addLabel("filename")
            :setPosition(1, 5)
            :setForeground(ifg)
            :setText("\187" .. filename)
            


    end

    function api.start(monitor)
        basalt.schedule(function()
            api.drawMenuBar()
            api.drawDesktop()
            os.sleep(0.15)
            api.changeBG()
            os.sleep(1)

            api.drawTaskbar()
            os.sleep(0.15)

            api.drawIcon(1, 2, colors.orange, colors.gray, "Calc")
            api.drawIcon(10, 2, colors.magenta, colors.white, "Paint")
            api.drawIcon(19, 2, colors.white, colors.lightBlue, "Weather")

            api.drawIcon(1, 8, colors.lightBlue, colors.gray, "Devices")
            api.drawIcon(10, 8, colors.cyan, colors.white, "GPS")
            api.drawIcon(19, 8, colors.white, colors.purple, "Remote")

            api.drawIcon(1, 14, colors.green, colors.white, "Logs")
            api.drawIcon(10, 14, colors.red, colors.yellow, "Games")
            api.drawIcon(19, 14, colors.lime, colors.black, "Media")

            api.showWelcomeWindow()
             os.sleep(0.5)
             api.animateWindow()
        end)
    

        return api
    end

    return api
end