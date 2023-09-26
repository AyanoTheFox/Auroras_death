map = {}

function map:new(_mapFile)
    local _map = json.decode(_mapFile)
    setmetatable(_map, self)
    self.__index = self
    return _map
end

function map:draw(_tiles)
    for _ = 0, #self.blocks do
        love.graphics.draw(_tiles.sheet,
            _tiles.quads[self.blocks[_].texture.id],
            self.blocks[_].x,
            self.blocks[_].y
        )
    end
end

return map