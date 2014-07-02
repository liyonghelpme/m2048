Arrow = class()
function Arrow:ctor(x0, y0, x3, y3)
    self.bg = CCNode:create()
    self.changeDirNode = CCSprite:create("archer_3.png")
    addChild(self.bg, self.changeDirNode)
    
    local x1 = x0+(x3-x0)*0.3 
    local y1 = (y0+y3)/2+100
    local x2 = x0+(x3-x0)*0.6
    local y2 = (y0+y3)/2+100
    
    setScale(self.changeDirNode, 0.5)
    
    self.changeDirNode:runAction(bezierto(1, x0, y0, x1, y1, x2, y2, x3, y3))
    self.bg:runAction(sequence({delaytime(1), callfunc(nil, removeSelf, self.bg)}))
    self.lastPos = {x0, y0}
    
    self.needUpdate = true
    registerEnterOrExit(self)
end

function Arrow:update(diff)
    local newPos = getPos(self.changeDirNode)
    local oldPos = self.lastPos
    self.lastPos = newPos
    local dx = newPos[1]-oldPos[1]
    local dy = newPos[2]-oldPos[2]
    local dir = math.atan2(dy, dx)

    setRotation(self.changeDirNode, -(dir*180/math.pi))

end
