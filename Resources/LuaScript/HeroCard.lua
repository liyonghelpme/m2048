HeroCard = class()
function HeroCard:ctor(s)
    self.scene = s
    self.bg = CCNode:create()
    self.but = ui.newButton({image="cardBack.png", delegate=self, callback=self.onBut})
    addChild(self.bg, self.but.bg)
end
function HeroCard:onBut()
end
