require 'src/Util'

local lab_background_1 = import_csv_layout('Tiled/levelData/level1_LabBackground.csv')
local collidable_1 = import_csv_layout('Tiled/levelData/level1_Collidable.csv')
local decoration_1 = import_csv_layout('Tiled/levelData/level1_Decoration.csv')
local tubes_1 = import_csv_layout('Tiled/levelData/level1_Tubes.csv')
local powerlines_1 = import_csv_layout('Tiled/levelData/level1_PowerLines.csv')
local decoration_1_2 = import_csv_layout('Tiled/levelData/level1_Decoration2.csv')


levelData = {
    [1] = {
        ['layers'] = {
            [1] = {
                ['data'] = tubes_1,
                ['texture'] = 'tubes'
            },
            [2] = {
                ['data'] = lab_background_1,
                ['texture'] = 'tiles'
            },
            [3] = {
                ['data'] = collidable_1,
                ['texture'] = 'tiles'
            },
            [4] = {
                ['data'] = decoration_1,
                ['texture'] = 'decorations'
            },
            [5] = {
                ['data'] = powerlines_1,
                ['texture'] = 'powerlines'
            },
            [6] = {
                ['data'] = decoration_1_2,
                ['texture'] = 'decorations'
            }
        }
    }
}