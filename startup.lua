local file = "images/astrolab.bimg"
if not fs.exists(file) then
    print("Missing "..file)
    return
end

-- Load serialized JSON/CC table
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

-- Map hex strings or custom codes to CC colors
local function hexToColor(h)
    if h == "0" or h == "0000" then return colors.black
    elseif h == "f" or h == "ffff" then return colors.white
    elseif h == "1" then return colors.gray
    elseif h == "2" then return colors.red
    elseif h == "3" then return colors.green
    elseif h == "4" then return colors.blue
    elseif h == "5" then return colors.yellow
    elseif h == "6" then return colors.orange
    elseif h == "7" then return colors.purple
    else return colors.gray -- fallback
    end
end

for y,rowTriple in ipairs(data) do
    local chars, bgStr, fgStr = rowTriple[1], rowTriple[2], rowTriple[3]

    -- Make sure all strings are valid
    if type(chars) ~= "string" then chars = "" end
    if type(bgStr) ~= "string" then bgStr = string.rep("0", #chars) end
    if type(fgStr) ~= "string" then fgStr = string.rep("0", #chars) end

    term.setCursorPos(1,y)
    for x=1,#chars do
        local ch = (chars:sub(x,x)) or " "           -- safe fallback to space
        local bgChar = (bgStr:sub(x,x)) or "0"       -- safe fallback to black
        local fgChar = (fgStr:sub(x,x)) or "0"       -- safe fallback to black

        term.setBackgroundColor(hexToColor(bgChar))
        term.setTextColor(hexToColor(fgChar))
        term.write(ch)
    end
end

-- Reset terminal colors
term.setTextColor(colors.white)
term.setBackgroundColor(colors.black)
