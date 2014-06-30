-- cclog
cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    local err = "LUA ERROR: " .. tostring(msg) .. "\n"
    err = err..debug.traceback()
    print(err)
    print("----------------------------------------")
    
    --sendReq('synError', dict({{"error", err}})) 
end

OldPrint = print
function print(...)
    --if DEBUG then
        OldPrint(...)
    --end
end


local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    ---------------
    require "Global.INCLUDE"
    --require "Miao.Logic"
    --require "Miao.MiaoScene"
    --require "Miao.TMXScene"

    --require "myMap.MapScene"
    --require 'Miao.FightScene'
    --require 'myMap.FightMap'
    --require "Miao.TestSea"
    --require "TestScene"
    --require "ThreeScene"

    require "Demo.BattleScene"
    local director = CCDirector:sharedDirector()

    --[[
    local sc = TMXScene.new()
    director:replaceScene(sc.bg)
    global.director:onlyRun(sc)
    --]]
    --local sc = TestScene.new()
    local sc = BattleScene.new()
    --director:runWithScene(sc.bg)
    --global.director:onlyRun(sc)
    global.director:runWithScene(sc)
    
    --[[
    local sc = FightScene.new()
    director:replaceScene(sc.bg)
    global.director:onlyRun(sc)
    --]]

    --[[
    local sc = FightMap.new()
    director:replaceScene(sc.bg)
    global.director:onlyRun(sc)
    --]]

    --require "Menu.TestMenu"
    --global.director:runWithScene(TestMenu.new())
    
    --global.director:runWithScene(MapScene.new())

end

xpcall(main, __G__TRACKBACK__)
