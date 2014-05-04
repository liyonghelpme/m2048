require "CaveHero"
require "CaveMonster"
CaveScene = class()
function CaveScene:ctor()
    self.bg = CCScene:create()
    self.layer = CaveLayer.new(s)
    addChild(self.bg, self.layer.bg)
end


CaveLayer = class()
function CaveLayer:ctor()
    self.bg = CCLayer:create()
    setContentSize(self.bg, {2048, 2048})

    local sz = {1024, 768}
    self.map = addNode(self.bg)
    local sp = setPos(addChild(self.map, createSprite("f0")), {558, 768-613})
    local sp = setPos(addChild(self.map, createSprite("f1")), {558, 768-613+128})
    local sp = setPos(addChild(self.map, createSprite("f1")), {558, 768-613+128+128})

    self.hero =  CaveHero.new(self)
    self.map:addChild(self.hero.bg)
    setPos(self.hero.bg, {558, 768-613})

    local mon = CaveMonster.new(self)
    setPos(addChild(self.map, mon.bg), {558, 768-613+128+128})

    self.touchDelegate = StandardTouchHandler.new()
    self.touchDelegate.bg = self.bg


    local f = simple.decode(getFileData("stretch.ExportJson"))
    --[[
    for k, v in pairs(f) do
        print(k, v)
    end
    --]]
    local ad = f['animation_data'][1]['mov_data'][1]['mov_bone_data'][1]['frame_data']
    self.frameData = ad
    --print(ad)
    local maxNum = ad[#ad]["fi"]
    print(maxNum)
    

    self.needUpdate = true
    registerEnterOrExit(self)
    registerMultiTouch(self)
end

function CaveLayer:comeToMon(m)
    local p = getPos(m.bg)
    self.hero.bg:runAction(moveto(2, p[1], p[2]))
    self.hero.bg:runAction()
end

function CaveLayer:update(diff)
    self.touchDelegate:update(diff)
end


function CaveLayer:touchesBegan(touches)
    print("touchesBegan")
    self.touchDelegate:tBegan(touches)
end

function CaveLayer:touchesMoved(touches)
    print("touchesMoved")
    self.touchDelegate:tMoved(touches)
end


function CaveLayer:touchesEnded(touches)
    self.touchDelegate:tEnded(touches)
end

function CaveLayer:touchesCanceled(touches)
    self.touchDelegate:tCanceled(touches)
end
