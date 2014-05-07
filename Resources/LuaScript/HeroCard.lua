require "Skill"
--初始化
HeroCard = class()
function HeroCard:ctor(s, id)
    self.scene = s
    self.id = id
    self.bg = CCNode:create()
    self.but = ui.newButton({image="cardBack.png", delegate=self, callback=self.onBut})
    addChild(self.bg, self.but.bg)

    if self.id == 0 then
        self.skill = Skill.new(self, 0)
    else
        self.skill = Skill.new(self, 1)
    end


    addChild(self.but.bg, self.skill.bg)

    --self.skill = ui.newButton({image="skillBack.png", delegate=self, callback=self.onSkill})
    --addChild(self.but.bg, self.skill.bg)

    self.health = 1
    self.hearts = {}
    local sp = setPos(addChild(self.but.bg, createSprite("heartBack.png")), {20, 82})
    local sp = setPos(addChild(self.but.bg, createSprite("heart.png")), {20, 82})
    table.insert(self.hearts, sp)

end

function HeroCard:onBut()
    if self.scene.state == FIGHT_STATE.MON_ATTACK then
        if self.health > 0 then
            for i=1, 6, 1 do
                local m = self.scene.monsters[i]
                if m.attackable then
                    self:getHurt(1)
                    m.attackable = false
                    self.scene:checkAllMon()
                    break
                end
            end
        end
    end
end
function HeroCard:getHurt(n)
    self.hearts[self.health]:runAction(fadeout(0.2))
    self.health = self.health-n
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
    self.skill:resetState() 
end

function HeroCard:checkSkill()
    if self.health > 0 then
        self.skill:checkEnable()
    end
end
