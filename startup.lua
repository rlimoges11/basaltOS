local file = "images/astrolab.bimg"

if not fs.exists(file) then
    print("Missing "..file)
    return
end

local ok, image = pcall(paintutils.loadImage, file)
if not ok then
    print("Failed to load .bimg: "..tostring(image))
    return
end

term.clear()
term.setCursorPos(1,1)

-- Draw using term.blit()
for y, row in ipairs(image) do
    local chars = row[1] or ""
    local fg    = row[2] or ""
    local bg    = row[3] or ""
    term.setCursorPos(1, y)
    term.blit(chars, fg, bg)
end

-- Reset colors
term.setTextColor(colors.white)
term.setBackgroundColor(colors.black)
