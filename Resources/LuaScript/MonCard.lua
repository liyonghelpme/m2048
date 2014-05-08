MonCard = class()
function MonCard:ctor(s, id, h)
    self.kind = 1
    self.id = id
    if self.id == 0 then
        self.maxHealth = 2
    elseif self.id == 1 then
        self.maxHealth = 1
    end

    self.scene = s
    self.bg = CCNode:create()
    self.but = ui.newButton({image="cardBack.png", delegate=self, callback=self.onBut, sca=0.5})
    addChild(self.bg, self.but.bg)


    self.health = h
    self.hearts = {}
    local ix = -80
    local iy = 82
    local ox = 35
    for i=1, self.maxHealth, 1 do
        local sp = setPos(addChild(self.but.bg, createSprite("heartBack.png")), {ix+(i-1)*ox, iy})
        local sp = setPos(addChild(self.but.bg, createSprite("heart.png")), {ix+(i-1)*ox, iy})
        table.insert(self.hearts, sp)
        if i > self.health then
            setOpacity(sp, 0)
        end
    end

    self.dices = {}
    --self.toothes = {}
    --多个色子 多个 牙齿
    --[[
    self.dice = setPos(addChild(self.but.bg, createSprite("d1.png")), {267-306, 87-140})
    setVisible(self.dice, false)
    self.tooth = setPos(addChild(self.but.bg, createSprite("tooth.png")), {337-306, 87-141})
    setVisible(self.tooth, false)
    --]]

    self.value = 1
    self.attackable = false
    self.silent = 0
end
function MonCard:onBut()
    if self.scene.state == 4 and self.health > 0 then
        self.scene:attackMon(self)
    end
end

function MonCard:getHurt(n)
    while self.health > 0 and n > 0 do
        self.hearts[self.health]:runAction(fadeout(0.3))
        self.health = self.health-1
        n = n-1
    end

    if self.health == 0 then
        setColor(self.but.sp, {128, 128, 128})
    end
end


function MonCard:checkAttackable()
    for k, v in ipairs(self.dices) do
        if v.attackable then
            return true
        end
    end
    return false
end

function MonCard:doAttack(h)
    local pos = getPos(h.bg)
    for k, v in ipairs(self.dices) do
        if v.attackable then
            v.tooth:retain()
            local np = toNodeSpace(self.scene.temp, v.tooth)

            removeSelf(v.tooth)
            self.scene.temp:addChild(v.tooth, 2)
            v.tooth:release()
            setPos(v.tooth, np)
            local function finAttack()
            end
            v.tooth:runAction(sequence({moveto(0.5, pos[1], pos[2]), fadeout(0.2), callfunc(nil, finAttack)}))

            v.attackable = false
            break
        end
    end
end


function MonCard:throwDice()
    if self.health > 0 then
        --local rd = math.random(1, 6)
        local ch = self.health
        while self.silent > 0 and ch > 0 do
            self.silent = self.silent-1
            ch = ch-1
        end
        if self.silent > 0 or ch == 0 then
            self.dices = {}
            --self.value = 0 
            return
        elseif ch > 0 then
            --self.diceRes = {}
            self.dices = {}
            local ani = getAnimation("roll") 
            local ix = 267-306
            local iy = 87-140
            local ox = 130
            for i=1, ch, 1 do
                local rd = myRand(1, 6)
                --table.insert(self.diceRes, rd)
                local dice = setPos(addChild(self.but.bg, createSprite("d1.png")), {ix+(i-1)*ox, iy})
                dice.value = rd
                table.insert(self.dices, dice)
                local function setV()
                    setTexOrDis(dice, "d"..rd..".png")
                end

                dice:runAction(sequence({CCAnimate:create(ani), callfunc(nil, setV)}))
                --attackable no useage
                if rd == 6 then
                    --self.attackable = true
                    setColor(dice, {255, 0, 0})
                    local tooth = setPos(addChild(self.but.bg, createSprite("tooth.png")), {ix+(i-1)*ox, iy+100})
                    dice.tooth = tooth
                    dice.attackable = true
                end
            end
        end

        --[[
        if self.silent > 0 then
            self.silent = self.silent-1
            self.value = 0
        else
            local rd = myRand(1, 6)
            self.value = rd
            local ani = getAnimation("roll") 
            local function setV()
                setTexOrDis(self.dice, "d"..rd..".png")
            end
            if rd == 6 then
                self.attackable = true
                setColor(self.dice, {255, 0, 0})
                setVisible(self.tooth, true)
            end
            setVisible(self.dice, true)
            self.dice:runAction(sequence({CCAnimate:create(ani), callfunc(nil, setV)}))
        end
        --]]
    end
end

function MonCard:resetState()
    --setColor(setVisible(self.dice, false), {255, 255, 255})
    --setVisible(self.tooth, false)
    for k, v in ipairs(self.dices) do
        removeSelf(v)  
    end
    self.dices = {}
    --self.attackable = false
end


function MonCard:doSilent(n)
    self.silent = self.silent+1
end

