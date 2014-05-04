TestF = class()
function TestF:ctor()
    self.bg = CCScene:create()
    local n = setPos(addNode(self.bg), {300, 300})
    self.sp = addChild(n, createSprite("m0.png"))

    self.needUpdate = true
    registerEnterOrExit(self)

    local f = simple.decode(getFileData("stretch.ExportJson"))
    local ad = f['animation_data'][1]['mov_data'][1]['mov_bone_data'][1]['frame_data']
    self.frameData = ad
    --print(ad)
    self.maxNum = ad[#ad]["fi"]
    print(self.maxNum)

    self.passTime = 0
    self.ftime = 0.1
end

function TestF:update(diff)
    self.passTime = self.passTime+diff
    local fi = self.passTime/self.ftime
    if fi > self.maxNum then
        return
    end
    
    local keys = {'x', 'y', 'cX', 'cY', 'kX', 'kY'}
    local res = {}
    for k, v in ipairs(self.frameData) do
        if v['fi'] > fi then
            local of = self.frameData[k-1]
            local nf = v
            for _, ky in ipairs(keys) do
                local kv = linearInter(of[ky], nf[ky], of['fi'], nf['fi'], fi) 
                res[ky] = kv
            end
            break
        elseif v['fi'] == fi then
            local nf = v
            for _, ky in ipairs(keys) do
                local kv = nf[ky] 
                res[ky] = kv
            end
            break
        end
    end
    
    --  -sin matrix radian conver to degress in game  
    --causion: clock direction
    --  -sin  
    local deg = math.asin(res['kX'])*180/math.pi
    print("deg ", res['kX'], deg)
    setRotation(setScaleY(setScaleX(setPos(self.sp, {res['x'], res['y']}), res['cX']), res['cY']), deg)

end


