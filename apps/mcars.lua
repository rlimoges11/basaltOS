basalt = require("basalt")
_G.flogger_colors = {
  hc = colors.purple,
  fg = colors.lightBlue,
  bg = colors.black
}
return function(monitor)
    local tw, th = monitor:getSize()
    local api = {}
    local panels = {}
    local main = basalt.createFrame()

    main:setTerm(monitor)
        :setSize(tw, th)
        :setPosition(1,1)
        :setBackground(colors.orange)

    function api.drawPanel(x, y, w, h, fg, bg, frame)
        local thisPanel = main:addFrame("panel")
            :setPosition(x, y)
            :setSize(w, h)
            :setBackground(bg)
            :setForeground(fg)
            :onClick(function(thisPanel)
                    thisPanel.bgImg:setCurrentFrame(math.random(1, 9))
            end)

        local img = api.loadImg("images/mcars.bimg")
        thisPanel.bgImg = thisPanel:addImage()
            :setBimg(img)
            :setSize(w, h)
            :setCurrentFrame(frame)
            :setX(1)
            :setY(1)
            :setBackground(colors.black)

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
        -- pocket : 26, 20
        -- term: 51, 19
        -- small : 121, 38
        -- large : 164, 38

        if tw == 164 then
            -- Large layout
            -- Row 1
            panels[#panels] = api.drawPanel(1, 1, 40, 20, colors.blue, colors.lightBlue, 4)

            local floggerApp = panels[#panels-1]:addProgram()
                :setSize(33, 16)
                :setPosition(3,3)
                :execute("programs/fLogger")

            panels[#panels] = api.drawPanel(41, 1, 40, 20, colors.blue, colors.lightBlue, 2)
            panels[#panels] = api.drawPanel(81, 1, 40, 20, colors.blue, colors.lightBlue, 5)
            panels[#panels] = api.drawPanel(123, 1, 40, 20, colors.blue, colors.lightBlue, 6)

            
            -- Row 2
            panels[#panels] = api.drawPanel(1, 20, 40, 20, colors.blue, colors.lightBlue, 3)
            local floggerApp3 = panels[#panels-1]:addProgram()
                :setSize(33, 16)
                :setPosition(3,3)
                :execute("programs/fLogger")
            panels[#panels] = api.drawPanel(41, 20, 40, 20, colors.blue, colors.lightBlue, 1)
            local floggerApp2 = panels[#panels-1]:addProgram()
                :setSize(37, 16)
                :setPosition(3,5)
                :execute("programs/fLogger")

            panels[#panels] = api.drawPanel(81, 20, 40, 20, colors.blue, colors.lightBlue, 5)
            panels[#panels] = api.drawPanel(123, 20, 40, 20, colors.blue, colors.lightBlue, 6)

        elseif tw == 121 then
            -- Medium Layout
            -- Header Row
            panels[#panels] = api.drawPanel(2, 1, 80, 10, colors.blue, colors.lightBlue, 9)
            panels[#panels] = api.drawPanel(82, 1, 40, 10, colors.blue, colors.lightBlue, 8)

            --Middle Row
            panels[#panels] = api.drawPanel(2, 11, 40, 20, colors.blue, colors.lightBlue, 1)
            local floggerApp1 = panels[#panels-1]:addProgram()
                :setSize(33, 16)
                :setPosition(3,6)
                :execute("programs/fLogger")

            panels[#panels] = api.drawPanel(42, 11, 80, 20, colors.blue, colors.lightBlue, 4)
            local floggerApp2 = panels[#panels-1]:addProgram()
                :setSize(33, 16)
                :setPosition(3,3)
                :execute("programs/fLogger")
            panels[#panels] = api.drawPanel(82, 11, 40, 20, colors.blue, colors.lightBlue, 2)
            local floggerApp3 = panels[#panels-1]:addProgram()
                :setSize(33, 16)
                :setPosition(3,6)
                :execute("programs/fLogger")


            --Bottom Row
            panels[#panels] = api.drawPanel(2, 31, 80, 10, colors.blue, colors.lightBlue, 8)
            panels[#panels] = api.drawPanel(82, 31, 40, 20, colors.blue, colors.lightBlue, 8)



        elseif tw == 51 then
            -- Computer Teminal Layout
            panels[#panels] = api.drawPanel(1, 1, 51, 20, colors.blue, colors.lightBlue, 4)
            local floggerApp = panels[#panels-1]:addProgram()
                :setSize(33, 16)
                :setPosition(3,3)
                :execute("programs/fLogger")

            panels[#panels] = api.drawPanel(41, 1, 40, 20, colors.blue, colors.lightBlue, 2)

        elseif pocket then
            -- Pocket Computer Layout
            panels[#panels] = api.drawPanel(1, 1, 26, 20, colors.blue, colors.lightBlue, 1)
            local floggerApp = panels[1]:addProgram()
                :setSize(23, 16)
                :setPosition(3,6)
                :execute("programs/fLogger")
            
        end

    deb = panels[0]:addFrame()
        :setSize(12,1)
        :setPosition(2,2)
        :setBackground(colors.black)
        :setVisible(false)
    deb:addLabel()
        :setForeground(colors.orange)
        :setText("W: " .. tw .. " H: " .. th)
    end

    return api, basalt
end