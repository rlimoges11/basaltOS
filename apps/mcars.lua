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
        -- term: 51
        -- small : 121
        -- large : 164


        local mw, mh = monitor:getSize()
        panels[#panels] = api.drawPanel(1, 1, 40, 20, colors.blue, colors.lightBlue, 4)


        local floggerApp = panels[1]:addProgram()
            :setSize(33, 16)
            :setPosition(3,3)
            :execute("programs/fLogger")

        panels[#panels] = api.drawPanel(41, 1, 40, 20, colors.blue, colors.lightBlue, 2)
        local floggerApp2 = panels[2]:addProgram()
            :setSize(38, 16)
            :setPosition(3,5)
            :execute("programs/fLogger")



        panels[#panels] = api.drawPanel(81, 1, 40, 20, colors.blue, colors.lightBlue, 5)
        panels[#panels] = api.drawPanel(121, 1, 40, 20, colors.blue, colors.lightBlue, 6)

        panels[#panels] = api.drawPanel(1, 20, 40, 20, colors.blue, colors.lightBlue, 3)
        local floggerApp3 = panels[5]:addProgram()
            :setSize(33, 16)
            :setPosition(3,3)
            :execute("programs/fLogger")


        panels[#panels] = api.drawPanel(41, 20, 40, 20, colors.blue, colors.lightBlue, 1)
        panels[#panels] = api.drawPanel(81, 20, 40, 20, colors.blue, colors.lightBlue, 5)
        panels[#panels] = api.drawPanel(121, 20, 40, 20, colors.blue, colors.lightBlue, 6)


    deb = panels[0]:addFrame()
        :setSize(12,1)
        :setPosition(1,1)
        :setBackground(colors.black)
    deb:addLabel()
        :setForeground(colors.white)
        :setText("w: " .. tw .. " h: " .. th)


    end

    return api, basalt
end