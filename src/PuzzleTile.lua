local createClass = require 'src/createClass'
local Entity = require 'src/Entity'

local PuzzleTile = createClass({
  draw = function(self)
    local x = self.puzzle.x + self.x
    local y = self.puzzle.y + self.y
    -- Draw rectangle
    love.graphics.setColor(0.4, 0.4, 1.0, 1.0)
    love.graphics.rectangle('fill', x, y, 45, 45)
    -- Draw value text
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    love.graphics.print(self.value, x + 5, y + 5)
  end
}, Entity)

return PuzzleTile
