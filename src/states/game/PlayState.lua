PlayState = Class{__includes = BaseState}

function PlayState:init()
    -- Initialize camera position
    self.camX = 0
    self.camY = 0
end

function PlayState:enter(params)
    self.level = LevelMaker:generateLevel(1)
    self.background = Background(self.level.width)
end

function PlayState:update(dt)
    self:input(dt)
    self.level:update(dt)
    self.background:update(dt)
end

function PlayState:render()
    love.graphics.push()
    love.graphics.translate(-self.camX, -self.camY)

    self.background:render(self.camX)
    
    self.level:render()

    love.graphics.pop()
end

function PlayState:input(dt)
     -- Camera movement speed
     local cameraSpeed = 600

     if love.keyboard.isDown('left') then
        self.camX = math.max(0, self.camX - cameraSpeed * dt)
     elseif love.keyboard.isDown('right') then
        local maxX = self.level.width - VIRTUAL_WIDTH
        self.camX = math.min(maxX, self.camX + cameraSpeed * dt)
     end
 
      -- Vertical camera movement
    if love.keyboard.isDown('up') then
        self.camY = math.max(0, self.camY - cameraSpeed * dt)
    elseif love.keyboard.isDown('down') then
        local maxY = self.level.height - VIRTUAL_HEIGHT
        self.camY = math.min(maxY, self.camY + cameraSpeed * dt)
    end
end