--[[
    Controller Class
    
    Author: Jen Berenguel
    tsjendoll@protonmail.com
]]
Controller = Class()

-- Constructor for creating a new controller
function Controller:init()
    self.controls = {
        ['left'] = 'left', 
        ['right'] = 'right',
        ['up'] = 'up',
        ['down'] = 'down',
        ['jump'] = 'z',
        ['attack'] = 'x',
        ['sprint'] = 'lshift',
        ['debug'] = 'd',
        ['generateLevel'] = 'f1',
        ['toggleTextureOutlines'] = 'f2',
        ['toggleHitboxes'] = 'f3',
        ['toggleFPSOnly'] = 'f4',
        ['toggleAlertboxes'] = 'f5',
        ['spawnEnemy'] = 's',
        ['displayMap'] = 'm'
    }
end

-- Method to change a control
function Controller:changeControl(action, newKey)
    self.controls[action] = newKey
end

-- Method to save controls to a file
function Controller:saveControls()
    local controlData = love.filesystem.newFile("controls.txt", "w")
    for action, key in pairs(self.controls) do
        controlData:write(action .. "=" .. key .. "\n")
    end
    controlData:close()
end

-- Method to load controls from a file
function Controller:loadControls()
    if love.filesystem.getInfo("controls.txt") then
        for line in love.filesystem.lines("controls.txt") do
            local action, key = string.match(line, "(%w+)=(%w+)")
            if action and key then
                self.controls[action] = key
            end
        end
    end
end

-- Method to get the key mapped to an action
function Controller:getKey(action)
    return self.controls[action]
end