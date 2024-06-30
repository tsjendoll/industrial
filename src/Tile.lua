--[[
    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]
Tile = Class{}

alpha = 0

function Tile:init(x, y, id, texture)
    self.x = x
    self.y = y
    self.width = TILE_SIZE
    self.height = TILE_SIZE
    self.id = id
    self.texture = texture
end

--[[
    Checks to see whether this ID is whitelisted as collidable in a global constants table.
]]
function Tile:collidable(target)
    local collidableTiles = COLLIDABLE_TILES

    for k, v in pairs(collidableTiles) do
        if v == self.id then
            return true
        end
    end
    return false
end

function Tile:render()
    
    if self.id ~= 0 then
        love.graphics.draw(tilesets[self.texture][self.id],
                (self.x - 1) * TILE_SIZE, 
                (self.y - 1) * TILE_SIZE - tilesets[self.texture][self.id]:getHeight() + TILE_SIZE)
    end
end