basalt = require("basalt")

return function(monitor)
    local tw, th = monitor:getSize()
    local api = {}
    local panels = {}
    local main = basalt.createFrame()

    main:setTerm(monitor)
        :setSize(tw, th)
        :setPosition(1,1)
        :setBackground(colors.green)

    local frame = main:addFrame()
        :setSize(tw, th)
        :setPosition(1,1)
        :setBackground(colors.black)


    function api.drawPanel(x, y, w, h, bg)
        local thisPanel = main:addFrame("panel")
            :setPosition(x,y)
            :setSize(w,h)
            :setBackground(bg)
            :onClick(function(thisPanel)
                    thisPanel.bgImg:setCurrentFrame(math.random(1,9))
            end)

        local img = api.loadImg("images/mcars.bimg")
        thisPanel.bgImg = thisPanel:addImage()
            :setBimg(img)
            :setSize(w, h)
            :setCurrentFrame(math.random(1,9))
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
        local c = colors.blue

        for j = 0, 5, 1 do
            if j == 0 then 
                for i = 0, 7, 1 do
                    if i%2 == 0  then
                        c = colors.black
                     else
                        c = colors.blue
                    end
                    panels[#panels] = api.drawPanel(i*20+1,1,20,10, c)
                end
            elseif j < 4 then
                for i = 0, 3, 1 do
                    if (i%2 == 0 and j%2 == 0) or (i%2 ~= 0  and j%2 ~= 0) then
                        c = colors.blue
                     else
                        c = colors.black
                    end
                    panels[#panels] = api.drawPanel(i*40+1,j*20 - 9, 40,20, c)
                end
            elseif j == 4 then
                
                for i = 0, 7, 1 do
                    if i%2 ~= 0  then
                        c = colors.blue
                     else
                        c = colors.black
                    end
                    panels[#panels] = api.drawPanel(i*20+3,72,20,10, c)
                end
            end
        end

        --panels[#panels] = api.drawPanel(2,2,23,18, colors.blue)

    end

    return api, basalt
end