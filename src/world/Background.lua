Background = Class{}

function Background:init(width)
    self.width = width * 2
    self.speeds = {0.0005, 0.001, 0.015, 0.04, 0.1} -- Define speed for each layer
    self.overlayAlpha = 0
    self.alphaDirection = 1
    self.alphaSpeed = 0.1 -- Adjust speed of fading
end

function Background:update(dt)
     -- Update overlay alpha
     self.overlayAlpha = self.overlayAlpha + self.alphaDirection * self.alphaSpeed * dt
     if self.overlayAlpha >= 0.5 then
         self.overlayAlpha = 0.5
         self.alphaDirection = -1
     elseif self.overlayAlpha <= 0 then
         self.overlayAlpha = 0
         self.alphaDirection = 1
     end
end

function Background:render(camX)
    local backgroundWidth = backgrounds['day'][2]:getWidth()

    for i = 1, #backgrounds['day'] do
        for x = 0, self.width, backgroundWidth do
            local y = (i == 1) and 0 or 50
            -- Adjust x position for parallax effect based on camX and speed
            local parallaxX = x - (camX * self.speeds[i])
            love.graphics.draw(backgrounds['day'][i], parallaxX, y)
        end
    end

   

    -- Draw the overlay with changing alpha
    love.graphics.setColor(1, 0, 1, self.overlayAlpha)
    love.graphics.draw(backgrounds['overlay'], 0, 0, 0, self.width / backgrounds['overlay']:getWidth(), 1)
    love.graphics.setColor(1, 1, 1, 1)
end
