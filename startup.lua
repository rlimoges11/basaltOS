local file = "images/astrolab.bimg"

-- Make sure file exists
if not fs.exists(file) then
    print("Missing "..file)
    return
end

-- Load the .bimg using paintutils
local ok, image = pcall(paintutils.loadImage, file)
if not ok then
    print("Failed to load .bimg: "..tostring(image))
    return
end

-- Clear terminal and start at top-left
term.clear()
term.setCursorPos(1,1)

-- Draw the image row by row
for y,row in ipairs(image) do
    local chars = row[1] or ""  -- fallback empty string
    local fg    = row[2] or ""  -- fallback empty string
    local bg    = row[3] or ""  -- fallback empty string

    term.setCursorPos(1, y)
    term.blit(chars, fg, bg)    -- proper blit display
end

-- Reset terminal colors
term.setTextColor(colors.white)
term.setBackgroundColor(colors.black)
