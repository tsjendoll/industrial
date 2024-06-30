--[[
    -- GameLevel Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameLevel = Class{}

function GameLevel:init(entities, objects, tileMap)
    self.entities = entities
    self.objects = objects
    self.tileMaps = tileMap
end

--[[
    Remove all nil references from tables in case they've set themselves to nil.
]]
function GameLevel:clear()
    if self.objects then
        for i = #self.objects, 1, -1 do
            if not self.objects[i] or self.objects[i].dead then
                table.remove(self.objects, i)
            end
        end
    end

    if self.entities then
        for i = #self.entities, 1, -1 do
            if not self.entities[i] then
                table.remove(self.entities, i)
            end
        end
    end
end

function GameLevel:update(dt)
    for _, tileMap in pairs(self.tileMaps) do
        tileMap:update(dt)
    end

    if self.objects then
        for k, object in pairs(self.objects) do
            object:update(dt)
        end
    end

    if self.entities then
        
        for k, entity in pairs(self.entities) do
            entity:update(dt)
        end
    end
end

function GameLevel:render()
    for _, tileMap in pairs(self.tileMaps) do
        tileMap:render()
    end
    
    if self.objects then
        for k, object in pairs(self.objects) do
            object:render()
        end
    end

    if self.entities then
        for k, entity in pairs(self.entities) do
            entity:render()
        end    
    end
end