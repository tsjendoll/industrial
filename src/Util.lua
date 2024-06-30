--[[
    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function import_csv_layout(path)
    local terrain_map = {}
    local file, err = love.filesystem.newFile(path, "r")

    if not file then
        print("Could not open file: " .. path)
        print("Error: " .. (err or "unknown error"))
        return nil
    end

    for line in file:lines() do
        local row = {}
        for value in string.gmatch(line, "([^,]+)") do
            local number = tonumber(value)
            if number then
                table.insert(row, number)
            else
                table.insert(row, value)
            end
        end
        table.insert(terrain_map, row)
    end

    file:close()
    return terrain_map
end

function importFolder(path)
    local sprites = {}
    local sheetCounter = 1
    
    -- Get a list of files in the directory
    local files = love.filesystem.getDirectoryItems(path)
    
    -- Sort files numerically
    table.sort(files, function(a, b)
        return tonumber(a:match("%d+")) < tonumber(b:match("%d+"))
    end)
    
    for _, file in ipairs(files) do
        if file:match("%.png$") then
            local imagePath = path .. "/" .. file
            local image = love.graphics.newImage(imagePath)
    
            -- Create a new quad
            sprites[sheetCounter] = image
            sheetCounter = sheetCounter + 1
        end
    end
    
    return sprites
    
end




