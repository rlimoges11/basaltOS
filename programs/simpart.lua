-- Minimal .bimg renderer for CC:Tweaked
local file = "images/astrolab.bimg"
if not fs.exists(file) then
    print("Missing "..file)
    return
end

-- Map your character codes to colors (example: adjust to your .bimg encoding)
local function parseChar(c)
    -- This example just returns white text, black bg
    return colors.white, colors.black, c
end

term.clear()
term.setCursorPos(1,1)

local f = fs.open(file,"r")
for y,line in ipairs((function()
    local t = {}
    local content = fs.open(file,"r").readAll()
    for l in content:gmatch("[^\n]+") do table.insert(t,l) end
    return t
end)()) do
    term.setCursorPos(1,y)
    for x=1,#line do
        local fg,bg,ch = parseChar(line:sub(x,x))
        term.setTextColor(fg)
        term.setBackgroundColor(bg)
        term.write(ch)
    end
end
term.setTextColor(colors.white)
term.setBackgroundColor(colors.black)
