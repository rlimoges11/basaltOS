-- Minimal .bimg display
local file = "images/astrolab.bimg"
local f = fs.open(file,"r")
if not f then print("Missing "..file) return end
local data = f.readAll()
f.close()

term.clear()
term.setCursorPos(1,1)
for line in data:gmatch("[^\n]+") do
    print(line)
end
