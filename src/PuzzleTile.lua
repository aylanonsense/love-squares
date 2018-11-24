local createClass = require 'src/createClass'
local Entity = require 'src/Entity'

local FONT = love.graphics.newFont(36)
local TILE_COLORS = {
  [0] = { 0.914, 0.437, 0.007, 1.0 },
  [1] = { 0.019, 0.621, 0.863, 1.0 },
  [2] = { 0.886, 0.792, 0.000, 1.0 },
  [3] = { 0.593, 0.812, 0.000, 1.0 },
  [4] = { 0.960, 0.039, 0.269, 1.0 },
  CLEARED = { 0.4, 0.4, 0.4, 1.0 }
}

local PuzzleTile = createClass({
  isCleared = false,
  draw = function(self)
    local x = self.puzzle.x + self.x
    local y = self.puzzle.y + self.y
    -- Draw rectangle
    love.graphics.setColor(self.isCleared and TILE_COLORS.CLEARED or TILE_COLORS[self.value])
    love.graphics.rectangle('fill', x, y, self.tileSize, self.tileSize)
    -- Draw value text
    if not self.isCleared then
      love.graphics.setFont(FONT)
      love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
      love.graphics.print(self.value, x + 18, y + 10)
    end
  end,
  getValue = function(self)
    if self.isCleared then
      return 0
    else
      return self.value
    end
  end,
  clear = function(self)
    self.isCleared = true
  end,
  reset = function(self)
    self.isCleared = false
  end
}, Entity)

return PuzzleTile
