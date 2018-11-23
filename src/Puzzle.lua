local createClass = require 'src/createClass'
local Entity = require 'src/Entity'
local PuzzleTile = require 'src/PuzzleTile'

local Puzzle = createClass({
  constructor = function(self)
    self.tiles = {}
    self.tileGrid = {}
    self.tileSize = 60
    self.tilePadding = 2
    self.gridWidth = 0
    self.gridHeight = 0
    self.highlightCol = nil
    self.highlightRow = nil
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
          tileSize = self.tileSize,
          x = (self.tileSize + self.tilePadding) * (col - 1),
          y = (self.tileSize + self.tilePadding) * (row - 1),
          value = tonumber(char)
        }, col, row)
        self.gridWidth = math.max(col, self.gridWidth)
        self.gridHeight = math.max(row, self.gridHeight)
      end
    end
  end,
  update = function(self, dt)
    -- Highlight 
    local mouseX, mouseY = love.mouse.getPosition()
    local highlightCol = math.min(math.max(1, math.floor((mouseX - self.x) / self.tileSize + 0.5)), self.gridWidth - 1)
    local highlightRow = math.min(math.max(1, math.floor((mouseY - self.y) / self.tileSize + 0.5)), self.gridHeight - 1)
    self:highlight(highlightCol, highlightRow)
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
    -- Draw highlight
    if self:hasHighlight() then
      love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
      love.graphics.setLineWidth(self.tilePadding + 2)
      local x = self.x + self.tileSize * (self.highlightCol - 1) + self.tilePadding / 2
      local y = self.y + self.tileSize * (self.highlightRow - 1) + self.tilePadding / 2
      local size = 2 * self.tileSize + 2 * self.tilePadding
      love.graphics.rectangle('line', x, y, size, size)
    end
  end,
  -- Create a new tile and add it to the puzzle
  createTile = function(self, args, col, row)
    local tile = PuzzleTile.new(args)
    table.insert(self.tiles, tile)
    if not self.tileGrid[col] then
      self.tileGrid[col] = {}
    end
    self.tileGrid[col][row] = tile
    return tile
  end,
  -- Highlight a 2x2 area of the grid that the player is hovering over
  hasHighlight = function(self)
    return self.highlightCol and self.highlightRow
  end,
  highlight = function(self, col, row)
    self.highlightCol = col
    self.highlightRow = row
  end,
  dehighlight = function(self)
    self.highlightCol = nil
    self.highlightRow = nil
  end
}, Entity)

return Puzzle
