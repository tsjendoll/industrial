Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Constants'
require 'src/Debug'
require 'src/level_data'
require 'src/StateMachine'
require 'src/Tile'
require 'src/TileMap'
require 'src/Util'

-- states
require 'src/states/BaseState'
require 'src/states/game/PlayState'

require 'src/world/Background'
require 'src/world/GameLevel'
require 'src/world/LevelMaker'

tilesets = {
    ['tiles'] = importFolder('graphics/PowerStation/1 Tiles'),
    ['decorations'] = importFolder('graphics/PowerStation/3 Objects/2 Decoration'),
    ['tubes'] = importFolder('graphics/PowerStation/3 Objects/1 Tube'),
    ['powerlines'] = importFolder('graphics/PowerStation/3 Objects/3 Power lines')
}

backgrounds = {
    ['day'] = importFolder('graphics/PowerStation/2 Background/Day'),
    ['overlay'] = love.graphics.newImage('graphics/PowerStation/2 Background/Overlay.png')
}
