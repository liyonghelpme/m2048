require "CardLayer"
CardScene = class()
function CardScene:ctor()
    self.bg = CCScene:create()
    self.layer = CardLayer.new(self)
    addChild(self.bg, self.layer.bg)


    --[[
    --]]

end

