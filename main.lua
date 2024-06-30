require 'src/Dependencies'

debugOn = true

debug = Debug()

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Industrial')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['play'] = function() return PlayState() end
    }
    
    gStateMachine:change('play')
    
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    Timer.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateMachine:render()

    -- if debugOn then
    --     debug:draw()    
    -- end
    love.graphics.line(0, 0, 0, VIRTUAL_HEIGHT)
    push:finish()
end