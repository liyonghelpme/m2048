Dice = class()
function Dice:ctor(s)
    self.scene = s
    self.bg = CCNode:create()
    self.dice = ui.newButton({image="d1.png", delegate=self, callback=self.onDice})
    addChild(self.bg, self.dice.bg)
    --self.dice = addChild(self.bg, createSprite("d1.png"))
    self.value = 1
    
    self.visible = true
    self.sel = false
    self.ani = createAnimation("roll", "d%d.png", 1, 6, 1, 0.3, false)
end

function Dice:setRoll(v)
    self.value = v
    local function finRoll()
        setTexOrDis(self.dice.sp, "d"..self.value..".png")
    end
    self.dice.sp:runAction(sequence({CCAnimate:create(self.ani), callfunc(nil, finRoll)}))
end

function Dice:onDice()
    if (self.scene.state == 1 or self.scene.state == 2) and not self.scene.inRoll then
        self.visible = not self.visible
        if self.visible then
            setColor(self.dice.sp, {255, 255, 255})
        else
            setColor(self.dice.sp, {128, 128, 128})
        end
    elseif self.scene.state == 3 then
        self.sel = not self.sel
        self.scene:checkDice()
        if self.sel then
            setColor(self.but.sp, {255, 255, 255})
        else
            setColor(self.but.sp, {128, 128, 128})
        end
    end

end
function Dice:setHide()
    setColor(self.dice.sp, {128, 128, 128})
end
