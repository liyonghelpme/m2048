CaveHero = class()
function CaveHero:ctor(s)
    self.scene = s
    self.bg = createSprite("warrior.png")
    self.needUpdate = true
    registerEnterOrExit(self)


    self.inMove = false
    self.passTime = 0
    local fd = self.scene.frameData
    --frame number each frame time

end
function CaveHero:update(diff)
    if self.inMove == true then
        self.passTime = self.passTime+diff
        
    end
end
