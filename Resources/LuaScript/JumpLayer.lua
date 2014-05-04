JumpLayer = class()
function JumpLayer:ctor()
    self.bg = CCLayer:create()
    local am = CCArmatureDataManager:sharedArmatureDataManager()
    am:addArmatureFileInfo("NewAnimation.ExportJson")
    local ar = CCArmature:create("NewAnimation")
    ar:setTag(1)
    local cp = ar:convertToNodeSpaceAR(ccp(100, 100))
    ar:setScale(0.3)
    ar:getAnimation():playWithIndex(0)
    
    addChild(self.bg, ar)
    setPos(ar, {300, 300})
end
