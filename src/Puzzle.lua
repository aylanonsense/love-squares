local createClass = require 'src/createClass'
local Entity = require 'src/Entity'
local PuzzleTile = require 'src/PuzzleTile'

local Puzzle = createClass({
  constructor = function(self)
    self.tiles = {}
    -- Create tiles by iterating through puzzle data
    local index, char
    local col = 0
    local row = 1
    for index = 1, #self.puzzleData do
      local char = string.sub(self.puzzleData, index, index)
      if char == '\n' then
        row = row + 1
        col = 0
      else
        col = col + 1
      end
      if char ~= ' ' and char ~= '\n' then
        self:createTile({
          puzzle = self,
          x = 50 * col - 50,
          y = 50 * row - 50,
          value = tonumber(char)
        })
      end
    end
  end,
  update = function(self, dt)
    -- Update all tiles
    local index, tile
    for index, tile in ipairs(self.tiles) do
      tile:update(dt)
    end
  end,
  draw = function(self)
    -- Draw all tiles
    local index, tile
    for index, tile in ipairs(self.tiles) do
      tile:draw()
    end
  end,
  -- Create a new tile and add it to the puzzle
  createTile = function(self, args)
    local tile = PuzzleTile.new(args)
    table.insert(self.tiles, tile)
    return tile
  end
}, Entity)

return Puzzle
