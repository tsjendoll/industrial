PlayState = Class{__includes = BaseState}

function PlayState:init()
    -- Initialize camera position
    self.camX = 0
    self.camY = 0

end

function PlayState:enter(params)
    level = LevelMaker:generateLevel(1)
end

function PlayState:update(dt)
    level:update(dt)
end

function PlayState:render()
    love.graphics.push()
    level:render()
    love.graphics.pop()
end