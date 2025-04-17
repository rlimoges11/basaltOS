basalt = require("basalt")
panels = {}


return function()
    local tw, th = term.getSize()
    local api = {}
    
    local main = basalt.createFrame()
        :setSize(tw, th)
        :setPosition(1,1)
        :setBackground(colors.black)

    local frame = main:addFrame()
        :setSize(tw, th)
        :setPosition(1,1)
        :setBackground(colors.orange)


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

    function api.start(monitor)
        if monitor ~= nil then
            if term.current() ~= term.native() then
                term.redirect(monitor)

                if monitor.setTextScale then
                    monitor.setTextScale(0.5)
                    tw, th = term.getSize()


                    local c = colors.blue
                    for j = 0, 5, 1 do
                        if j == 0 then 
                            for i = 0, 7, 1 do
                                if i%2 == 0  then
                                    c = colors.black
                                 else
                                    c = colors.blue
                                end
                                panels[#panels] = api.drawPanel(i*20+3,2,20,10, c)
                            end
                        elseif j < 4 then
                            for i = 0, 3, 1 do
                                if (i%2 == 0 and j%2 == 0) or (i%2 ~= 0  and j%2 ~= 0) then
                                    c = colors.blue
                                 else
                                    c = colors.black
                                end
                                panels[#panels] = api.drawPanel(i*40+3,j*20 + 2 - 10, 40,20, c)
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
                    
                end
            end
        
        else
            panels[#panels] = api.drawPanel(2,2,23,18, colors.blue)
        end

    end


    return api, basalt
end