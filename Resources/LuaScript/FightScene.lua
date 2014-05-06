require "HeroCard"
require "MonCard"
require "Dice"
FIGHT_STATE = {
    ROLL_ONE=0,
    ROLL_TWO=1,
    ROLL_THREE=2,
    SEL_DICE=3,
    SEL_TARGET=4,
    MON_ATTACK=5,
    GAME_OVER=6,
}

FightScene = class()
function FightScene:ctor()
    self.bg = CCScene:create()
    self.layer = FightLayer.new()
    addChild(self.bg, self.layer.bg)
    self.dialogController = DialogController.new(self)
    addChild(self.bg, self.dialogController.bg)
end


FightLayer = class()
function FightLayer:ctor()
    math.randomseed(0)
    self.state = 0
    self.selSkill = nil
    self.attMon = nil

    self.bg = CCLayer:create()
    local sz = {width=1024, height=768}
    self.temp = addNode(self.bg)
    centerTemp(self.temp)

    self.sNum = ui.newTTFLabel({text="0", size=50})
    setPos(addChild(self.bg, self.sNum, 5), {100, 100})

    local h = HeroCard.new(self)
    setPos(addChild(self.temp, h.bg), {176, fixY(sz.height, 622)})
    self.hero = h

    local dpos = {
        {144, fixY(sz.height, 382)},
        {309, fixY(sz.height, 363)},
        {463, fixY(sz.height, 365)},
        {599, fixY(sz.height, 356)},
        {736, fixY(sz.height, 354)},
        {878, fixY(sz.height, 354)}
    }

    self.dices = {}
    for i=1, 6, 1 do
        local d = Dice.new(self)
        setPos(addChild(self.temp, d.bg), dpos[i])
        table.insert(self.dices, d)
    end

    
    local but = ui.newButton({image="rollBut.png", text="ROLL DICE", font="f1", size=18, delegate=self, callback=self.onRoll, shadowColor={0, 0, 0}, color={255, 255, 255}})
    self.rollBut = but
    but:setContentSize(121, 50)
    setPos(addChild(self.temp, but.bg), {394, fixY(sz.height, 448)})

    local but = ui.newButton({image="rollBut.png", text="PASS", font="f1", size=18, delegate=self, callback=self.onPass, shadowColor={0, 0, 0}, color={255, 255, 255}})
    self.passBut = but
    but:setContentSize(121, 50)
    setPos(addChild(self.temp, but.bg), {566, fixY(sz.height, 448)})

    
    local mpos = {
        {152, fixY(sz.height, 156)},
        {306, fixY(sz.height, 87)},
        {306, fixY(sz.height, 229)},
        {460, fixY(sz.height, 87)}, 
        {460, fixY(sz.height, 229)},
    }
    self.monsters = {}
    for i=1, 5, 1 do
        local m = MonCard.new(self)
        setPos(addChild(self.temp, m.bg), mpos[i])
        table.insert(self.monsters, m)
    end


    self.needUpdate = true
    registerEnterOrExit(self)
end

function FightLayer:onRoll()
    if self.state == 0 or self.state == 1 or self.state == 2 then
        if not self.inRoll then
            self.inRoll = true
            for i=1, 6, 1 do
                local d = self.dices[i]
                if d.visible then
                    local rd = math.random(1, 6)
                    d:setRoll(rd)
                end
            end

            local function finRoll()
                self.inRoll = false
                if self.state == 0 then
                    self.rollBut.text:setString("SECOND ROLL")
                elseif self.state == 1 then
                    self.rollBut.text:setString("THIRD ROLL")
                else
                    self.rollBut.text:setString("FINISH ROLL")
                end
                self.state = self.state+1

                if self.state == 3 then
                    for i=1, 6, 1 do
                        self.dices[i]:setHide()
                    end
                end
            end
            self.bg:runAction(sequence({delaytime(0.4), callfunc(nil, finRoll)}))
        end
    end
end

--pass select dice or select target
function FightLayer:onPass()
    if self.state == 3 or self.state == 4 then
        self.state = FIGHT_STATE.MON_ATTACK
        for k, v in ipairs(self.monsters) do
            v:throwDice()
        end

        local function dcheck()
            self:checkAllMon()
        end
        self.bg:runAction(sequence({delaytime(1), callfunc(nil, dcheck)}))
    end
end

--check Whether Monster attackable
function FightLayer:checkAllMon()
    if self.state ~= FIGHT_STATE.ROLL_ONE then
        local atk = false
        for k, v in ipairs(self.monsters) do
            if v.attackable then
                atk = true
                break
            end
        end
        if not atk then
            self:resetState()     
        end
    end
end

--reset scene
--reset hero
--reset monster
--reset dice
function FightLayer:resetState()
    self.state = FIGHT_STATE.ROLL_ONE
    self.selSkill = nil
    self.attMon = nil
    self.rollBut.text:setString("ROLL DICE")

    for k, v in ipairs(self.monsters) do
        v:resetState()
    end
    for k, v in ipairs(self.dices) do
        v:resetState()
    end
    self.hero:resetState()
    
    if self.hero.health == 0 then
        self:gameOver()
    else
        self:checkMonDead()
    end
end
function FightLayer:gameOver()
    if self.state ~= FIGHT_STATE.GAME_OVER then
        self.state = FIGHT_STATE.GAME_OVER
        addBanner("Game Over")
    end
end
function FightLayer:checkMonDead()
    local md = true
    for k, v in ipairs(self.monsters) do
        if v.health > 0 then
            md = false
            break
        end
    end
    if md then
        self.state = FIGHT_STATE.GAME_OVER
        addBanner("Game Over")
    end
end



function FightLayer:update(diff)
    self.sNum:setString(self.state)
end

function FightLayer:checkDice()
    self.hero:disableSkill()
    for i=1,6,1 do
        local d = self.dices[i]
        if d.value == 6 and d.sel then
            if self.hero.health > 0 then
                self.hero:enableSkill(0)
            end
        end
    end
end
function FightLayer:goSelTarget(ss)
    self.state = 4
    self.selSkill = ss
    for i=1, 6, 1 do
        self.dices[i]:useDice()
    end
end

function FightLayer:attackMon(m)
    if self.selSkill ~= nil and self.attMon == nil then
        self.attMon = m
        self.selSkill:attackMon(m) 
    end
end

--reselect new skill
--select two six
--don't repeat select skill 
function FightLayer:finAttack()
    self.selSkill = nil
    self.state = 3
    self.attMon:getHurt(1)
    self.attMon = nil
end
