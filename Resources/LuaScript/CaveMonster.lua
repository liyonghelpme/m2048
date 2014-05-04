CaveMonster = class()
function CaveMonster:ctor(s)
    self.scene = s
    self.bg = CCLayer:create()

    self.sp = addChild(self.bg, createSprite("m0.png"))
    --setAnchor(, {76/170, 46/89})
    local sz = getContentSize(self.sp)
    setAnchor(setContentSize(self.bg, sz), {0.5, 0.5})


    self.sz = {width=sz[1], height=sz[2]}
    --{width=128, height=128}
    registerTouch(self)
    registerEnterOrExit(self)
end
function CaveMonster:touchBegan(x, y)
    if not self.touchYet then
        self.touchYet = true
        local np = self.sp:convertToNodeSpace(ccp(x, y))
        if checkIn(np.x, np.y, self.sz) then
            self.lastPos = {np.x, np.y}
            self.sp:runAction(sequence({scaleto(0.05, 0.9, 0.9)}))
            return true
        end
    end
end

function CaveMonster:touchEnded(x, y)
    self.sp:runAction(sequence({scaleto(0.05, 1.2, 1.2), scaleto(0.05, 1, 1)}))
    self.scene:comeToMon(self)
end
function CaveMonster:touchMoved(x, y)
end
