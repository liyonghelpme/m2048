require "Skill"
--初始化
HeroCard = class()
function HeroCard:ctor(s, id)
    self.kind = 0
    self.scene = s
    self.id = id
    self.bg = CCNode:create()
    self.but = ui.newButton({image="cardBack.png", delegate=self, callback=self.onBut})
    addChild(self.bg, self.but.bg)

    self.skills = {}
    if self.id == 0 then
        local skill = Skill.new(self, 0)
        table.insert(self.skills, skill)
    elseif self.id == 1 then
        local skill = Skill.new(self, 1)
        table.insert(self.skills, skill)
    elseif self.id == 2 then
        local skill = Skill.new(self, 2, 0)
        table.insert(self.skills, skill)
        local skill = Skill.new(self, 3, 1)
        table.insert(self.skills, skill)
    --沉默两个人
    elseif self.id == 3 then
        local skill = Skill.new(self, 4)
        table.insert(self.skills, skill)
        local skill = Skill.new(self, 5)
        table.insert(self.skills, skill)
    end


    local initX = -60
    local initY = 0
    local offX = 60
    for k, v in ipairs(self.skills) do
        setPos(addChild(self.but.bg, v.bg), {initX+(k-1)*offX, initY})
    end

    --self.skill = ui.newButton({image="skillBack.png", delegate=self, callback=self.onSkill})
    --addChild(self.but.bg, self.skill.bg)

    if self.id == 0 then
        self.health = 3 
    elseif self.id == 1 then
        self.health = 2
    elseif self.id == 2 then
        self.health = 2
    elseif self.id == 3 then
        self.health = 1
    end
    self.hearts = {}
    local ix = -80
    local iy = 82
    local ox = 35
    for i=1, self.health, 1 do
        local sp = setPos(addChild(self.but.bg, createSprite("heartBack.png")), {ix+(i-1)*ox, iy})
        local sp = setPos(addChild(self.but.bg, createSprite("heart.png")), {ix+(i-1)*ox, iy})
        table.insert(self.hearts, sp)
    end

end

function HeroCard:onBut()
    if self.scene.state == FIGHT_STATE.MON_ATTACK then
        if self.health > 0 then
            for i=1, 6, 1 do
                local m = self.scene.monsters[i]
                if m:checkAttackable() then
                    m:doAttack(self)
                    self:getHurt(1)
                    --m.attackable = false
                    self.scene:checkAllMon()
                    break
                end
            end
        end
    --已经阵亡的角色还能治愈么?
    elseif self.scene.state == FIGHT_STATE.SEL_TARGET then
        if self.health > 0 then
            self.scene:attackMon(self)
        end
    end

end
function HeroCard:getHurt(n)
    while self.health > 0 and n > 0 do
        self.hearts[self.health]:runAction(fadeout(0.3))
        self.health = self.health-1
        n = n-1
    end

    if self.health == 0 then
        setColor(self.but.sp, {128, 128, 128})
    end
end

--[[
function HeroCard:enableSkill(s)
    self.skill:setEnable()
end
--]]


--[[
function HeroCard:disableSkill()
    self.skill:disable()
end
--]]



function HeroCard:resetState()
    for k, v in ipairs(self.skills) do
        v:resetState()
    end
end

function HeroCard:checkSkill()
    if self.health > 0 then
        for k, v in ipairs(self.skills) do
            v:checkEnable()
        end
    end
end

function HeroCard:getHeal(n)
    while self.health < #self.hearts and n > 0 do
        self.health = self.health+1
        n = n-1
        self.hearts[self.health]:runAction(fadein(0.3))
    end

    --[[
    if self.health > 0 then
        setColor(self.but.sp, {255, 255, 255})
    end
    --]]
end

function HeroCard:checkSkillPossible()
end
