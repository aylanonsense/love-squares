local createClass = require 'src/createClass'
local Entity = require 'src/Entity'
local PuzzleTile = require 'src/PuzzleTile'

local TILE_MODIFIERS = {
  ['+'] = 'hasStickyValue'
}

local Puzzle = createClass({
  constructor = function(self)
    self.tiles = {}
    self.tileGrid = {}
    self.tileSize = 60
    self.tilePadding = 10
    self.gridWidth = 0
    self.gridHeight = 0
    self.highlightCol = nil
    self.highlightRow = nil
    -- Create tiles by iterating through puzzle data
    local index, char
    local col = 0
    local row = 1
    local modifiers = {}
    for index = 1, #self.puzzleData do
      local char = string.sub(self.puzzleData, index, index)
      if char ~= '.' then
        if TILE_MODIFIERS[char] then
          table.insert(modifiers, TILE_MODIFIERS[char])
        else
          if char == '\n' then
          row = row + 1
            col = 0
          else
            col = col + 1
          end
          if char ~= ' ' and char ~= '\n' then
            local props = {
              puzzle = self,
              tileSize = self.tileSize,
              x = (self.tileSize + self.tilePadding) * (col - 1),
              y = (self.tileSize + self.tilePadding) * (row - 1),
              value = tonumber(char)
            }
            local index, modifier
            for index, modifier in ipairs(modifiers) do
              props[modifier] = true
            end
            modifiers = {}
            self:createTile(props, col, row)
            self.gridWidth = math.max(col, self.gridWidth)
            self.gridHeight = math.max(row, self.gridHeight)
          end
        end
      end
    end
  end,
  update = function(self, dt)
    -- Highlight a 2x2 area of the puzzle
    local mouseX, mouseY = love.mouse.getPosition()
    local col, row = self:toTilePosition(mouseX, mouseY)
    self:highlight(col - 0.5, row - 0.5)
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
      love.graphics.setLineWidth(self.tilePadding)
      local x = self.x + self.tileSize * (self.highlightCol - 1) + self.tilePadding * (self.highlightCol - 1.5)
      local y = self.y + self.tileSize * (self.highlightRow - 1) + self.tilePadding * (self.highlightRow - 1.5)
      local size = 2 * self.tileSize + 2 * self.tilePadding
      love.graphics.rectangle('line', x, y, size, size)
    end
  end,
  onClick = function(self, mouseX, mouseY)
    local col, row = self:toTilePosition(mouseX, mouseY)
    self:highlight(col - 0.5, row - 0.5)
    if self:hasHighlight() then
      if self:getAreaSum(self.highlightCol, self.highlightRow) == 4 then
        self:clearArea(self.highlightCol, self.highlightRow)
        self:dehighlight()
      end
    end
  end,
  toTilePosition = function(self, x, y)
    local col = 1 + (x - self.x + self.tilePadding / 2) / (self.tilePadding + self.tileSize)
    local row = 1 + (y - self.y + self.tilePadding / 2) / (self.tilePadding + self.tileSize)
    return col, row
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
  getTile = function(self, col, row)
    return self.tileGrid[col][row]
  end,
  tileExists = function(self, col, row)
    return self.tileGrid[col] and self.tileGrid[col][row]
  end,
  areaExists = function(self, col, row)
    return self:tileExists(col, row) and self:tileExists(col, row + 1) and self:tileExists(col + 1, row) and self:tileExists(col + 1, row + 1)
  end,
  getAreaSum = function(self, col, row)
    return self:getTile(col, row):getValue() + self:getTile(col, row + 1):getValue() + self:getTile(col + 1, row):getValue() + self:getTile(col + 1, row + 1):getValue()
  end,
  clearArea = function(self, col, row)
    self:getTile(col, row):clear()
    self:getTile(col, row + 1):clear()
    self:getTile(col + 1, row):clear()
    self:getTile(col + 1, row + 1):clear()
  end,
  isFullyCleared = function(self)
    local index, tile
    for index, tile in ipairs(self.tiles) do
      if not tile.isCleared then
        return false
      end
    end
    return true
  end,
  reset = function(self)
    local index, tile
    for index, tile in ipairs(self.tiles) do
      tile:reset()
    end
  end,
  -- Highlight a 2x2 area of the grid that the player is hovering over
  highlight = function(self, col, row)
    col = math.floor(col)
    row = math.floor(row)
    if self:areaExists(col, row) then
      self.highlightCol = col
      self.highlightRow = row
    else
      self:dehighlight()
    end
  end,
  dehighlight = function(self)
    self.highlightCol = nil
    self.highlightRow = nil
  end,
  hasHighlight = function(self)
    return self.highlightCol and self.highlightRow
  end
}, Entity)

return Puzzle
