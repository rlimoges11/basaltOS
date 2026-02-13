local file = "images/astrolab.bimg"
if not fs.exists(file) then
    print("Missing "..file)
    return
end

-- Load JSON content
local f = fs.open(file,"r")
local raw = f.readAll()
f.close()
local ok, data = pcall(textutils.unserialize, raw)
if not ok then
    print("Failed to parse .bimg")
    return
end

term.clear()
term.setCursorPos(1,1)

-- Map hex strings to CC colors
local function hexToColor(h)
    if h == "0000" then return colors.black
    elseif h == "ffff" then return colors.white
    else return colors.gray -- fallback
    end
end

for y,rowTriple in ipairs(data) do
    local chars, bgStr, fgStr = rowTriple[1], rowTriple[2], rowTriple[3]
    term.setCursorPos(1,y)
    for x=1,#chars do
        local ch = chars:sub(x,x)
        local bg = hexToColor(bgStr:sub(x,x))
        local fg = hexToColor(fgStr:sub(x,x))
        term.setBackgroundColor(bg)
        term.setTextColor(fg)
        term.write(ch)
    end
end

-- Reset colors
term.setTextColor(colors.white)
term.setBackgroundColor(colors.black)
