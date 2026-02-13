local file = "images/astrolab.bimg"
if not fs.exists(file) then
    print("Missing "..file)
    return
end

-- Read JSON content
local f = fs.open(file,"r")
local raw = f.readAll()
f.close()

local bimgData = textutils.unserialize(raw)
if not bimgData then
    print("Failed to parse .bimg")
    return
end

term.clear()
term.setCursorPos(1,1)

-- bimgData is assumed to be a table of rows, each row = {char, fg, bg}
for y,row in ipairs(bimgData) do
    term.setCursorPos(1,y)
    for x,pixel in ipairs(row) do
        term.setTextColor(pixel.fg or colors.white)
        term.setBackgroundColor(pixel.bg or colors.black)
        term.write(pixel.ch or " ")
    end
end

-- Reset colors
term.setTextColor(colors.white)
term.setBackgroundColor(colors.black)
