require "SkillUtil"
require "FuncSkill"
require "RushSkill"
require "StrikeSkill"
require "RaySkill"
require "HealSkill"
require "SilentSkill"
require "IceSkill"

Skill = class()
function Skill:ctor(h, id, pos)
    self.hero = h
    --Rush Skill
    self.id = id

    if self.id == 0 then
        self.func = RushSkill.new(self)
    elseif self.id == 1 then
        self.func = StrikeSkill.new(self)
    elseif self.id == 2 then
        self.func = RaySkill.new(self)
    elseif self.id == 3 then
        self.func = HealSkill.new(self)
    elseif self.id == 4 then
        self.func = SilentSkill.new(self)
    elseif self.id == 5 then
        self.func = IceSkill.new(self)
    end

    self.bg = CCNode:create()
    self.but = ui.newButton({image="skillBack.png", delegate=self, callback=self.onSkill})
    addChild(self.bg, self.but.bg)
    self.enable = false
    self.selYet = false
    self.countSix = {}
    self.swords = {}
    --self.useYet = false
    --self.sword = addChild(self.hero.bg, createSprite("s0.png"))
end


--select Dice combination
--each skill can only be used once
function Skill:onSkill()
    if self.enable and self.hero.scene.state == 3 and not self.selYet then
        self.selYet = true
        self.hero.scene:goSelTarget(self)
        setColor(self.but.sp, {128, 128, 128})
        self.func:showAttack()
        --[[
        self.swords = {}
        local ix = 134-176
        local iy = 622-540
        local offx = 50
        print("countSix is", #self.countSix)
        for k, v in ipairs(self.countSix) do
            local sword = setPos(addChild(self.hero.but.bg, createSprite("s0.png"), 2), {ix+(k-1)*offx, iy})
            table.insert(self.swords, sword)
        end
        --]]
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
    self.attMon = m
    self.func:doAttack(m)

    --[[
    local sword = self.swords[1]
    table.remove(self.swords, 1)

    sword:retain()
    local pos = getPos(sword)
    local np = nodeSpace(self.hero.scene.temp, worldSpace(sword:getParent(), pos))
    removeSelf(sword)
    setPos(addChild(self.hero.scene.temp, sword, 1), np)

    local function finAttack()
        --no more attack
        self.attMon:getHurt(1)
        self.hero.scene:clearAttackState()
        if #self.swords == 0 then
            self.hero.scene:finAttack()
        --need to select again
        else

        end
    end

    local p = getPos(m.bg)
    sword:runAction(sequence({moveto(0.5, p[1], p[2]), fadeout(0.1), callfunc(nil, removeSelf, sword), callfunc(nil, finAttack)}))
    --]]
    --sword = nil
end

function Skill:resetState()
    self.countSix = {}
    self.enable = false
    self.selYet = false
end


--根据当前的色子选择状态
--检查Skill 是否可以释放
function Skill:checkEnable()
    self.func:checkEnable()
    --[[
    self.countSix = {}
    local dices = self.hero.scene.dices
    for i=1,6,1 do
        local d = dices[i]
        if d.value == 6 and d.sel then
            --self:setEnable()
            table.insert(self.countSix, i)
            --self.hero:enableSkill(0)
        end
    end
    if #self.countSix <= 2 and #self.countSix > 0 then
        self:setEnable()
    else
        self:disable() 
    end
    --]]
end
function Skill:checkAttackMon(m)
    return self.func:checkAttackMon(m)
end



