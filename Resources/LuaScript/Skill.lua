Skill = class()
function Skill:ctor(h)
    self.hero = h
    self.bg = CCNode:create()
    self.but = ui.newButton({image="skillBack.png", delegate=self, callback=self.onSkill})
    addChild(self.bg, self.but.bg)
    self.enable = false
    self.selYet = false
    --self.useYet = false
    --self.sword = addChild(self.hero.bg, createSprite("s0.png"))
end


--select Dice combination
--each skill can only be used once
function Skill:onSkill()
    if self.enable and self.hero.scene.state == 3 and not self.selYet then
        self.selYet = true
        self.hero.scene:goSelTarget(self)
        self.sword = setPos(addChild(self.hero.but.bg, createSprite("s0.png")), {134-176, 622-540})
    end
end


function Skill:setEnable()
    if not self.selYet then
        self.enable = true
        --self.but.bg:runAction(repeatForever(sequence({scaleto(0.3, 1.2, 1.2), scaleto(0.3, 1, 1)})))
        self.but.bg:setScale(1.2)
        setColor(self.but.sp, {255, 255, 255})
    end
end
function Skill:disable()
    self.enable = false
    self.but.bg:stopAllActions()
    self.but.bg:setScale(1)
    setColor(self.but.sp, {128, 128, 128})
end
function Skill:attackMon(m)
    self.sword:retain()
    local pos = getPos(self.sword)
    local np = nodeSpace(self.hero.scene.temp, worldSpace(self.sword:getParent(), pos))
    removeSelf(self.sword)
    setPos(addChild(self.hero.scene.temp, self.sword, 1), np)

    local function finAttack()
        self.hero.scene:finAttack()
    end

    local p = getPos(m.bg)
    self.sword:runAction(sequence({moveto(0.5, p[1], p[2]), fadeout(0.1), callfunc(nil, removeSelf, self.sword), callfunc(nil, finAttack)}))
    self.sword = nil
end

function Skill:resetState()
    self.enable = false
    self.selYet = false
end

