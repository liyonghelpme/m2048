MonCard = class()
function MonCard:ctor(s)
    self.scene = s
    self.bg = CCNode:create()
    self.but = ui.newButton({image="cardBack.png", delegate=self, callback=self.onBut, sca=0.5})
    addChild(self.bg, self.but.bg)


    self.health = 1
    self.hearts = {}
    local sp = setPos(addChild(self.but.bg, createSprite("heartBack.png")), {20, 82})
    local sp = setPos(addChild(self.but.bg, createSprite("heart.png")), {20, 82})
    table.insert(self.hearts, sp)

    self.dice = setPos(addChild(self.but.bg, createSprite("d1.png")), {267-306, 87-140})
    setVisible(self.dice, false)
    self.tooth = setPos(addChild(self.but.bg, createSprite("tooth.png")), {337-306, 87-141})
    setVisible(self.tooth, false)

    self.value = 1
    self.attackable = false
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

function MonCard:throwDice()
    if self.health > 0 then
        --local rd = math.random(1, 6)
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
end

function MonCard:resetState()
    setColor(setVisible(self.dice, false), {255, 255, 255})
    setVisible(self.tooth, false)
    self.attackable = false
end

