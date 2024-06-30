SoundSequence = Class{}

function SoundSequence:init(sounds)
    self.sounds = sounds
    self.currentSoundIndex = 1
end

function SoundSequence:play()
    if self.currentSoundIndex <= #self.sounds then
        local sound = self.sounds[self.currentSoundIndex]
        sound:play()
        self.currentSoundIndex = self.currentSoundIndex + 1
    end
end

function SoundSequence:update()
    if self.currentSoundIndex > 1 then
        local lastSound = self.sounds[self.currentSoundIndex - 1]
        if not lastSound:isPlaying() then
            if self.currentSoundIndex > #self.sounds then
                self.currentSoundIndex = 1 -- Reset the index after the last sound
            else
                self:play()
            end
        end
    end
end

