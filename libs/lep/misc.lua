function toboolean(_var)
    if _var == 'true' or tonumber(_var) == 1 or _var then return true
    elseif _var == 'false' or tonumber(_var) == 0 or not _var then return false 
    else error("sorry " .. type(_var) .. " value can't be convert into a boolean") end
end

function inverter(_bool)
    if _bool then return false
    else return true end
end

function switch(_caseTable, _expression)
    local _case = _caseTable[tostring(_expression)]
    
    if _case then return _case() or _case
    else return _caseTable.default() or _caseTable.default end
end

function pack(_method, ...)
    if _method == 'table' then return {...}
    else return (...) end
end 

function newClass(_items)
    --#error tratament--
    assert(type(_items) == 'table', "bad argument #1 to 'class.new' (table expected got a " .. type(_items) .. ")")
    --#cmds--
    local _class = _items
    setmetatable(_class, self)
    getmetatable(_class).__index = self
    return _class
end

return switch, toboolean, pack, newClass