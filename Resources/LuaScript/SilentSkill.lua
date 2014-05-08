SilentSkill = class(FuncSkill)
function SilentSkill:ctor()
end
function SilentSkill:checkEnable()
    local dices = self.skill.hero.scene.dices
    local count = {}
    for i=1,6,1 do
        local d = dices[i]
        if d.sel  then
            table.insert(count, d.value)
            if #count > 3 then
                break
            end
        end
    end
    --sort
    if #count == 3 then
        --table.sort(count) 
        local ok = true
        for i=2, 3, 1 do
            if count[i] ~= count[1] then
                ok = false
                self.skill:disable()
                break
            end
        end
        if ok then
            self.skill:setEnable()
        end
    else
        self.skill:disable() 
    end
end

function SilentSkill:showAttack()
    local ix = 134-176
    local iy = 622-540
    local offx = 50
    self.swords = {}
    for i=1, 2, 1 do
        local sword = setPos(addChild(self.skill.hero.but.bg, createSprite("s0.png"), 2), {ix+(i-1)*offx, iy})
        table.insert(self.swords, sword)
    end
end

function SilentSkill:doAttack()
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
