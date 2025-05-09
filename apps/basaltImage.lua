local basalt
local args = {...}

if(args[1]=="install")then
    shell.run("wget", "run", "https://raw.githubusercontent.com/Pyroxenium/Basalt2/main/install.lua")
    return
end

if(fs.exists("basalt"))or(fs.exists("basalt.lua"))then
    basalt = require("basalt")
else
    basalt = load(http.get("https://raw.githubusercontent.com/Pyroxenium/Basalt2/main/release/basalt.lua").readAll(), nil, "bt", _ENV)()
end

if(basalt==nil)then
    error("Basalt not found!")
end


--basalt.LOGGER._enabled = true
--basalt.LOGGER._logToFile = true

local menuButtonBg = "{self.clicked and colors.black or colors.cyan}"
local centerPosition = "{parent.width/2-self.width/2}"
local tHex = {}
local imageElement

local function deepCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = deepCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

local plusImg = {
    {
    {
        "                ",
        "ffffffffffffffff",
        "9999999999999999",
      },
      {
        "                ",
        "ffffffffffffffff",
        "999999ffff999999",
      },
      {
        "                ",
        "ffffffffffffffff",
        "999999f00f999999",
      },
      {
        "                ",
        "ffffffffffffffff",
        "9ffffff00ffffff9",
      },
      {
        "                ",
        "ffffffffffffffff",
        "9f000000000000f9",
      },
      {
        "                ",
        "ffffffffffffffff",
        "9ffffff00ffffff9",
      },
      {
        "                ",
        "ffffffffffffffff",
        "999999f00f999999",
      },
      {
        "                ",
        "ffffffffffffffff",
        "999999ffff999999",
      },
      {
        "                ",
        "ffffffffffffffff",
        "9999999999999999",
      },
    },
}

for i = 0, 15 do
    tHex[2^i] = ("%x"):format(i)
    tHex[("%x"):format(i)] = 2^i
end

local fileName = ""
local undo = {}
local redo = {}
local historyLimit = 10 -- Undo/redo history limit

local function callUndo()
    if(#undo>0)then
        local cmd = table.remove(undo, #undo)
        local curFrame = imageElement:getFrame(cmd.frame)
        local oldFrame = deepCopy(curFrame)
        imageElement:updateFrame(cmd.frame, cmd.img)
        cmd.img = oldFrame
        table.insert(redo, cmd)
        if(#redo>historyLimit)then
            table.remove(redo, 1)
        end
    end
end

local function callRedo()
    if(#redo>0)then
        local cmd = table.remove(redo, #redo)
        local curFrame = imageElement:getFrame(cmd.frame)
        local oldFrame = deepCopy(curFrame)
        imageElement:updateFrame(cmd.frame, cmd.img)
        cmd.img = oldFrame
        table.insert(undo, cmd)
        if(#undo>historyLimit)then
            table.remove(redo, 1)
        end
    end
end

local function getChildrenHeight(container)
    local height = 0
    for _, child in ipairs(container:getChildren()) do
        if(child.get("visible"))then
            local newHeight = child.get("y") + child.get("height")
            if newHeight > height then
                height = newHeight
            end
        end
    end
    return height
end

local function getChildrenWidth(container)
    local width = 0
    for _, child in ipairs(container:getChildren()) do
        if(child.get("visible"))then
            local newWidth = child.get("x") + child.get("width")
            if newWidth > width then
                width = newWidth
            end
        end
    end
    return width
end

local function resizeImage(bimg, newWidth, newHeight)
    local oldWidth = bimg.width or #bimg[1][1][1]
    local oldHeight = bimg.height or #bimg[1]

    local xRatio = oldWidth / newWidth
    local yRatio = oldHeight / newHeight

    local newBimg = {}

    for frameNum, frame in ipairs(bimg) do
        newBimg[frameNum] = {}

        for y = 1, newHeight do
            local srcY = math.floor(y * yRatio)
            srcY = math.min(srcY, oldHeight)

            local newText = {}
            local newFg = {}
            local newBg = {}

            for x = 1, newWidth do
                local srcX = math.floor(x * xRatio)
                srcX = math.min(srcX, oldWidth)

                local text = frame[srcY] and frame[srcY][1]:sub(srcX, srcX) or " "
                local fg = frame[srcY] and frame[srcY][2]:sub(srcX, srcX) or "f"
                local bg = frame[srcY] and frame[srcY][3]:sub(srcX, srcX) or "0"

                table.insert(newText, text)
                table.insert(newFg, fg)
                table.insert(newBg, bg)
            end

            newBimg[frameNum][y] = {
                table.concat(newText),
                table.concat(newFg),
                table.concat(newBg)
            }
        end
    end

    return newBimg
end

local pressedKeys = {}
local main = basalt.getMainFrame():setBackground(colors.black)

local function sendMessage(msg)
    local frame = main:addFrame({background=colors.cyan, width="{parent.width-2}", height=1, x=2, y="{parent.height}"})
    frame:addLabel({text=msg, foreground=colors.white, x=2, y=1})
    basalt.schedule(function()
        sleep(2)
        frame:destroy()
    end)
end

local function createTopBarLine(parent, y)
    return parent:addLabel({text=("\140"):rep(parent.width-2), height=1, x=2, y=y})
end

--- Topbar:
local topbar = main:addFrame({background=colors.cyan, width="{parent.width}", height=1})
local yOffset = topbar:addLabel({name="xoffset", text="Y: 0", foreground=colors.black, x="{parent.width - #self.text}", y=1})
local xOffset = topbar:addLabel({text="X: 0", foreground=colors.black, x="{parent.width - #xoffset.text - #self.text - 1}", y=1})

local fileMenu = main:addFrame({background=colors.cyan, width=14, height=9, x=1, y=2, z=12, visible=false})
:onBlur(function(self)
    self:setVisible(false)
end)
topbar:addButton({text="File", width=6, height=1, x=1, y=1, background=colors.cyan, foreground=colors.black})
:onClick(function(self)
    fileMenu:setVisible(not fileMenu.visible)
end):onClickUp(function(self)
    if(fileMenu.visible)then
        fileMenu:setFocused(true)
    end
end)

local newFileFrame = main:addFrame({background=colors.cyan, width=16, height=5, x=centerPosition, y=3, z=12, visible=false})
:onBlur(function(self)
    self:setVisible(false)
end)
local fileNameNewInput = newFileFrame:addInput({background=colors.black, foreground=colors.white, width="{parent.width-2}", x=2, y=2})
newFileFrame:addButton({text="Create", width="{parent.width-2}", height=1, x=2, y=4, background=colors.black, foreground=colors.white})
:onClick(function(self)
    local fName =  fileNameNewInput:getText()
    if(fName=="")then
        fName = "new.bimg"
    else
        fName = fName:gsub(".bimg", "")..".bimg"
    end
    if(fs.exists(fName))then
        sendMessage("File "..fName.." already exists!")
        newFileFrame:setVisible(false)
        return
    end
    fileName = fName
    imageElement:setBimg({
        [1] = {},
        animated = false,
        width = 20,
        height = 5,
    })
    imageElement:resizeImage(20, 5)
    newFileFrame:setVisible(false)
    undo = {}
    redo = {}
end)

fileMenu:addLabel({text="New", autoSize=false, width="{parent.width-2}", x=2, y=2, background=menuButtonBg, foreground=colors.white})
:onClick(function(self)
    newFileFrame:setVisible(true)
end):onClickUp(function(self)
    if(newFileFrame.visible)then
        newFileFrame:setFocused(true)
    end
end)

local openFileFrame = main:addFrame({background=colors.cyan, width=16, height=5, x=centerPosition, y=3, z=12, visible=false})
:onBlur(function(self)
    self:setVisible(false)
end)

local fileNameOpenInput = openFileFrame:addInput({background=colors.black, foreground=colors.white, width="{parent.width-2}", x=2, y=2})
openFileFrame:addButton({text="Open", autoSize=false, width="{parent.width-2}", height=1, x=2, y=4, background=colors.black, foreground=colors.white})
:onClick(function(self)
    imageElement:setCurrentFrame(1)
    local fName =  fileNameOpenInput:getText():gsub(".bimg", "")..".bimg"
    local file = fs.open(fName, "r")
    if file then
        fileName = fName
        local data = textutils.unserialize(file.readAll())
        imageElement:setBimg(data)
        file.close()
        sendMessage("Successfuly loaded "..fName)
        undo = {}
        redo = {}
    else
        sendMessage("File not found!")
    end
    openFileFrame:setVisible(false)
end)

fileMenu:addLabel({text="Open", autoSize=false, width="{parent.width-2}", x=2, y=3, background=menuButtonBg, foreground=colors.white})
:onClick(function(self)
    fileNameOpenInput:setText("")
    openFileFrame:setVisible(true)
end):onClickUp(function(self)
    if(openFileFrame.visible)then
        openFileFrame:setFocused(true)
    end
end)
createTopBarLine(fileMenu, 4)

local saveAsFrame = main:addFrame({background=colors.cyan, width=16, height=5, x=centerPosition, y=3, z=12, visible=false})
:onBlur(function(self)
    self:setVisible(false)
end)
local fileNameSaveInput = saveAsFrame:addInput({background=colors.black, foreground=colors.white, width="{parent.width-2}", x=2, y=2})
saveAsFrame:addButton({text="Save", width="{parent.width-2}", height=1, x=2, y=4, background=colors.black, foreground=colors.white})
:onClick(function(self)
    local fName =  fileNameSaveInput:getText():gsub(".bimg", "")..".bimg"
    local file = fs.open(fName, "w")
    if file then
        fileName = fName
        file.write(textutils.serialize(imageElement:getBimg()))
        file.close()
        sendMessage("Successfuly saved as "..fName)
    else
        sendMessage("File not found!")
    end
    saveAsFrame:setVisible(false)
end)

fileMenu:addLabel({text="Save", autoSize=false, width="{parent.width-2}", x=2, y=5, background=menuButtonBg, foreground=colors.white})
:onClick(function(self)
    if(fileName~="")then
        local file = fs.open(fileName, "w")
        if file then
            file.write(textutils.serialize(imageElement:getBimg()))
            file.close()
            sendMessage("Successfuly saved as "..fileName)
        else
            sendMessage("File not found!")
        end
    else
        saveAsFrame:setVisible(true)
    end
    fileMenu:setVisible(false)
end):onClickUp(function(self)
    if(saveAsFrame.visible)then
        saveAsFrame:setFocused(true)
    end
end)

fileMenu:addLabel({text="Save As", autoSize=false, width="{parent.width-2}", height=1, x=2, y=6, background=menuButtonBg, foreground=colors.white})
:onClick(function(self)
    fileNameSaveInput:setText(fileName)
    saveAsFrame:setVisible(true)
end):onClickUp(function(self)
    if(saveAsFrame.visible)then
        saveAsFrame:setFocused(true)
    end
end)
createTopBarLine(fileMenu, 7)

fileMenu:addLabel({text="Exit", autoSize=false, width="{parent.width-2}", x=2, y=8, background=menuButtonBg, foreground=colors.white})
:onClick(function(self)
    basalt.stop()
end)

--- EDIT WINDOW:
local editMenu = main:addFrame({background=colors.cyan, width=14, height=10, x=6, y=2, z=12, visible=false})
:onBlur(function(self)
    self:setVisible(false)
end)
topbar:addButton({text="Edit", width=6, height=1, x=7, y=1, background=colors.cyan, foreground=colors.black})
:onClick(function(self)
    editMenu:setVisible(not editMenu.visible)
end):onClickUp(function(self)
    if(editMenu.visible)then
        editMenu:setFocused(true)
    end
end)

editMenu:addLabel({text="Undo", autoSize=false, width="{parent.width-2}", x=2, y=2, background=menuButtonBg, foreground=colors.white})
:onClick(function(self)
    callUndo()
end):onClickUp(function(self)
    if(imageElement.visible)then
        imageElement:setFocused(true)
    end
end)

editMenu:addLabel({text="Redo", autoSize=false, width="{parent.width-2}", x=2, y=3, background=menuButtonBg, foreground=colors.white})
:onClick(function(self)
    callRedo()
end):onClickUp(function(self)
    if(imageElement.visible)then
        imageElement:setFocused(true)
    end
end)
createTopBarLine(editMenu, 4)

editMenu:addLabel({text="Clear", autoSize=false, width="{parent.width-2}", x=2, y=5, background=menuButtonBg, foreground=colors.white})
:onClick(function(self)
    local img = imageElement:getBimg()[imageElement.get("currentFrame")]
    table.insert(undo, {frame=imageElement.get("currentFrame"), img=deepCopy(img)})
    local imgWidth, imgHeight = imageElement:getImageSize()
    local textLine = (" "):rep(imgWidth)
    local bgLine = tHex[colors.white]:rep(imgWidth)
    local fgLine = tHex[colors.black]:rep(imgWidth)
    for i,v in ipairs(img) do
        v[1] = textLine
        v[2] = fgLine
        v[3] = bgLine
    end
end):onClickUp(function(self)
    if(imageElement.visible)then
        imageElement:setFocused(true)
    end
end)

local resizeFrame = main:addFrame({background=colors.cyan, width=16, height=7, x=centerPosition, y=3, z=12, visible=false})
:onBlur(function(self)
    self:setVisible(false)
end)
local widthInput = resizeFrame:addInput({background=colors.black, foreground=colors.white, width="{parent.width-2}", x=2, y=2})
local heightInput = resizeFrame:addInput({background=colors.black, foreground=colors.white, width="{parent.width-2}", x=2, y=4})
resizeFrame:addButton({text="Resize", width="{parent.width-2}", height=1, x=2, y=6, background=colors.black, foreground=colors.white})
:onClick(function(self)
    local width = tonumber(widthInput:getText())
    local height = tonumber(heightInput:getText())
    if(width and height)then
        imageElement:resizeImage(width, height)
        resizeFrame:setVisible(false)
        undo = {}
        redo = {}
    end
end)

editMenu:addLabel({text="Resize", autoSize=false, width="{parent.width-2}", x=2, y=6, background=menuButtonBg, foreground=colors.white})
:onClick(function(self)
    local imgWidth, imgHeight = imageElement:getImageSize()
    widthInput:setText(tostring(imgWidth))
    heightInput:setText(tostring(imgHeight))
    resizeFrame:setVisible(true)
end):onClickUp(function(self)
    if(resizeFrame.visible)then
        resizeFrame:setFocused(true)
    end
end)
createTopBarLine(editMenu, 7)

local paletteFrame  = main:addFrame({background=colors.cyan, width=16, height=11, x=centerPosition, y=3, z=12, visible=false})
:onBlur(function(self)
    self:setVisible(false)
end)
:onScroll(function(self, delta)
    local offset = math.max(0, math.min(self.get("offsetY") + delta, getChildrenHeight(self) - self.get("height")))
    self:setOffsetY(offset)
end)

local paletteList = paletteFrame:addList({background=colors.black, width="{parent.width-2}", height="{parent.height-5}", x=2, y=2})
local paletteInput = paletteFrame:addInput({background=colors.black, foreground=colors.white, width="{parent.width-4}", x=2, y="{parent.height-1}"})

local modifyPalette = {}
local yPos = 2
for k,v in pairs(colors)do
    if(type(k)=="string")and(type(v)=="number")then
        if(k=="black")then
            paletteList:addItem({text=k, background=colors.white, foreground=v, value=v, valueName=k})
        else
            paletteList:addItem({text=k, foreground=v, value=v, valueName=k})
        end
        yPos = yPos + 2
    end
end

paletteList:onSelect(function(self, index, item)
    if(modifyPalette)then
        local index = math.log(colors[item.valueName], 2)
        if(modifyPalette[index])then
            paletteInput:setText(string.format("%x", modifyPalette[index]))
        else
            paletteInput:setText("")
        end
    end
end)

paletteFrame:addLabel({text="Color:", foreground=colors.white, x=2, y="{parent.height-2}"})
paletteInput:onChange("text", function(self, text)
    if(modifyPalette)then
        text = text:gsub("^0x", "")
        local color = tonumber(text, 16)
        if(color)then
            local selectedItem = paletteList:getSelectedItem()
            if(selectedItem~=nil)then
                local index = math.log(colors[selectedItem.valueName], 2)
                if(colors[selectedItem.valueName]~=color)then
                    modifyPalette[index] = color
                else
                    modifyPalette[index] = nil
                end
            end
        end
    end
end)

local metadataFrame = main:addFrame({background=colors.cyan, width=21, height=12, x=centerPosition, y=3, z=12, visible=false})
:onBlur(function(self)
    self:setVisible(false)
end)
:onScroll(function(self, delta)
    local offset = math.max(0, math.min(self.get("offsetY") + delta, getChildrenHeight(self) - self.get("height")))
    self:setOffsetY(offset)
end)

local mData = {}
metadataFrame:addLabel({text="Title:", foreground=colors.white, x=2, y=2})
mData.title = metadataFrame:addInput({background=colors.black, foreground=colors.white, width="{parent.width-2}", x=2, y=3})
:onChange("text", function(self, text)
    local bimg = imageElement.get("bimg")
    bimg.title = text
end)

metadataFrame:addLabel({text="Author:", foreground=colors.white, x=2, y=5})
mData.author = metadataFrame:addInput({background=colors.black, foreground=colors.white, width="{parent.width-2}", x=2, y=6})
:onChange("text", function(self, text)
    local bimg = imageElement.get("bimg")
    bimg.author = text
end)

metadataFrame:addLabel({text="Description:", foreground=colors.white, x=2, y=8})
mData.description = metadataFrame:addInput({background=colors.black, foreground=colors.white, width="{parent.width-2}", x=2, y=9})
:onChange("text", function(self, text)
    local bimg = imageElement.get("bimg")
    bimg.description = text
end)

metadataFrame:addLabel({text="Creator:", foreground=colors.white, x=2, y=11})
mData.creator = metadataFrame:addInput({text="Basalt Image Editor", background=colors.black, foreground=colors.white, width="{parent.width-2}", x=2, y=12})
:onChange("text", function(self, text)
    local bimg = imageElement.get("bimg")
    bimg.creator = text
end)

metadataFrame:addLabel({text="Version:", foreground=colors.white, x=2, y=14})
mData.version = metadataFrame:addInput({text="1.0.0", background=colors.black, foreground=colors.white, width="{parent.width-2}", x=2, y=15})
:onChange("text", function(self, text)
    local bimg = imageElement.get("bimg")
    bimg.version = text
end)

mData.animated = metadataFrame:addCheckbox({background=colors.cyan, text="[ ] Animated", checkedText="[x] Animated", foreground=colors.white, width="{parent.width-2}", x=2, y=17})
:onChange("checked", function(self, checked)
    local bimg = imageElement.get("bimg")
    bimg.animated = checked
end)

metadataFrame:addLabel({text="Seconds per frame:", foreground=colors.white, x=2, y=19})
mData.secondsPerFrame = metadataFrame:addInput({background=colors.black, foreground=colors.white, width="{parent.width-2}", x=2, y=20})
:onChange("text", function(self, text)
    local bimg = imageElement.get("bimg")
    bimg.secondsPerFrame = tonumber(text)
end)
mData.secondsPerFrame:setPattern("[%d%.]")

metadataFrame:addButton({text="Palette", width="{parent.width-2}", height=1, x=2, y=22, background=colors.black, foreground=colors.white})
:onClick(function(self)
    local bimg = imageElement.get("bimg")
    if(bimg.palette==nil)then
        bimg.palette = {}
    end
    modifyPalette = bimg.palette
    paletteFrame:setVisible(true)
    paletteInput:setText("")
end):onClickUp(function(self)
    if(paletteFrame.visible)then
        paletteFrame:setFocused(true)
    end
end)

editMenu:addLabel({text="Metadata", autoSize=false, width="{parent.width-2}", x=2, y=8, background=menuButtonBg, foreground=colors.white})
:onClick(function(self)
    local bimg = imageElement.get("bimg")
    for k,v in pairs(bimg) do
        if(mData[k])then
            mData[k]:setText(tostring(v))
        end
    end
    metadataFrame:setVisible(true)
end):onClickUp(function(self)
    if(metadataFrame.visible)then
        metadataFrame:setFocused(true)
    end
end)

local framesMenu
local selFrame = -1
local selectedFrame = main:addFrame({background=colors.cyan, width=16, height=9, x=centerPosition, y=3, z=14, visible=false})
:onBlur(function(self)
    self:setVisible(false)
end)
selectedFrame:addLabel({text="Delete", width="{parent.width-2}", x=2, y=2, background=colors.black, foreground=colors.white})
:onClick(function(self)
    local bimg = imageElement:getBimg()
    if(#bimg>1)then
        table.remove(bimg, selFrame)
    else
        sendMessage("Cannot delete the last frame!")
    end
    if(selFrame>1)then
        imageElement:setCurrentFrame(selFrame-1)
    end
    selectedFrame:setVisible(false)
    framesMenu:setVisible(false)
end)
selectedFrame:addLabel({text="Copy", width="{parent.width-2}", x=2, y=3, background=colors.black, foreground=colors.white})
:onClick(function(self)
    local bimg = imageElement:getBimg()
    local img = deepCopy(bimg[selFrame])
    table.insert(bimg, img)
    selectedFrame:setVisible(false)
    framesMenu:setVisible(false)
end)
createTopBarLine(selectedFrame, 4)
selectedFrame:addLabel({text="Move Left", width="{parent.width-2}", x=2, y=5, background=colors.black, foreground=colors.white})
:onClick(function(self)
    local bimg = imageElement:getBimg()
    local img = bimg[selFrame]
    if(selFrame>1)then
        table.remove(bimg, selFrame)
        table.insert(bimg, selFrame-1, img)
    end
    selectedFrame:setVisible(false)
    framesMenu:setVisible(false)
end)
selectedFrame:addLabel({text="Move Right", width="{parent.width-2}", x=2, y=6, background=colors.black, foreground=colors.white})
:onClick(function(self)
    local bimg = imageElement:getBimg()
    local img = bimg[selFrame]
    if(selFrame<#bimg)then
        table.remove(bimg, selFrame)
        table.insert(bimg, selFrame+1, img)
    end
    selectedFrame:setVisible(false)
    framesMenu:setVisible(false)
end)
createTopBarLine(selectedFrame, 7)
selectedFrame:addLabel({text="Palette", width="{parent.width-2}", x=2, y=8, background=colors.black, foreground=colors.white})
:onClick(function(self)
    local bimg = imageElement:getBimg()
    if(bimg[selFrame].palette==nil)then
        bimg[selFrame].palette = {}
    end
    modifyPalette = bimg[selFrame].palette
    paletteFrame:setVisible(true)
    paletteInput:setText("")
end):onClickUp(function(self)
    if(paletteFrame.visible)then
        paletteFrame:setFocused(true)
    end
    framesMenu:setVisible(false)
end)

framesMenu = main:addFrame({background=colors.cyan, width=30, height=11, x=centerPosition, y=3, z=12, visible=false})
:onBlur(function(self)
    if(not selectedFrame.visible)then
        self:setVisible(false)
    end
end)
:onScroll(function(self, delta)
    local offset = math.max(0, math.min(self.get("offsetX") + delta, getChildrenWidth(self) - self.get("width")))
    self:setOffsetX(offset)
end)

local frameImages = {}
local framePlusImage = framesMenu:addImage({width = 16, height=9, background=colors.white}):setBimg(plusImg)
:onClick(function(self, button, x, y)
    local img = imageElement:getBimg()
    imageElement:addFrame()
    imageElement:setCurrentFrame(#img)
    framesMenu:setVisible(false)
end)

local function makeImagesInvisible()
    for k, v in ipairs(frameImages)do
        v:setVisible(false)
    end
end

editMenu:addLabel({text="Frames", autoSize=false, width="{parent.width-2}", x=2, y=9, background=menuButtonBg, foreground=colors.white})
:onClick(function(self)
    local bimg = resizeImage(imageElement:getBimg(), 16, 9)
    local imageCount = 0
    framesMenu:setOffsetX(0)
    makeImagesInvisible()
    for k, v in ipairs(bimg)do
        local img = {v}
        if(frameImages[k]==nil)then
            frameImages[k] = framesMenu:addImage({width=16, height=9, background=colors.white})
            :onClick(function(self, button, x, y)
                if(button==1)then
                    imageElement:setCurrentFrame(k)
                    framesMenu:setVisible(false)
                elseif(button==2)then
                    selFrame = k
                    framesMenu:setFocused(true)
                    selectedFrame:setVisible(true)
                    local newX, newY = self:getAbsolutePosition(x, y)
                    local xOffset = framesMenu:getOffsetX()
                    selectedFrame:setPosition(newX - xOffset, newY)
                end
            end)
            :onClickUp(function(self, button, x, y)
                if(button==2)then
                    selectedFrame:setFocused(true)
                end
            end)
        end
        frameImages[k]:setVisible(true)
        frameImages[k]:setBimg(img)
        frameImages[k]:setPosition(18 * (k-1) + 2, 2)
        imageCount = imageCount + 1
    end
    framePlusImage:setPosition(18 * ((imageCount+1)-1) + 2, 2)
    editMenu:setVisible(false)
    framesMenu:setVisible(true)
end):onClickUp(function(self)
    if(framesMenu.visible)then
        framesMenu:setFocused(true)
    end
end)

--- Tools:
local tools = main:addFrame({background=colors.cyan, x=main.width-12, y=2, width=13, height=15})
:setDraggable(true)
:onScroll(function(self, delta)
    local offset = math.max(0, math.min(self.get("offsetY") + delta, getChildrenHeight(self) - self.get("height")))
    self:setOffsetY(offset)
end)

tools:addVisualElement({background=colors.black, width="{parent.width-2}", x=2, y=2})
tools:addLabel({text="Tools", foreground=colors.cyan, x="{math.ceil(parent.width/2)-math.floor(self.width/2)}", y=2})

local textInput = tools:addInput({background=colors.black, foreground=colors.white, width="{parent.width-2}", x=2, y=13})

-- Character Selection
local charFrame = tools:addFrame({width=11, x=2, y=15, background=colors.black})
:onScroll(function(self, delta)
    local offset = math.max(0, math.min(self.get("offsetY") + delta, getChildrenHeight(self) - self.get("height")))
    self:setOffsetY(offset)
end)

for i = 1, 255 do
    local char = string.char(i)
    local col = ((i-1) % 12) + 1
    local row = math.floor((i-1) / 12) + 1

    charFrame:addButton({
        x = (col-1),
        y = row,
        width = 1,
        height = 1,
        text = char,
        background = colors.black,
        foreground = colors.white
    }):onClick(function(self, button)
        if(button == 1)then
            textInput:setText(char)
        else
            local text = textInput:getText()
            textInput:setText(text..char)
        end
    end)
end

-- Mode Buttons
local textMode = true
local bgMode = false
local fgMode = false

local textButton = tools:addButton({text="[Text]", width=8, height=1, x=3, y=4, background="{self.clicked and colors.white or colors.cyan}"})
local bgButton = tools:addButton({text="BG", width=8, height=1, x=3, y=5, background="{self.clicked and colors.white or colors.cyan}"})
local fgButton = tools:addButton({text="FG", width=8, height=1, x=3, y=6, background="{self.clicked and colors.white or colors.cyan}"})

textButton:onClick(function()
    textMode = not textMode
    if(textMode)then
        textButton:setText("[Text]")
    else
        textButton:setText("Text")
    end
end)

bgButton:onClick(function()
    bgMode = not bgMode
    if(bgMode)then
        bgButton:setText("[ BG ]")
    else
        bgButton:setText("BG")
    end
end)

fgButton:onClick(function()
    fgMode = not fgMode
    if(fgMode)then
        fgButton:setText("[ FG ]")
    else
        fgButton:setText("FG")
    end
end)

local selectedColors = {
    colors.white,  -- Left click
    nil,           -- Right click
    nil,           -- Middle click
    nil,           -- Button 4
    nil            -- Button 5
}
local selectedButtons = {}

local colorList = {
    {colors.white, colors.lightGray, colors.gray, colors.black},
    {colors.red, colors.orange, colors.yellow, colors.lime},
    {colors.green, colors.cyan, colors.lightBlue, colors.blue},
    {colors.purple, colors.magenta, colors.pink, colors.brown}
}

-- Color Grid
for row = 1, 4 do
    for col = 1, 4 do
        local color = colorList[row][col]
        local btn = tools:addButton({
            x = col * 2 + 1,
            y = row + 7,
            width = 2,
            height = 1,
            background = color,
            text = ""
        }):onClick(function(self, button)
            if button <= 5 then
                if selectedButtons[button] then
                    selectedButtons[button]:setText("")
                end
                selectedButtons[button] = self
                selectedColors[button] = color
                self:setText(tostring(button))
            end
        end)
        if(color == colors.black)or(color == colors.gray)then
            btn:setForeground(colors.white)
        end

        if color == selectedColors[1] then
            selectedButtons[1] = btn
            btn:setText("1")
        end
    end
end

--- Image:
imageElement = main:addImage({background=colors.black, width="{parent.width}", height="{parent.height-1}", y=2})
local VisualElementRender = basalt.getElementClass("VisualElement").render
local ImageRender = basalt.getElementClass("Image").render
imageElement.render = function(self)
    VisualElementRender(self)
    local width = self.get("width")
    local height = self.get("height")
    local bgSymbol = ("\127"):rep(width)
    for i=1,height do
        self:textFg(1, i, bgSymbol, colors.gray)
    end

    local frame = self.get("bimg")[self.get("currentFrame")]
    if not frame then return end

    local offsetX = self.get("offsetX")
    local offsetY = self.get("offsetY")
    local elementWidth = self.get("width")
    local elementHeight = self.get("height")

    for y = 1, elementHeight do
        local frameY = y + offsetY
        local line = frame[frameY]

        if line then
            local text = line[1]
            local fg = line[2]
            local bg = line[3]

            if text and fg and bg then
                local remainingWidth = elementWidth - math.max(0, offsetX)
                if remainingWidth > 0 then
                    if offsetX < 0 then
                        local startPos = math.abs(offsetX) + 1
                        text = text:sub(startPos)
                        fg = fg:sub(startPos)
                        bg = bg:sub(startPos)
                    end

                    text = text:sub(1, remainingWidth)
                    fg = fg:sub(1, remainingWidth)
                    bg = bg:sub(1, remainingWidth)

                    self:blit(math.max(1, 1 + offsetX), y, text, fg, bg)
                end
            end
        end
    end
end
imageElement:resizeImage(20, 5)


local dragStartX, dragStartY
local startOffsetX, startOffsetY

local function imageSetTool(self, button, x, y)
    if button <= 5 and selectedColors[button] then
        if(not pressedKeys.leftShift)then
            redo = {}
            local xOf, yOf = self:getOffset()
            local text = textInput:getText()
            local width = 1
            if text=="" then
                text = " "
            end
            if textMode then
                self:setText(x - xOf, y + yOf, text)
                width = #text
            end
            if bgMode then
                local bg = tHex[selectedColors[button]]:rep(width)
                self:setBg(x - xOf, y + yOf, bg)
            end
            if fgMode then
                if(bgMode)then
                    button = button + 1
                    while button <= 5 and not selectedColors[button] do
                        button = button + 1
                        if(button > 5)then
                            button = 1
                        end
                    end
                end
                local fg = tHex[selectedColors[button]]:rep(width)
                self:setFg(x - xOf, y + yOf, fg)
            end
        else
            startOffsetX, startOffsetY = self:getOffset()
        end
    end
end

local cmd = {}

imageElement:onClick(function(self, button, x ,y)
    if (not pressedKeys.leftShift) then
        cmd = {frame=imageElement.get("currentFrame")}
        cmd.img = deepCopy(self.get("bimg")[imageElement.get("currentFrame")])
    end
    dragStartX, dragStartY = x, y
    startOffsetX, startOffsetY = self:getOffset()
    imageSetTool(self, button, x ,y)
end)

imageElement:onDrag(function(self, button, x, y)
    if(pressedKeys.leftShift)then
        local deltaX = dragStartX - x
        local deltaY = dragStartY - y

        xOffset:setText("X: "..-(startOffsetX - deltaX))
        if((startOffsetX - deltaX)==0)then
            xOffset:setText("X: 0")
        end
        yOffset:setText("Y: "..(startOffsetY + deltaY))
        self:setOffset(startOffsetX - deltaX, startOffsetY + deltaY)
    else
        imageSetTool(self, button, x, y)
    end
end)

imageElement:onClickUp(function(self, button, x, y)
    if(pressedKeys.leftShift)then
        dragStartX, dragStartY = nil, nil
    else
        if(cmd~=nil)then
            table.insert(undo, cmd)
            if(#undo > historyLimit)then
                table.remove(undo, 1)
            end
        end
        cmd = nil
    end
end)

main:onKey(function(self, key)
    pressedKeys[keys.getName(key)] = true
    if(pressedKeys.leftCtrl)then
        if(keys.getName(key)=="z")then
            callUndo()
        end
        if(keys.getName(key)=="y")then
           callRedo()
        end
        if(keys.getName(key)=="s")then
            if(fileName~="")then
                local file = fs.open(fileName, "w")
                if file then
                    file.write(textutils.serialize(imageElement:getBimg()))
                    file.close()
                    sendMessage("Successfuly saved as "..fileName)
                else
                    sendMessage("File not found!")
                end
            else
                saveAsFrame:setVisible(true)
            end
        end
    end

end):onKeyUp(function(self, key)
    pressedKeys[keys.getName(key)] = false
end)

basalt.run()