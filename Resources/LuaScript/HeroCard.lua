require "Skill"
HeroCard = class()
function HeroCard:ctor(s)
    self.scene = s
    self.bg = CCNode:create()
    self.but = ui.newButton({image="cardBack.png", delegate=self, callback=self.onBut})
    addChild(self.bg, self.but.bg)

    self.skill = Skill.new(self)
    addChild(self.but.bg, self.skill.bg)

    --self.skill = ui.newButton({image="skillBack.png", delegate=self, callback=self.onSkill})
    --addChild(self.but.bg, self.skill.bg)

    self.health = 1
    self.hearts = {}
    local sp = setPos(addChild(self.but.bg, createSprite("heartBack.png")), {20, 82})
    local sp = setPos(addChild(self.but.bg, createSprite("heart.png")), {20, 82})
    table.insert(self.hearts, sp)

    self.skillEnable = false
end
function HeroCard:onBut()
end

function HeroCard:enableSkill(s)
    self.skill:setEnable()
end
function HeroCard:disableSkill()
    self.skill:disable()
end
