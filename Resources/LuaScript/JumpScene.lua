require "JumpLayer"
JumpScene = class()
function JumpScene:ctor()
    local body = ar
    self.bg = CCScene:create()
    self.layer = JumpLayer.new(self)
    addChild(self.bg, self.layer.bg)
end

