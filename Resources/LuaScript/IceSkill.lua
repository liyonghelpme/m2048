IceSkill = class(FuncSkill)
function IceSkill:ctor()
end
function IceSkill:checkEnable()
    local ok = sameEnable(4, self.skill.hero.scene.dices)
    if not ok then
        self.skill:disable()
    else
        self.skill:setEnable()
    end
end
function IceSkill:showAttack()
    local ix = 134-176
    local iy = 622-540
    local offx = 50
    self.swords = {}
    for i=1, 1, 1 do
        local sword = setPos(addChild(self.skill.hero.but.bg, createSprite("s0.png"), 2), {ix+(i-1)*offx, iy})
        table.insert(self.swords, sword)
    end
    local function sendToAll()
        local sword = table.remove(self.swords, 1)
        --object remove call finAttack ok?
        sword:runAction(sequence({fadeout(0.1), callfunc(nil, removeSelf, sword)}))

        local mons = self.skill.hero.scene.monsters
        for k, v in ipairs(mons) do
            if v.health > 0 then
                v:getHurt(1)
            end
        end

    end

    local function finAttack() 
        self.skill.hero.scene:clearAttackState()
        self.skill.hero.scene:finAttack()
    end
    self.skill.bg:runAction(sequence({delaytime(0.5), callfunc(nil, sendToAll), delaytime(0.5), callfunc(nil, finAttack)}))
end
--[[
function IceSkill:doAttack()
    local sword = table.remove(self.swords, 1)
    sword:retain()
    local pos = getPos(sword)
    local np = nodeSpace(self.skill.hero.scene.temp, worldSpace(sword:getParent(), pos))
    removeSelf(sword)
    setPos(addChild(self.skill.hero.scene.temp, sword, 1), np)

    local function finAttack()
        --no more attack
        self.skill.attMon:doSilent(1)
        self.skill.hero.scene:clearAttackState()
        if #self.swords == 0 then
            self.skill.hero.scene:finAttack()
        else
        end
    end

    local p = getPos(self.skill.attMon.bg)
    sword:runAction(sequence({moveto(0.5, p[1], p[2]), fadeout(0.1), callfunc(nil, removeSelf, sword), callfunc(nil, finAttack)}))
end
--]]
--自动释放技能
function IceSkill:checkAttackMon(m)
    return false
end
