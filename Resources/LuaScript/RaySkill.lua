RaySkill = class(FuncSkill)
function RaySkill:ctor()
end
function RaySkill:checkEnable()
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
        table.sort(count) 
        local ok = true
        for i=2, 3, 1 do
            if count[i]-count[i-1] ~= 1 then
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

function RaySkill:showAttack()
    local ix = 134-176
    local iy = 622-540
    local offx = 50
    self.sword = setPos(addChild(self.skill.hero.but.bg, createSprite("s0.png"), 2), {ix+(1-1)*offx, iy})
end
function RaySkill:doAttack()
    local sword = self.sword
    sword:retain()
    local pos = getPos(sword)
    local np = nodeSpace(self.skill.hero.scene.temp, worldSpace(sword:getParent(), pos))
    removeSelf(sword)
    setPos(addChild(self.skill.hero.scene.temp, sword, 1), np)

    local function finAttack()
        --no more attack
        self.skill.attMon:getHurt(1)
        self.skill.hero.scene:clearAttackState()
        self.skill.hero.scene:finAttack()
    end

    local p = getPos(self.skill.attMon.bg)
    sword:runAction(sequence({moveto(0.5, p[1], p[2]), fadeout(0.1), callfunc(nil, removeSelf, sword), callfunc(nil, finAttack)}))
end

