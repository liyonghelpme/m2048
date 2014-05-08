ParScene  = class()
function ParScene:ctor()
    self.bg = CCScene:create()
    self.layer = ParLayer.new()
    self.bg:addChild(self.layer.bg)
end


ParLayer = class()
function ParLayer:ctor()
    self.bg = CCLayer:create()
    self.needUpdate = true
    registerEnterOrExit(self)
    
    self.particle = CCParticleGalaxy:create() 
    self.bg:addChild(self.particle)
    setPos(self.particle, {300, 200})

    local function initFunc(obj)
        local func = self.particle['get'..obj.text]
        local num = func(self.particle)
        obj:setText(num)
    end

    print("init layer over")
    self.uiLayer = addNode(self.bg)
    local duration = ui.newEditBox({image="round.png", delegate=self, listener=self.onBut, size={100, 40}, text="Duration", initFunc=initFunc})
    setPos(addChild(self.uiLayer, duration), {800, 550})
    duration:setZoomOnTouchDown(true)
    duration:setFontColor(ccc3(0, 0, 0))
    duration:setPlaceHolder("duration")
    self.duration = duration


    local duration = ui.newEditBox({image="round.png", delegate=self, listener=self.onBut, size={100, 40}, text="ParticleCount", initFunc=initFunc})
    setPos(addChild(self.uiLayer, duration), {800, 500})
    duration:setZoomOnTouchDown(true)
    duration:setFontColor(ccc3(0, 0, 0))
    duration:setPlaceHolder("Count")
    self.count = duration

end

function ParLayer:onBut(event, object)
    print("onBut", event, object.text)
    if event == "ended" then
        --local text = object.text
        local d = object:getText()
        local num = simple.decode(d)
        print("num is", num)
        local func = self.particle['set'..object.text]
        print("func", func)
        func(self.particle, num)

        --self.particle:setDuration(num)
        self.particle:resetSystem()
    end
end

--[[
function ParLayer:onduration(event, object)
    print("onduraction", event, object)
    if event == "ended" then
        local d = self.duration:getText()
        local num = simple.decode(d)
        print("num is", num)
        self.particle:setDuration(num)
        self.particle:resetSystem()
    end
end

function ParLayer:onCount(event, object)
    if event == "ended" then
        local d = self.duration:getText()
        local num = simple.decode(d)
        local n = self.particle:getParticleCount()
        print("num is", n, num)

        self.particle:setParticleCount(num)
        self.particle:resetSystem()
    end
end
--]]

function ParLayer:update(diff)
end


