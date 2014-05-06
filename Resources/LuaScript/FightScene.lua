require "HeroCard"
require "MonCard"

FightScene = class()
function FightScene:ctor()
    self.bg = CCScene:create()
    self.layer = FightLayer:ctor()
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
end
