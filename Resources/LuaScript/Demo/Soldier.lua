
--[[
local function adjustXPos(self)
    local minX = 9999
    local minFriend
    local minDy 
    local myPos = getPos(self.bg)
end
--]]

local DIFY = 40
local DIFX = 40
local ATTACK_RANGE = 70

--防止太密集
local function adjustYPos(self)
    --print("adjustYPos", self)

    --x 方向最近的 Y 上太靠近的士兵 调整一下我方的 Y值
    --固定值调整 +20
    local minX = 9999
    local minFriend
    local minDy
    local myPos = getPos(self.bg)

    for k, v in ipairs(self.myTeam) do
        if v ~= self then
            local friPos = getPos(v.bg)
            local dist = friPos[1]-myPos[1]
            local dy = friPos[2]-myPos[2]
            print("dist dy", self.name, dist, dy, self.dir)
            --Y distance < 20
            if math.abs(dy) < DIFY and dist * self.dir > 0 then
                if math.abs(dist) < math.abs(minX) then
                    minX = dist
                    minDy = dy
                    minFriend = v
                end
            end
        end
    end

    if minFriend ~= nil then
        setZord(self)

        print("adjust Y pos")
        local sign = getSign(-minDy) 
        if sign == 0 then
            sign = 1
        end
        local movey = sign*50*self.diff
        setPos(self.bg, {myPos[1], myPos[2]+movey})
        --距离太小则抵消掉移动X 方向
        if math.abs(minX) < DIFX then
            setPos(self.bg, {myPos[1]-self.moveX, myPos[2]+movey})
        end
    end
end


--move and adjust X Y value
local function moveToTarget(self)
    self.changeDirNode:getAnimation():play("run")
    while true do
        --print("start Move")
        local myPos = getPos(self.bg)
        local enePos = getPos(self.target.bg)
        local dir = enePos[1]-myPos[1]
        self.dir = getSign(dir)

        local dist = math.abs(dir)
        local sign = getSign(dir) 
        if dist < ATTACK_RANGE then
            break
        else
            --after move then adjust Y pos
            local mv = self.diff*100*sign
            self.moveX = mv
            setPos(self.bg, {myPos[1]+mv, myPos[2]})
            --print('start adjust')
            --bug: lua
            --当local 函数声明在 这个函数 之后的时候 无法调用 adjustPos 这个函数
            adjustYPos(self)
            --adjustXPos(self)
        end
        coroutine.yield()
    end
end




local function findEnemy(self, enemy)
    local dist = 99999
    local myPos = getPos(self.bg)
    local minEne
    for k, v in ipairs(enemy) do
        local enePos = getPos(v.bg)
        local ed = math.abs(enePos[1]-myPos[1])
        if ed < dist then
            dist = ed
            minEne = v
        end
        coroutine.yield()
    end
    self.target = minEne
end


--移动肯定有问题 正在移动的时候 突然对方出现了一个士兵怎么办?
--战场上面其实已经站立了多个
local function findMoveAttack(self)
    setZord(self)

    local enemy 
    if self.color == 0 then
        enemy = self.scene.enemyTeam
    else
        enemy = self.scene.myTeam
    end

    while true do
        if #enemy > 0 then
            --local rd = math.random(#enemy)
            findEnemy(self, enemy)

            --move to near soldier
            moveToTarget(self)
            --adjustXPos(self)
            --adjustYPos(self)
            
            --attack again
            while true do
                self.attackOver = false
                --print("attack again")
                self.changeDirNode:getAnimation():play("attack")
                while true do
                    if self.attackOver then
                        --print("soldier attack over")
                        break
                    end
                    coroutine.yield()
                end
                --print("play wait animation")
                
                --self.changeDirNode:getAnimation():play("wait")
                self.target:doHarm()
                coroutine.yield()
            end
        end
        coroutine.yield()
    end

end


Soldier = class()
function Soldier:ctor(s, hid, col)
    self.scene = s
    self.kind = hid
    self.color = col
    self.name = math.random()
    self.health = 100

    if self.color == 0 then
        self.myTeam = self.scene.myTeam
    else
        self.myTeam = self.scene.enemyTeam
    end

    self.bg = CCNode:create()

    local spc = CCSpriteFrameCache:sharedSpriteFrameCache()
    local st = string.format("userDogface_%d_3/userDogface_%d_3.plist", hid, hid)
    spc:addSpriteFramesWithFile(st)
    local st = string.format("userDogface_%d_3/userDogface_%d_3.json", hid, hid)
    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(st)
    self.changeDirNode = CCArmature:create("userDogface_"..hid.."_3")
    addChild(self.bg, self.changeDirNode)
    setScale(self.changeDirNode, 0.5)
    self.changeDirNode:getAnimation():setSpeedScale(0.5)

    local function moveEvent(me, t, s)
        --print('moveevent', me, t, s)
        --0 start
        --1 complete
        --2 loop complete
        if (t == 1 or t == 2) and s == 'attack' then
            self:onAttackOver()
        end
    end

    self.changeDirNode:getAnimation():play("wait")
    self.changeDirNode:getAnimation():setMovementEventCallFunc(moveEvent)

    self.needUpdate = true
    self.state = 0
    registerEnterOrExit(self)

    self.attackProcess = coroutine.create(findMoveAttack)
end

function Soldier:update(diff)
    self.diff = diff
    if self.scene.state == 1 then
        coroutine.resume(self.attackProcess, self) 
    end
end

function Soldier:onAttackOver()
    self.attackOver = true
end

function Soldier:doHarm()
    local lab = ui.newTTFLabel({text='5', size=30, color={154, 12, 12}})
    setPos(addChild(self.bg, lab), {0, 50})
    lab:runAction(sequence({fadein(0.2), fadeout(0.2), callfunc(nil, removeSelf, lab)}))

    self.health = self.health-5

    --Event:sendMsg("HERO_DAMAGE", self)
end


