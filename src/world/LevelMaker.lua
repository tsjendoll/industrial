LevelMaker = Class{}

function LevelMaker:generateLevel(levelToGenerate)
    local tileMaps = {}
    for _, layer in pairs(levelData[levelToGenerate]['layers']) do
        local data = layer['data']
        local texture = layer['texture']


        local tiles = {}
        local tileMapHeight = #data
        local tileMapWidth = #data[1]
    
        for y = 1, tileMapHeight do
            table.insert(tiles, {})
            for x = 1, tileMapWidth do
                local id = data[y][x] + 1
                LevelMaker:insertTile(x, y, id, tiles, texture)
            end     
        end
    
        local tileMap = TileMap(width, height)
        tileMap.tiles = tiles
        table.insert(tileMaps, tileMap)

    end
    
    return GameLevel(nil, nil, tileMaps)
end

function LevelMaker:insertTile(x, y, id, tiles, texture)
    if not tiles[y][x] then 
        table.insert(tiles[y], Tile(x, y, id, texture))
    else
        tiles[y][x] = Tile(x, y , id, texture)
    end
end

