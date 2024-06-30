--[[
    Debug Class
    
    Author: Jen Berenguel
    tsjendoll@protonmail.com
]]

Debug = Class()

function Debug:init()
    self.variables = {}
    -- self:add("Toggle Debugging", string.upper(tostring(controller:getKey('debug'))), 'instruction', 1)
    -- self:add("Generate New Level", string.upper(tostring(controller:getKey('generateLevel'))), 'instruction', 2) 
    -- self:add("Toggle Texture Outlines", string.upper(tostring(controller:getKey('toggleTextureOutlines'))), 'instruction', 3)
    -- self:add("Toggle Hitboxes", string.upper(tostring(controller:getKey('toggleHitboxes'))), 'instruction', 4)
    -- self:add("Toggle Show FPS Only", string.upper(tostring(controller:getKey('toggleFPSOnly'))), 'instruction', 5)
    -- self:add("Toggle Alertboxes", string.upper(tostring(controller:getKey('toggleAlertboxes'))), 'instruction', 6)
    -- self:add("Spawn Enemy", string.upper(tostring(controller:getKey('spawnEnemy'))), 'instruction', 7)
end

function Debug:add(name, variable, type, order)
    -- type must be permanent, instruction, or toggle
    self.variables[name] = {variable, type, order}
end

function Debug:draw()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0) -- Yellow color (RGB normalized to 1)
    if not debugDungeonOn then
        local y = 20

        -- Sort instructions by their order of insertion
        local orderedInstructions = {}
        for name, value in pairs(self.variables) do
            if value[2] == 'instruction' then
                orderedInstructions[value[3]] = {name, value[1]}
            end
        end

        -- Print instructions in the order they were added
        for i, instruction in ipairs(orderedInstructions) do
            love.graphics.print(instruction[1] .. ": " .. tostring(instruction[2]), VIRTUAL_WIDTH - 120, y)
            y = y + 10
        end
        y = 30
        
        -- Print other types of variables
        local otherVariables
        if FPSOnly then
            otherVariables = {'permanent'}
        else
            otherVariables = {'permanent', 'toggle'}
        end
        for _, type in ipairs(otherVariables) do
            for name, value in pairs(self.variables) do
                if value[2] == type then
                    love.graphics.print(name .. ": " .. tostring(value[1]), 10, y)
                    y = y + 10
                end
            end
        end
    end
    love.graphics.setColor(1, 1, 1) -- Reset color to white
end

