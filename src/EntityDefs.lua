ENTITY_DEFS = {
    ['player'] = {
        ['Animations'] = {
            ['idle'] = {
                ['frames'] = {1, 2, 3, 4, 5, 6},
                ['interval'] = 0.3,
                ['looping'] = true
            },
            ['walk'] = {
                ['frames'] = {8, 9, 10, 11, 12, 13, 14},
                ['interval'] = 0.15,
                ['looping'] = true
            },
            ['falling'] = {
                ['frames'] = {1},
                ['interval'] = 1,
                ['looping'] = true
            },
            ['attack'] = {
                ['frames'] = {15, 16, 17, 18, 19 , 20},
                ['interval'] = 0.08,
                ['looping'] = false
            },
            ['death'] = {
                ['frames'] = {29, 30, 31, 32, 33, 34},
                ['interval'] = 0.1,
                ['looping'] = false
            }
        },
        ['swordHitboxWidth'] = 8,
        ['swordHitboxHeight'] = 14,
        ['maxHealth'] = 2,
        ['attackDistance'] = 16,
        ['attackDamage'] = 1
    }
}