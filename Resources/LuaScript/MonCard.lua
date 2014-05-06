MonCard = class()
function MonCard:ctor(s)
    self.scene = s
    self.bg = CCNode:create()
    self.but = ui.newButton({image="cardBack.png", delegate=self, callback=self.onBut, sca=0.5})
    addChild(self.bg, self.but.bg)
end
function MonCard:onBut()
end
