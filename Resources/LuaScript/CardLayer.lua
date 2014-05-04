require "CaveScene"

CardLayer = class()
function CardLayer:ctor(s)
    self.scene = s
    self.bg = CCLayer:create()
    
    local sz = {width=1024, height=768}
    local vs = getVS()
    local cl = CCLayerColor:create(ccc4(31, 32, 101, 255))
    --[[
    cl:setColor(ccc4(31, 32, 101, 255))
    --setContentSize(cl, {vs.width, vs.height})
    --]]

    setPos(setAnchor(addChild(self.bg, cl), {0, 0}), {0, 0})


    self.mid = addNode(self.bg)
    local sp = setPos(addChild(self.mid, CCSprite:create("island1.png")), {512, fixY(sz.height, 394)})
    local sp = setAnchor(setPos(addSprite(self.mid, "island2.png"), {814, fixY(sz.height, 764)}), {0.50, 0.50})
    centerTemp(self.mid)

    local but = ui.newButton({image="cave.png", delegate=self, callback=self.onCave})
    local sp = setPos(addChild(self.mid, but.bg), {116, fixY(sz.height, 467)})

    --大关卡点击成功变成灰色 关卡树装图
    --A B C
    --B C D
    --每个洞穴中的小关卡
    local u = CCUserDefault:sharedUserDefault()
    
    --关卡闯过了 变成灰色
    --黑色的场景

    
    local tex = CCTextureCache:sharedTextureCache():addImage("floor.png")
    local sf = CCSpriteFrameCache:sharedSpriteFrameCache()
    for i=0, 1, 1 do
        for j = 0, 1, 1 do
            local rect = CCRectMake(i*128, j*128, 128, 128)
            createSpriteFrame(tex, rect, "f"..(i*2+j))
        end
    end
end

function CardLayer:onCave()
    global.director:pushScene(CaveScene.new())
end

