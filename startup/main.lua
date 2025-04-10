HelNet = require("../cc-helpers/NetworkHelpers")
HelMonitor = require("../cc-helpers/MonitorHelpers")
HelWindows = require("../cc-helpers/WindowHelpers")
HelEvents = require("../cc-helpers/EventHelpers")

i_menu = paintutils.loadImage("images/menu.nfp")
paletteOpen = false

background = openWindow("Background", 1, 1, 26, 20, colors.white, colors.black, colors.white, colors.black, false, false)
background.drawImg(i_menu, 1, 1)

sensors = openWindow("Sensors", 4, 3, 25, 6, colors.lightBlue, colors.blue, colors.blue, colors.lightBlue, true, false)
logs = openWindow("Logs", 4, 8, 25, 14, colors.white, colors.gray, colors.black, colors.white, true, true)

menu = createMenu()


function togglePaletteGUI()
	if paletteOpen == false then
		drawPalette(6,18)
		paletteOpen = true
	else
		paintutils.drawLine(1,18, 26, 18, colors.gray)
		paletteOpen = false
	end

end

parallel.waitForAll(wait_for_transmissions, HelEvents.wait_for_click, HelEvents.wait_for_keyPress)