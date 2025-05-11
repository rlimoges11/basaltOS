basalt = require("basalt")

return function(parentFrame, monitor1, monitor2)
    local tw, th = term.getSize()
    local api = {}
    local frame = parentFrame:addFrame()
        :setSize(tw, th)
        :setBackground(colors.lightGray)

    local desktop, desktop2, desktop3 = nil        
    local menuBar, menuBar2, menuBar3 = nil        

    function api.drawDesktop()
        desktop = frame:addFrame("desktop")
            :setPosition(1, 1)
            :setSize(tw, th)
            :setBackground(colors.lightGray)

        if monitor1 ~= nil then
            desktop2 = monitor1:addFrame("desktop2"):setSize(monitor1:getSize()):setBackground(colors.lightBlue)
        end
        if monitor2 ~= nil then
            desktop3 = monitor2:addFrame("desktop3"):setSize(monitor2:getSize()):setBackground(colors.orange)
        end

    end

    function api.animateWindow()
        windowContainer:setVisible(false)
        windowContainer:setY(-10)
        os.sleep(0.01)
        windowContainer:setVisible(true)
        windowContainer:animate()
            :resize(1, 1, 0) 
            :sequence()
            :move(2, 3, 0.5)  -- Move down
            :resize(1, 14, 1.25) 
            :sequence()
            :resize(23, 14, 0.5) 
            :sequence()
            :start()
    end

    function api.getRandomBG()
        local images = {
            "images/astrolab.bimg",
            "images/basalt2.bimg",
            "images/basalt3.bimg",
            "images/cabin.bimg",
            "images/dragon.bimg",
            "images/enterprise.bimg",
            "images/friona.bimg",
            "images/gate.bimg",
            "images/guardian.bimg",
            "images/helios.bimg",
            "images/helios-2.bimg",
            "images/helios-3.bimg",
            "images/illager.bimg",
            "images/magitech.bimg",
            "images/mech.bimg",
            "images/kerrigan.bimg",
            "images/ps1.bimg",
            "images/reactor.bimg",
            "images/seascape.bimg",
            "images/skelak.bimg",
            "images/spooky.bimg",
            "images/starbase.bimg",
            "images/starbase2.bimg",
            "images/stirs.bimg",
            "images/steampunk.bimg",
            "images/student.bimg",
            "images/sunset.bimg",
            "images/tantalius.bimg",
            "images/tavern.bimg",
            "images/tree.bimg",
            "images/wiz.bimg",
            "images/wiz2.bimg",
            "images/wiz3.bimg",
            "images/wiz4.bimg",
            "images/wiz5.bimg",
        }

        -- Shuffle the images array
        for i = #images, 2, -1 do
            local j = math.random(i)
            images[i], images[j] = images[j], images[i]
        end

        --api.loadImg("images/tree.bimg")
        api.loadImg(images[1])

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

    function api.drawMenuBar(dt)
        tw,th = dt:getSize()

        menuBar = dt:addFrame("menuBar")
            :setPosition(-tw+1, 1)
            :setSize(tw, 19)
            :setBackground(colors.gray)
            :setVisible(false)
            os.sleep(0.25)


        menuBar:setVisible(true)

        menuBar:onClick(function(menuBar)
            mw,mh = menuBar:getSize()

            if mh == 1 then 
                -- Slide open
                menuBar:animate()
                    :resize(mw, 19, 0.25)
                    :start()
            else
                -- Slide closed
                menuBar:animate()
                    :resize(mw, 1, 0.25)
                    :start()
            end
        end)

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
                local timestamp = textutils.formatTime(os.time("local"), false)
                if #timestamp < 8 then
                    timestamp = " " .. timestamp
                    
                end
                clock:setText(timestamp .. " ^")
                os.sleep(30)
            end
        end

        -- Start clock in a coroutine
        basalt.schedule(updateClock)
    end

    function api.drawTaskbar(dt)
        tw, th = dt:getSize()

        taskbar = dt:addFrame("taskbar")
            :setPosition(-tw+1, th)
            :setSize(tw, 1)
            :setBackground(colors.gray)
            :setForeground(colors.lightBlue)
            :onClick(function()
                api.changeBG()
            end)
            os.sleep(0.1)

            taskbar:animate()
                :move(1,th,0.5)
                :sequence()
                :start()
            os.sleep(0.5)

    end

    function api.showWelcomeWindow(dt)
        -- Window dimensions (will auto-adjust to content)
        tw, th = dt:getSize()
        windowWidth = math.min(40, tw)
        windowHeight = math.min(24, th - 6)
        winX = math.floor((tw - windowWidth) / 2) + 2
        winY = math.floor((th - windowHeight) / 2) + 1
        state = "normal"

        windowContainer = dt:addFrame("welcomeWindow")
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
        titlebar = borderFrame:addFrame()
            :setPosition(3, 1)
            :setSize(windowWidth-3, 1)
            :setBackground(colors.gray)
            :addLabel("title")
            :setText("Welcome to Helios")
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
                    windowHeight = th - 1
                    windowContainer:setPosition(1, 1)
                    windowContainer:setSize(tw, windowHeight + 1)
                    borderFrame:setSize(tw, windowHeight+1)
                    welcomeWin:setSize(tw - 2, windowHeight - 1)
                    welcomeText:setWidth(welcomeWin:getWidth())
                    state = "maximized"
                    minbtn:setText("\31")
                    maxbtn:setText("-")
                else
                    -- normalize
                    windowHeight = 14
                    windowContainer:setPosition(winX, winY)
                        :setSize(windowWidth -2, windowHeight)
                    welcomeText:setWidth(welcomeWin:getWidth())

                    borderFrame:setSize(windowWidth, windowHeight)

                    welcomeWin:setPosition(2, 2)
                        :setSize(windowWidth-4, 12)

                    welcomeText:setSize(windowWidth-4, 12)

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
                        welcomeText:setWidth(welcomeWin:getWidth())

                        maxbtn:setText("\30")
                        minbtn:setText("\31")
                        state = "normal"
                    else
                        windowHeight = 1
                        windowContainer:setPosition(1, th)
                        windowContainer:setSize(10,1)
                        borderFrame:setSize(10,1)

                        maxbtn:setText("\30")
                        minbtn:setText("-")
                        state = "minimized"
                    end
                end
            )

        local textContent = "Sorry I'm afk right now, back in a few minutes"
        welcomeText = welcomeWin:addLabel({x=1, y=2, autoSize=false, width=21})
            :setText(textContent)
            :setForeground(colors.lightBlue)

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

    function api.addBG(img1, img2, img3)
        bgImg = desktop:addImage()
            :setBimg(img1)
            :setSize(desktop:getSize())
            :setCurrentFrame(1)
            :setX(1)
            :setY(1)
            :setBackground(colors.gray)
            :setVisible(false)


        if monitor1 ~= nil then
            bgImg2 = desktop2:addImage()
                :setBimg(img2)
                :setSize(desktop2:getSize())
                :setCurrentFrame(1)
                :setX(1)
                :setY(1)
                :setBackground(colors.gray)
                :setVisible(false)

        end

        if monitor2 ~= nil then
            bgImg3 = desktop3:addImage()
                :setBimg(img3)
                :setSize(desktop3:getSize())
                :setCurrentFrame(1)
                :setX(1)
                :setY(1)
                :setBackground(colors.gray)
                :setVisible(false)
        end

    end

    function api.animateBG(offsetY)
        basalt.schedule(function()
            bgImg:setVisible(true)
            bgImg:setY(offsetY + 1)
            bgImg:animate()
                :move(1, 1, 1)  -- Move down
                :start()

            os.sleep(0.25)
            if monitor1 then
                bgImg2:setVisible(true)
                bgImg2:setY(offsetY)
                bgImg2:animate()
                    :move(1, 1, 1)  -- Move down
                    :start()
            end
            os.sleep(0.25)
            if monitor2 then
                bgImg3:setVisible(true)
                bgImg3:setY(offsetY)
                bgImg3:animate()
                    :move(1, 1, 1)  -- Move down
                    :start()
            end
        end)
    end

    function api.changeBG()
        local img1 = api.loadImg("images/basalty.bimg")
        local img2 = api.getRandomBG()
        local img3 = api.getRandomBG()

        api.addBG(img1, img2, img3)

        api.animateBG(-th)
    end

    function api.drawIcon(el, ox, oy, ifg, ibg, filename, appPath)
        local icon = el:addFrame("icon")
            :setBackground(ibg)
            :setSize(8, 5)
            :setPosition(ox,oy)
            :onClick(function()
                local trek = desktop:addProgram()
                    :setSize(tw,th)
                    :execute(appPath)
            end)

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

    function api.start()
        basalt.schedule(function()
            
            api.drawDesktop()
            os.sleep(0.5)
            api.changeBG()
            os.sleep(1)

            api.drawTaskbar(desktop)
            os.sleep(0.15)

            if desktop2 ~= nil then 
                api.drawTaskbar(desktop2)
                os.sleep(0.15)
            end

            if desktop3 ~= nil then 
                api.drawTaskbar(desktop3)
                os.sleep(0.15)
            end

            api.drawMenuBar(desktop)

            api.drawIcon(menuBar, 1, 2, colors.orange, colors.gray, "Calc", "apps/trek.lua")
            api.drawIcon(menuBar, 10, 2, colors.magenta, colors.white, "Paint", "apps/basaltImage.lua")
            api.drawIcon(menuBar, 19, 2, colors.white, colors.lightBlue, "Weather", "apps/weather.lua")

            api.drawIcon(menuBar, 1, 8, colors.lightBlue, colors.gray, "Home", "apps/home.lua")
            api.drawIcon(menuBar, 10, 8, colors.cyan, colors.white, "MCARS", "apps/trek.lua")
            api.drawIcon(menuBar, 19, 8, colors.white, colors.purple, "Remote", "apps/trek.lua")

            api.drawIcon(menuBar, 1, 14, colors.green, colors.white, "Logs", "apps/trek.lua")
            api.drawIcon(menuBar, 10, 14, colors.red, colors.yellow, "Games", "apps/hellevator.lua")
            api.drawIcon(menuBar, 19, 14, colors.lime, colors.black, "Media", "apps/trek.lua")

        menuBar:animate()
            :move(1,1,0.25)
            :sequence()
            :start()
            os.sleep(0.25)


            if desktop2 ~= nil then 
                api.drawMenuBar(desktop2)
                os.sleep(0.1)
            end

            if desktop3 ~= nil then
                api.drawMenuBar(desktop3)
                os.sleep(0.1)
            end

            os.sleep(0.5)

            if desktop2 ~= nil then 
                api.showWelcomeWindow(desktop2)
             else
                api.showWelcomeWindow(desktop)
             end
            os.sleep(1)

            mw,mh = menuBar:getSize()
            menuBar:animate()
                :resize(mw,1,0.25)
                :start()
            os.sleep(0.25)
            api.animateWindow()
        end)

        return api
    end

    return api
end