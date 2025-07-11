basalt = require("/lib/basalt")
contentHelpers = require("/lib/contentHelpers")

return function(monitor, layout)
    local tw, th = monitor:getSize()
    local api = {}
    local panels = {}
    local main = nil

    if layout == "Ninja" then
        main = monitor
        main:setBackground(colors.blue)
    else
        main = basalt.createFrame()
        main:setTerm(monitor)
            :setSize(tw, th)
            :setPosition(1, 1)
            :setBackground(colors.orange)
    end

    function api.drawPanel(x, y, w, h, fg, bg, frame)
        local hc = colors.yellow
        main:setForeground(fg)
        main:setBackground(bg)

        local thisPanel = main:addFrame("panel")
            :setPosition(x, y)
            :setSize(w, h)
            :setBackground(bg)
            :setForeground(fg)
            if frame < 10 then
                thisPanel:onClick(function(thisPanel)
                    thisPanel.bgImg:setCurrentFrame(math.random(1, 9))
                end)
            else
                thisPanel:onClick(function(thisPanel)
                    os.reboot()
                end)

            end

        local img = api.loadImg("images/mcars.bimg")

        if frame == 10 then
            img = api.loadImg("images/enterprise.bimg")
            frame = 1
            thisPanel.bgImg = thisPanel:addImage()
                :setBimg(img)
                :setSize(164, 80)
                :setCurrentFrame(1)
                :setX(1)
                :setY(-8)
                :setZ(1)

            local tanim = thisPanel.bgImg:animate()
                :move(-28, -28, 1.0)
                :sequence()


                :start()
        end

        if frame == 11 then
            img = api.loadImg("images/reactor.bimg")
            thisPanel.bgImg = thisPanel:addImage()
                :setBimg(img)
                :setSize(164, 80)
                :setCurrentFrame(1)
                :setX(1)
                :setY(1)
                :setZ(1)

            local tanim = thisPanel.bgImg:animate()
                :move(1, -40, 1.0)
                :start()

            reactorLogs = thisPanel:addLabel({x=63, y=12, autoSize=false, width= 44, height= 14, autoResize=false})
                :setText("")
                :setZ(15)
                :setForeground(fg)
                :setBackground(bg)

            contentHelpers(reactorLogs, colors.yellow, bg, colors.yellow)
        end
        

        if thisPanel.bgImg == nil then
            thisPanel.bgImg = thisPanel:addImage()
            :setBimg(img)
            :setSize(w, h)
            :setCurrentFrame(frame)
            :setX(1)
            :setY(1)
            :setZ(1)
        end

        
        table.insert(panels, thisPanel)

        return thisPanel
    end

    function api.loadImg(path)
        local file = fs.open(path, "r")
        if file then
            img = textutils.unserialize(file.readAll())
            file:close()
        end

        return img
    end

    function api.start()
        if layout == nil or layout == "" then
            ----------------------------
            -- Default layouts
            ----------------------------
            -- hol 143, 81 [7x6]
            -- pocket : 26, 20
            -- term: 51, 19
            -- small : 121, 38[5x3]
            -- large : 164, 38[8x3]

            if tw == 164 then
                -- Large layout
                -- Row 1
                panels[#panels] = api.drawPanel(1, 1, 40, 20, colors.blue, colors.lightBlue, 4)

                

                panels[#panels] = api.drawPanel(41, 1, 40, 20, colors.blue, colors.lightBlue, 2)
                
                panels[#panels] = api.drawPanel(81, 1, 40, 20, colors.blue, colors.lightBlue, 5)
                panels[#panels] = api.drawPanel(123, 1, 40, 20, colors.blue, colors.lightBlue, 6)

                
                -- Row 2
                panels[#panels] = api.drawPanel(1, 20, 40, 20, colors.blue, colors.lightBlue, 3)
                panels[#panels] = api.drawPanel(41, 20, 40, 20, colors.blue, colors.lightBlue, 1)
                
                panels[#panels] = api.drawPanel(81, 20, 40, 20, colors.blue, colors.lightBlue, 5)
                panels[#panels] = api.drawPanel(123, 20, 40, 20, colors.blue, colors.lightBlue, 6)

            elseif tw == 143 then
                panels[#panels] = api.drawPanel(1, 1, 143, 81, colors.blue, colors.lightBlue, 5)

            elseif tw == 121 then
                -- Medium Layout
                -- Header Row
                panels[#panels] = api.drawPanel(2, 1, 80, 10, colors.blue, colors.lightBlue, 9)
                panels[#panels] = api.drawPanel(82, 1, 40, 10, colors.blue, colors.lightBlue, 8)

                --Middle Row
                panels[#panels] = api.drawPanel(2, 11, 40, 20, colors.blue, colors.lightBlue, 1)

                panels[#panels] = api.drawPanel(42, 11, 80, 20, colors.blue, colors.lightBlue, 4)
                panels[#panels] = api.drawPanel(82, 11, 40, 20, colors.blue, colors.lightBlue, 2)
                

                --Bottom Row
                panels[#panels] = api.drawPanel(2, 31, 80, 10, colors.blue, colors.lightBlue, 8)
                panels[#panels] = api.drawPanel(82, 31, 40, 20, colors.blue, colors.lightBlue, 8)

            elseif tw == 51 then
                -- Computer Teminal Layout
                panels[#panels] = api.drawPanel(1, 2, 40, 18, colors.blue, colors.lightBlue, 4)
                panels[#panels] = api.drawPanel(41, 2, 11, 18, colors.blue, colors.lightBlue, 2)

            elseif pocket then
                -- Pocket Computer Layout
                panels[#panels] = api.drawPanel(1, 1, 26, 20, colors.blue, colors.lightBlue, 1)
                
            end
        else
            -- Holocube
            if layout == "Holocube-Top" then
                panels[#panels] = api.drawPanel(1, 1, tw, th, colors.white, colors.orange, 5)
                
            elseif layout == "Holocube-Bottom" then
                panels[#panels] = api.drawPanel(tw-39, th-19, 40, 20, colors.lightBlue, colors.blue, 3)

            elseif layout == "Holocube-Bottom" then
                panels[#panels] = api.drawPanel(1, 1, 143, 81, colors.lightBlue, colors.blue, 5)
           
           -- MI screens
            elseif layout == "MI-1A" then
                -- 164, 38 [8x3]
                -- row 1
                panels[#panels] = api.drawPanel(1, 1, 40, 10, colors.blue, colors.lightBlue, 8)
                panels[#panels] = api.drawPanel(41, 1, 40, 10, colors.blue, colors.lightBlue, 8)
                panels[#panels] = api.drawPanel(81, 1, 40, 10, colors.blue, colors.lightBlue, 8)
                panels[#panels] = api.drawPanel(121, 1, 44, 10, colors.blue, colors.lightBlue, 8)

                -- row 2 
                panels[#panels] = api.drawPanel(1, 11, 40, 20, colors.blue, colors.lightBlue, 4)
                panels[#panels] = api.drawPanel(41, 11, 40, 20, colors.blue, colors.lightBlue, 1)
                panels[#panels] = api.drawPanel(81, 11, 40, 20, colors.blue, colors.lightBlue, 2)
                panels[#panels] = api.drawPanel(121, 11, 44, 20, colors.blue, colors.blue, 3)

                -- Row 3
                panels[#panels] = api.drawPanel(1, 31, 40, 8, colors.blue, colors.lightBlue, 9)
                panels[#panels] = api.drawPanel(41, 31, 40, 8, colors.blue, colors.lightBlue, 9)
                panels[#panels] = api.drawPanel(81, 31, 40, 8, colors.white, colors.purple, 9)
                panels[#panels] = api.drawPanel(121, 31, 44, 8, colors.blue, colors.lightBlue, 9)

            elseif layout == "MI-1B" then
                -- 124, 38? [6x3]
                panels[#panels] = api.drawPanel(1, 1, tw, th, colors.lime, colors.green, 11)


            elseif layout == "MI-2A" then
                -- 124, 38? [6x3]
                panels[#panels] = api.drawPanel(1, 1, 20, 13, colors.pink, colors.purple, 1)
                panels[#panels] = api.drawPanel(1, 14, 20, 13, colors.pink, colors.purple, 2)
                panels[#panels] = api.drawPanel(1, 27, 20, 12, colors.pink, colors.purple, 1)
                panels[#panels] = api.drawPanel(21, 1, 80, 38, colors.pink, colors.black, 10)
                panels[#panels] = api.drawPanel(101, 1, 20, 13, colors.pink, colors.purple, 2)
                panels[#panels] = api.drawPanel(101, 14, 20, 13, colors.pink, colors.purple, 1)
                panels[#panels] = api.drawPanel(101, 27, 20, 12, colors.pink, colors.purple, 2)
            
            elseif layout == "MI-2B" then
                panels[#panels] = api.drawPanel(1, 1, 40, 20, colors.blue, colors.lightBlue, 4)
                panels[#panels] = api.drawPanel(41, 1, 40, 20, colors.blue, colors.lightBlue, 2)
                panels[#panels] = api.drawPanel(81, 1, 40, 20, colors.blue, colors.lightBlue, 5)
                panels[#panels] = api.drawPanel(123, 1, 40, 20, colors.blue, colors.lightBlue, 6)

                
                -- Row 2
                panels[#panels] = api.drawPanel(1, 20, 40, 20, colors.blue, colors.lightBlue, 3)
                panels[#panels] = api.drawPanel(41, 20, 40, 20, colors.blue, colors.lightBlue, 1)
                panels[#panels] = api.drawPanel(81, 20, 40, 20, colors.blue, colors.lightBlue, 5)
                panels[#panels] = api.drawPanel(123, 20, 40, 20, colors.blue, colors.lightBlue, 6)

            elseif layout == "Ninja" or pocket then
                panels[#panels] = api.drawPanel(1, 2, 27, 12, colors.pink, colors.brown, 1)
                panels[#panels] = api.drawPanel(28, 2, 12, 12, colors.pink, colors.brown, 2)
            end
        end
    end

    return api, basalt
end