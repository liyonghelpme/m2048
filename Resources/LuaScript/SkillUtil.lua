function sameEnable(num, dices)
    local count = {}
    for i=1,6,1 do
        local d = dices[i]
        if d.sel  then
            table.insert(count, d.value)
            if #count > num then
                break
            end
        end
    end
    --sort
    if #count == num then
        --table.sort(count) 
        local ok = true
        for i=2, num, 1 do
            if count[i] ~= count[1] then
                return false
            end
        end
        return true
    else
        return false
    end
end


