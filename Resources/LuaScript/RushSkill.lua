RushSkill = class(FuncSkill)
function RushSkill:ctor()
    self.countSix = {}
end
function RushSkill:checkEnable()
    self.countSix = {}
    local dices = self.skill.hero.scene.dices
    for i=1,6,1 do
        local d = dices[i]
        if d.value == 6 and d.sel then
            --self:setEnable()
            table.insert(self.countSix, i)
            --self.hero:enableSkill(0)
        end
    end
    if #self.countSix <= 2 and #self.countSix > 0 then
        self.skill:setEnable()
    else
        self.skill:disable() 
    end
end
function RushSkill:showAttack()
    self.swords = {}
    local ix = 134-176
    local iy = 622-540
    local offx = 50
    print("countSix is", #self.countSix)
    for k, v in ipairs(self.countSix) do
        local sword = setPos(addChild(self.skill.hero.but.bg, createSprite("s0.png"), 2), {ix+(k-1)*offx, iy})
        table.insert(self.swords, sword)
    end
end
function RushSkill:doAttack(m)
    local sword = self.swords[1]
    table.remove(self.swords, 1)

    sword:retain()
    local pos = getPos(sword)
    local np = nodeSpace(self.skill.hero.scene.temp, worldSpace(sword:getParent(), pos))
    removeSelf(sword)
    setPos(addChild(self.skill.hero.scene.temp, sword, 1), np)

    local function finAttack()
        --no more attack
        self.skill.attMon:getHurt(1)
        self.skill.hero.scene:clearAttackState()
        if #self.swords == 0 then
            self.skill.hero.scene:finAttack()
        --need to select again
        else

        end
    end

    local p = getPos(m.bg)
    sword:runAction(sequence({moveto(0.5, p[1], p[2]), fadeout(0.1), callfunc(nil, removeSelf, sword), callfunc(nil, finAttack)}))
end

