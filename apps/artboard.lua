basalt = require("basalt")

return function(monitor)
    local tw, th = monitor:getSize()
    local api = {}
    local panels = {}

    local main = basalt.createFrame()
    main:setTerm(monitor)
        :setSize(tw, th)
        :setPosition(1,1)
        :setBackground(colors.black)

    function api.loadImg(path)
        local file = fs.open(path, "r")
        if file then
            img = textutils.unserialize(file.readAll())
            file:close()
        end

        return img
    end

    function api.start()
	    local img = api.loadImg("images/astrolab.bimg")
	    local artPanel = main:addFrame("artPanel")
	        :setPosition(1, 1)
	        :setSize(tw, th)
	        :setBackground(colors.black)
	        :setForeground(colors.white)

	    local Img = artPanel:addImage()
	        :setBimg(img)
	        :setSize(tw, th)
	        :setCurrentFrame(1)
	        :setX(1)
	        :setY(2)
	        :setBackground(colors.orange)
    end

    return api, basalt
end