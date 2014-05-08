FuncSkill = class()
function FuncSkill:ctor(s)
    self.skill = s
end
function FuncSkill:checkEnable()
end
function FuncSkill:showAttack()
end
function FuncSkill:doAttack(m)
end
--攻击怪兽 还是 治愈 我方
function FuncSkill:checkAttackMon(m)
    return m.kind == 1
end

--每个技能检查当前色子是否可能释放
function FuncSkill:checkPossible(d)
    return false
end



