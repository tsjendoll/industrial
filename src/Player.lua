--[[
    Player Class
    
    Author: Jen Berenguel
    tsjendoll@protonmail.com
]]
Player = Class{__includes = Entity}

--[[
    Player:init(def)
    Initializes the Player class by inheriting from the Entity class.

    Parameters:
        - def (table): The player definition containing properties such as position, dimensions, texture, etc.

    Returns:
        - None
]]
function Player:init(def)
    Entity.init(self, def)
end

--[[
    Player:update(dt)
    Updates the player by calling the update method of the Entity class.

    Parameters:
        - dt (number): The time since the last frame.

    Returns:
        - None
]]
function Player:update(dt)
    Entity.update(self, dt) 
end

--[[
    Player:render()
    Renders the player by calling the render method of the Entity class and optionally rendering hitboxes.

    Parameters:
        - None

    Returns:
        - None
]]
function Player:render()
    Entity.render(self)
    if debugOn then
        self:renderHitbox()
    end
end

--[[
    Player:renderHitbox()
    Renders the hitboxes for the player.

    Parameters:
        - None

    Returns:
        - None
]]
function Player:renderHitbox()
    if textureOutlinesOn then
        love.graphics.setColor(1, 1, 0, 1) -- Set color to yellow (RGBA)
        love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
        love.graphics.setColor(1, 1, 1, 1) -- Reset color to white (default)
    end

    if hitboxesOn then
        love.graphics.setColor(1, 0, 0, 1) -- Set color to red (RGBA)
        love.graphics.rectangle('line', self.hitbox.x, self.hitbox.y, self.hitbox.width, self.hitbox.height)
        love.graphics.setColor(1, 1, 1, 1) -- Reset color to white (default)
    end
end