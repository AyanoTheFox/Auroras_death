local LIP = {};

--- Returns a table containing all the data from the INI file.
--@param fileName The name of the INI file to parse. [string]
--@return The table containing all data from the INI file. [table]
function LIP.load(fileName)
    assert(type(fileName) == 'string', 'Parameter "fileName" must be a string.');
    local lovefile = love.filesystem.newFile(fileName)
    local file = assert(lovefile:open('r'), 'Error loading file : ' .. fileName);
    local data = {};
    local section;
    for line in love.filesystem.lines(fileName) do
        local tempSection = line:match('^%[([^%[%]]+)%]$');
        if(tempSection)then
            section = tonumber(tempSection) and tonumber(tempSection) or tempSection;
            data[section] = data[section] or {};
        end
        local param, value = line:match('^([%w|_]+)%s-=%s-(.+)$');
        if(param and value ~= nil)then
            if(tonumber(value))then
                value = tonumber(value);
            elseif(value == 'true')then
                value = true;
            elseif(value == 'false')then
                value = false;
            end
            if(tonumber(param))then
                param = tonumber(param);
            end
            data[section][param] = value;
        end
    end
    lovefile:close();
    return data;
end

--- Saves all the data from a table to an INI file.
--@param fileName The name of the INI file to fill. [string]
--@param data The table containing all the data to store. [table]
function LIP.save(fileName, data)
    assert(type(fileName) == 'string', 'Parameter "fileName" must be a string.');
    assert(type(data) == 'table', 'Parameter "data" must be a table.');
    local lovefile = love.filesystem.newFile(fileName)
    local file = assert(lovefile:open('w+b'), 'Error loading file :' .. fileName);
    local contents = '';
    for section, param in pairs(data) do
        contents = contents .. ('[%s]\r\n'):format(section);
        for key, value in pairs(param) do
            contents = contents .. ('%s=%s\r\n'):format(key, tostring(value));
        end
        contents = contents .. '\r\n';
    end
    lovefile:write(contents);
    lovefile:close();
end

return LIP;