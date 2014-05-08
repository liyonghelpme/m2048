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

