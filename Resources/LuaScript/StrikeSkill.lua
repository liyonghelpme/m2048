StrikeSkill = class(FuncSkill)
function StrikeSkill:ctor()
end
function StrikeSkill:checkEnable()
    self.count = {}
    local dices = self.skill.hero.scene.dices
    for i=1,6,1 do
        local d = dices[i]
        if d.value == 1 and d.sel then
            --self:setEnable()
            table.insert(self.count, i)
            --self.hero:enableSkill(0)
        end
    end
    if #self.count > 0 then
        self.skill:setEnable()
    else
        self.skill:disable() 
    end
end
function StrikeSkill:showAttack()
    local ix = 134-176
    local iy = 622-540
    local offx = 50
    self.sword = setPos(addChild(self.skill.hero.but.bg, createSprite("s0.png"), 2), {ix+(1-1)*offx, iy})
end
function StrikeSkill:doAttack(m)
    local sword = self.sword
    sword:retain()
    local pos = getPos(sword)
    local np = nodeSpace(self.skill.hero.scene.temp, worldSpace(sword:getParent(), pos))
    removeSelf(sword)
    setPos(addChild(self.skill.hero.scene.temp, sword, 1), np)

    local function finAttack()
        --no more attack
        self.skill.attMon:getHurt(#self.count)
        self.skill.hero.scene:clearAttackState()

        self.skill.hero.scene:finAttack()
    end

    local p = getPos(m.bg)
    sword:runAction(sequence({moveto(0.5, p[1], p[2]), fadeout(0.1), callfunc(nil, removeSelf, sword), callfunc(nil, finAttack)}))
end
