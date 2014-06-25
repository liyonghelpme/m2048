BattleScene = class()
function BattleScene:ctor()
    self.bg = CCScene:create()
    self.layer = BattleLayer.new()
    addChild(self.bg, self.layer.bg)
end


BattleLayer = class()
function BattleLayer:ctor()
    self.bg = CCLayer:create()
    local sp = CCSprite:create("bbg_cave_hall.jpg")
    local vs = getVS()
    setPos(addChild(self.bg, sp), {vs.width/2, vs.height/2})

    local spc = CCSpriteFrameCache:sharedSpriteFrameCache()
    spc:addSpriteFramesWithFile("userRole/userRole.plist")

    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("userRole/userRole.json")

    local hero = CCArmature:create("userRole")
    hero:getAnimation():playWithIndex(0)
    self.bg:addChild(hero)
    setPos(hero, {88, vs.height-134})
    hero:setScale(0.5)

end


