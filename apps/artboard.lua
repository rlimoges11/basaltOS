basalt = require("basalt")

return function(monitor)
    local tw, th = monitor:getSize()
    local api = {}
    local panels = {}
    local art = {}

    art[#art+1] = "astrolab"
    art[#art+1] = "basalt2"
    art[#art+1] = "basalt2b"
    art[#art+1] = "cabin"
    art[#art+1] = "enterprise"
    art[#art+1] = "friona"
    art[#art+1] = "gate"
    art[#art+1] = "guardian"
    art[#art+1] = "helios"
    art[#art+1] = "helios-2"
    art[#art+1] = "helios-3"
    art[#art+1] = "illager"
--art[#art+1] = "janur"
    art[#art+1] = "kerrigan"
    art[#art+1] = "lion"
    art[#art+1] = "M"
    art[#art+1] = "magitech"
    art[#art+1] = "ps1"
    art[#art+1] = "reactor"
    art[#art+1] = "seascape"
    art[#art+1] = "skelak"
    art[#art+1] = "spooky"
    art[#art+1] = "stairs"
    art[#art+1] = "starbase"
    art[#art+1] = "starbase2"
    art[#art+1] = "student"
    art[#art+1] = "tantalius"
    art[#art+1] = "tavern"
    art[#art+1] = "tree"
    art[#art+1] = "wiz"
    art[#art+1] = "wiz2"
    art[#art+1] = "wiz3"
    art[#art+1] = "wiz4"
    art[#art+1] = "wiz5"

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
        local r = math.random(1, #art)
	    local img = api.loadImg("images/" .. art[r] .. ".bimg")
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
            :onClick(function(thisPanel)
                os.reboot()
            end)

    end

    return api, basalt
end