function os.exist(_data)
    if os.rename(_data, _data) then return _data 
    else
        return false
    end
end

function os.getDirItems(_dir, _method)
    assert(type(_dir) ==  'string', "bad argument to #1 in function 'io.getDirItems' (string expected got a " .. type(_dir) .. ")")
    local _f, _t = io.popen((_method or 'ls') .. ' ' .. (_dir or '.')), {}
    
    for _ in _f:lines() do if _ ~= '.' or '..' then table.insert(_t, _) end end
    
    _f:close()
    
    if #_t == 1 then
        for _ in tostring(_t[1]):gmatch('([^' .. (_split or '%s') .. ']+)') do table.insert(_t, _) end
        
        table.remove(_t, 1)
    end
    
    return _t
end

-- function os.capture(_cmd, _raw)
--     local _f = assert(io.popen(_cmd, 'r'))
--     local _s = assert(_f:read('*a'))
--     _f:close()
--     
--     if _raw then return _s else
--         _s = string.gsub(_s, '^%s+', '')
--         _s = string.gsub(_s, '%s+$', '')
--         _s = string.gsub(_s, '[\n\r]+', ' ')
--         return _s
--     end
-- end

function os.getCurrentOs()
    local _bin = package.cpath:match("%p[\\|/]?%p(%a+)")
    
    if _bin == 'dll' then return 'windows'
    elseif _bin == 'so' then return 'linux'
    elseif _bin == 'dylib' then return 'macOS'
    else return 'unknow' end
end

return os