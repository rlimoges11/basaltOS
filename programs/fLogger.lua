local contentHelpers = require("/lib/contentHelpers")
local args = { ... }
local hc = (_G.flogger_colors and _G.flogger_colors.hc) or colors.lime
local fg = (_G.flogger_colors and _G.flogger_colors.fg) or colors.green
local bg = colors.black
term.setTextColor(fg)
term.setBackgroundColor(bg)

while true do
	logRandomMessage()
	sleep(math.random(2.5, 8))
end