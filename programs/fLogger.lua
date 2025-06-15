local contentHelpers = require("/lib/contentHelpers")
local args = { ... }
local hc = colors.lime
local fg = colors.green
local bg = colors.black
term.setTextColor(fg)
term.setBackgroundColor(bg)

logRandomMessage(fg, bg, hc)