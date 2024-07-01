--[[
    Author: Jen Berenguel
    tsjendoll@protonmail.com
]]
Entity = Class{}

--[[
    Entity:init(def)
    Initializes the Entity class.

    Parameters:
        - def (table): The entity definition containing properties such as position, dimensions, texture, etc.

    Returns:
        - None
]]
function Entity:init(def)
    -- position
    self.x = def.x
    self.y = def.y

    -- velocity
    self.dx = 0
    self.dy = 0

    -- dimensions
    self.width = def.width
    self.height = def.height

    self.texture = def.texture
    self.stateMachine = def.stateMachine

    self.direction = def.direction or 'left'

    -- reference to tile map so we can check collisions
    self.map = def.map

    -- reference to level for tests against other entities + objects
    self.level = def.level

    if def.hitbox then
        self.hitboxWidth = def.hitboxWidth
        self.hitboxHeight = def.hitboxHeight
        self.hitboxOffsetX = def.hitboxOffsetX
        self.hitboxOffsetY = def.hitboxOffsetY
        self.hitbox = def.hitbox
    end

    self.alertHitboxWidth = def.alertHitboxWidth or 120
    self.alertHitboxHeight = def.alertHitboxHeight or self.hitboxHeight
    self.alertHitboxOffsetX = def.alertHitboxOffsetX or (self.width / 2 - self.alertHitboxWidth / 2)
    self.alertHitboxOffsetY = def.alertHitboxOffsetY or self.hitboxOffsetY

    self.alertHitbox = Hitbox(self.x + self.alertHitboxOffsetX, self.y + self.alertHitboxOffsetY, self.alertHitboxWidth, self.alertHitboxHeight)
    
    self.maxHealth = def.maxHealth
    self.health = self.maxHealth
    -- flags for flashing the entity when hit
    self.inDungeon = def.inDungeon and def.inDungeon or false
    self.invulnerable = false
    -- default to .5 seconds if not specified
    self.invulnerableDuration = def.invulnerableDuration or .5
    self.invulnerableTimer = 0

    -- timer for turning transparency on and off, flashing
    self.flashTimer = 0
    self.flashInterval = 0.1 -- interval for flashing effect
    self.kill = false 
    self.killCounted = false

    -- timer that runs once to prevent false kills from entities loading on screen and falling off the map immediately 
    self.countForKill = false
    self.countForKillDuration = 3
    self.droppedPotion = false
end

--[[
    Entity:renderHitbox()
    Renders the hitboxes for the entity.

    Parameters:
        - None

    Returns:
        - None
]]
function Entity:renderHitbox()
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

    if alertboxesOn then
        love.graphics.setColor(0, 0, 1, 1) -- Set color to blue (RGBA) for alert hitbox
        love.graphics.rectangle('line', self.alertHitbox.x, self.alertHitbox.y, self.alertHitbox.width, self.alertHitbox.height)
        love.graphics.setColor(1, 1, 1, 1) -- Reset color to white (default)             
    end
end

--[[
    Entity:changeState(state, params)
    Changes the state of the entity.

    Parameters:
        - state (string): The new state to change to.
        - params (table): Parameters for the new state.

    Returns:
        - None
]]
function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

--[[
    Entity:processAI(params, dt)
    Process AI logic for the entity.

    Parameters:
        - params (table): Parameters for AI processing.
        - dt (number): The time since the last frame.

    Returns:
        - None
]]
function Entity:processAI(params, dt)
    self.stateMachine:processAI(params, dt)
end

--[[
    Entity:update(dt)
    Updates the entity.

    Parameters:
        - dt (number): The time since the last frame.

    Returns:
        - None
]]
function Entity:update(dt)
    if not self.countForKill then 
        self.countForKillDuration = self.countForKillDuration - dt

        if self.countForKillDuration <= 0 then
            self.countForKill = true
        end
    end

    self.hitbox = Hitbox(self.x + self.hitboxOffsetX, self.y + self.hitboxOffsetY, self.hitboxWidth, self.hitboxHeight)
    self.alertHitbox = Hitbox(self.x + self.alertHitboxOffsetX, self.y + self.alertHitboxOffsetY, self.alertHitboxWidth, self.alertHitboxHeight)

    self.stateMachine:update(dt)
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end

    -- Update invulnerability timer
    if self.invulnerable then
        self.invulnerableTimer = self.invulnerableTimer - dt
        self.flashTimer = self.flashTimer + dt

        if self.invulnerableTimer <= 0 then
            self.invulnerable = false
            self.flashTimer = 0
        end

        if self.flashTimer >= self.flashInterval then
            self.flashTimer = self.flashTimer - self.flashInterval
        end
    end
end

--[[
    Entity:damage(dmg)
    Inflicts damage to the entity.

    Parameters:
        - dmg (number): The amount of damage to inflict.

    Returns:
        - None
]]
function Entity:damage(dmg)
    if not self.invulnerable then
        self.health = math.max(0, math.min(self.maxHealth, self.health - dmg))

        self.invulnerable = true
        self.invulnerableTimer = self.invulnerableDuration
    end
end

--[[
    Entity:collides(entity)
    Checks if the entity collides with another entity.

    Parameters:
        - entity (Entity): The other entity to check collision with.

    Returns:
        - (boolean): True if the entities collide, false otherwise.
]]
function Entity:collides(entity)
    return not (self.hitbox.x > entity.x + entity.width or entity.x > self.hitbox.x + self.hitbox.width or
                self.hitbox.y > entity.y + entity.height or entity.y > self.hitbox.y + self.hitbox.height)
end

--[[
    Entity:render()
    Renders the entity.

    Parameters:
        - None

    Returns:
        - None
]]
function Entity:render()
    local alpha = 1
    if self.invulnerable then
        alpha = (self.flashTimer < self.flashInterval / 2) and 0.5 or 1
    end

    love.graphics.setColor(1, 1, 1, alpha)

    if self.currentAnimation.texture then
        if self.direction == 'right' then
            love.graphics.draw(gTextures[self.texture], gFrames[self.currentAnimation.texture][self.currentAnimation:getCurrentFrame()],
            math.floor(self.x) + 8 - 16, math.floor(self.y) + 10, 
            0, self.direction == 'right' and 1 or -1, 1, 8, 10)
        else
            love.graphics.draw(gTextures[self.texture], gFrames[self.currentAnimation.texture][self.currentAnimation:getCurrentFrame()],
            math.floor(self.x) + 8 + 16, math.floor(self.y) + 10, 
            0, self.direction == 'right' and 1 or -1, 1, 8, 10)
        end
    else
        -- if in the the dungeon then it must be a slime
        if self.inDungeon then
            if self.texture == 'slime' then
                love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()], 
                math.floor(self.x) + 8, math.floor(self.y) + 8, 0, self.direction == 'right' and 1 or -1, 1, 8, 8)
            else
                local halfWidth = self.width / 2
                local halfHeight = self.height / 2
                love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()], 
                math.floor(self.x) + halfWidth, math.floor(self.y) + halfHeight, 0, self.direction == 'right' and 1 or -1, 1, halfWidth, halfHeight)
            end
        else    
            local originX = self.texture == 'knight' and 8 or 24
            love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
            math.floor(self.x) + originX, math.floor(self.y) + 10, 0, self.direction == 'right' and 1 or -1, 1, originX, 10)
        end
    end 

    love.graphics.setColor(1, 1, 1, 1) -- Reset color to white with full opacity

    self.stateMachine:render()
    if debugOn then
        self:renderHitbox()
    end
end

local collision_padding = 3

--[[
    Entity:checkLeftCollisions(dt)
    Checks for collisions to the left of the entity.

    Parameters:
        - dt (number): The time since the last frame.

    Returns:
        - None
]]
function Entity:checkLeftCollisions(dt)
    local tileTopLeft = self.map:pointToTile(self.hitbox.x - 3, self.y + self.hitboxOffsetY + collision_padding)
    local tileBottomLeft = self.map:pointToTile(self.hitbox.x - 3, self.y + self.height - collision_padding)

    if (tileTopLeft and tileBottomLeft) and (tileTopLeft:collidable() or tileBottomLeft:collidable()) then
        self.x = (tileTopLeft.x - 1) * TILE_SIZE + tileTopLeft.width - self.hitboxOffsetX
        self.dx = 0
    else
        self.x = self.x
        local collidedObjects = self:checkObjectCollisions()
        self.x = self.x

        if #collidedObjects > 0 then
            self.x = collidedObjects[1].x + collidedObjects[1].width - self.hitboxOffsetX
        end
    end
end


--[[
    Entity:checkRightCollisions(dt)
    Checks for collisions to the right of the entity.

    Parameters:
        - dt (number): The time since the last frame.

    Returns:
        - None
]]
function Entity:checkRightCollisions(dt)
    local tileTopRight = self.map:pointToTile(self.hitbox.x + self.hitbox.width + 3, self.hitbox.y + collision_padding)
    local tileBottomRight = self.map:pointToTile(self.hitbox.x + self.hitbox.width + 3, self.hitbox.y + self.hitbox.height - collision_padding)

    if (tileTopRight and tileBottomRight) and (tileTopRight:collidable() or tileBottomRight:collidable()) then
        self.x = (tileTopRight.x - 1) * TILE_SIZE - self.hitboxWidth - self.hitboxOffsetX    
    else
        self.x = self.x - 1
        local collidedObjects = self:checkObjectCollisions()
        self.x = self.x + 1

        if #collidedObjects > 0 then
            self.x = collidedObjects[1].x - self.width - 1
            self.dx = 0
        end
    end
end

--[[
    Entity:checkUpCollisions(dt)
    Checks for collisions above the entity.

    Parameters:
        - dt (number): The time since the last frame.

    Returns:
        - None
]]
function Entity:checkUpCollisions(dt, isDungeon)
    local tileTopLeft = self.map:pointToTile(self.hitbox.x + collision_padding, self.hitbox.y)
    local tileTopRight = self.map:pointToTile(self.hitbox.x + self.hitbox.width - collision_padding, self.hitbox.y)
    
    
    if (tileTopLeft and tileTopRight) and (tileTopLeft:collidable() or tileTopRight:collidable()) then
        self.y = (tileTopLeft.y - 1) * TILE_SIZE + tileTopLeft.height - self.hitboxOffsetY
        self.dy = 1
        if isDungeon then
            self.y = self.y - 2
        
            self.dy = 0
        end
    else
        self.y = self.y
        local collidedObjects = self:checkObjectCollisions()
        self.y = self.y

        if #collidedObjects > 0 then
            self.y = collidedObjects[1].y + collidedObjects[1].height - self.hitboxOffsetY
            self.dy = 0
        end
        

    end
end

--[[
    Entity:checkDownCollisions(dt)
    Checks for collisions below the entity.

    Parameters:
        - dt (number): The time since the last frame.

    Returns:
        - None
]]
function Entity:checkDownCollisions(dt)
    local tileBottomLeft = self.map:pointToTile(self.x + 3, self.y + self.hitboxOffsetY + self.hitboxHeight + 1)
    local tileBottomRight = self.map:pointToTile(self.x + self.hitbox.width - 3, self.y + self.hitboxOffsetY + self.hitboxHeight+ 1)

    if (tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable()) then
        if self.texture == 'golem' then
            self.y = (tileBottomLeft.y - 1) * TILE_SIZE - (self.hitboxOffsetX + self.hitboxHeight)
        else
            self.y = (tileBottomLeft.y - 1) * TILE_SIZE - self.height
        end
        self.dy = 0
        print(self.height)
        print()
    else
        -- self.y = self.y - 1
        -- local collidedObjects = self:checkObjectCollisions()
        -- self.y = self.y + 1

        -- if #collidedObjects > 0 then
        --     self.y = collidedObjects[1].y + collidedObjects[1].height - self.hitboxOffsetY
        --     self.dy = 0
        -- end


        self.y = self.y
        local collidedObjects = self:checkObjectCollisions()
        self.y = self.y

        if #collidedObjects > 0 then
            self.y = collidedObjects[1].y - self.height
            self.dy = 0
        end
    end
end

--[[
    Entity:checkObjectCollisions()
    Checks for collisions with objects in the level.

    Parameters:
        - None

    Returns:
        - collidedObjects (table): A table of objects that the entity has collided with.
]]
function Entity:checkObjectCollisions()
    local collidedObjects = {}

    if self.level.objects then
        for k, object in pairs(self.level.objects) do
            if object:collides(self.hitbox) then
                if object.solid then
                    table.insert(collidedObjects, object)
                elseif object.consumable then
                    object.onConsume(self)
                    table.remove(self.level.objects, k)
                end
            end
        end
    end

    return collidedObjects
end
