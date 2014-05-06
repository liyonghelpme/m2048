Skill = class()
function Skill:ctor(h)
    self.hero = h
    self.bg = CCNode:create()
    self.but = ui.newButton({image="skillBack.png", delegate=self, callback=self.onSkill})
    addChild(self.bg, self.but.bg)
    self.enable = false
end
function Skill:onSkill()
end

function Skill:setEnable()
    self.enable = true
    self.but.bg:runAction(repeatForever(sequence({scaleto(0.3, 1.2, 1.2), scaleto(0.3, 1, 1)})))
    self.but.bg:setScale(1.2)
end
function Skill:disable()
    self.enable = false
    self.but.bg:stopAllActions()
    self.but.bg:setScale(1)
end
