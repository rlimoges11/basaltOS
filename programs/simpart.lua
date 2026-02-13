-- Minimal .bimg renderer for astrolab
local file = "images/astrolab.bimg"
if not fs.exists(file) then print("Missing "..file) return end
local f = fs.open(file,"r")
local data = f.readAll()
f.close()

term.clear()
term.setCursorPos(1,1)

-- Example parser for simple CC .bimg: each char is one pixel
-- If your .bimg stores fg/bg info, you can expand parser here
local y = 1
for line in data:gmatch("[^\n]+") do
    term.setCursorPos(1,y)
    term.write(line) -- simple: just prints the ASCII art
    y = y + 1
end
