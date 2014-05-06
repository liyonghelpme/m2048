require "HeroCard"
require "MonCard"
require "Dice"

FightScene = class()
function FightScene:ctor()
    self.bg = CCScene:create()
    self.layer = FightLayer.new()
    addChild(self.bg, self.layer.bg)
end


FightLayer = class()
function FightLayer:ctor()
    self.bg = CCLayer:create()
    self.state = 0
    local sz = {width=1024, height=768}
    self.temp = addNode(self.bg)
    centerTemp(self.temp)


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

function FightLayer:onPass()
end

function FightLayer:update(diff)
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
