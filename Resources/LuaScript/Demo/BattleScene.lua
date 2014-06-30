require "Demo.BattleMenu"
require "Demo.Hero2"
require "Demo.mycor"

BattleScene = class()
function BattleScene:ctor()
    self.bg = CCScene:create()
    self.layer = BattleLayer.new()
    addChild(self.bg, self.layer.bg)
end

local function battleProgress(self)
    local vs = getVS()
    local la = ui.newTTFLabel({text="3", size=100, color={42, 154, 12}})
    setPos(addChild(self.bg, la), {vs.width/2, vs.height/2})
    la:setOpacity(255)
    la:runAction(sequence({fadein(0.5), fadeout(0.5)}))
    waitForTime(self, 1)
    
    --[[
    la:setString("2")
    la:runAction(sequence({fadein(0.5), fadeout(0.5)}))
    waitForTime(self, 1)

    la:setString("1")
    la:runAction(sequence({fadein(0.5), fadeout(0.5)}))
    waitForTime(self, 1)
    --]]

    self.state = 1
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
    
    --[[
    local hero = CCArmature:create("userRole")
    hero:getAnimation():playWithIndex(0)
    self.bg:addChild(hero)
    setPos(hero, {88, vs.height-134})
    hero:setScale(0.5)
    self.hero = hero
    --]]

    self.myTeam = {}
    self.enemyTeam = {}

    self.hero = Hero.new(self, 0)
    setPos(addChild(self.bg, self.hero.bg), {88, vs.height/2})
    table.insert(self.myTeam, self.hero)

    self.enemy = Hero.new(self, 1)
    setPos(addChild(self.bg, self.enemy.bg), {vs.width-88, vs.height/2})
    table.insert(self.enemyTeam, self.enemy)
    
    --[[
    spc:addSpriteFramesWithFile("enemy_1/enemy_1.plist")
    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("enemy_1/enemy_1.json")
    local enemy = CCArmature:create("enemy_1")
    enemy:getAnimation():playWithIndex(0)
    self.bg:addChild(enemy)
    setPos(enemy, {vs.width-88, vs.height-134})
    enemy:setScale(0.5)
    enemy:setScaleX(-0.5)
    --]]

    self.state = 0

    self.needUpdate = true
    self.inTouch = false
    registerTouch(self)
    registerEnterOrExit(self)
    
    self.co = coroutine.create(battleProgress)

    self.updateInfo = coroutine.create(updateInfo)

    self.menu = BattleMenu.new(self)
    addChild(self.bg, self.menu.bg)


end

function updateInfo(self)
    while true do
        print("myt", #self.myTeam, #self.enemyTeam)
        waitForTime(self, 1)
    end
end


function BattleLayer:touchBegan(x, y)
    print("touch began")
    self.inTouch = true
    self.touchPos = {x, y}
    return true
end
function BattleLayer:touchMoved(x, y)
    self.touchPos = {x, y}
end
function BattleLayer:touchEnded(x, y)
    print("touch ended")
    self.inTouch = false
end



function BattleLayer:update(diff)
    self.diff = diff
    local res, err = coroutine.resume(self.co, self)    

    local res, err = coroutine.resume(self.updateInfo, self)
    if not res then
        print(err)
    end
end



