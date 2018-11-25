local Entity = require 'src/Entity'
local Puzzle = require 'src/Puzzle'
local PUZZLES = require 'src/puzzles'

local PUZZLE_TITLE_FONT = love.graphics.newFont(36)
local PUZZLE_DESCRIPTION_FONT = love.graphics.newFont(18)

-- Game vars
local puzzleIndex = 1

-- Entity vars
local entities
local puzzle

-- Add a spawn function to the Entity class
Entity.spawn = function(class, args)
  local entity = class.new(args)
  table.insert(entities, entity)
  return entity
end

function love.load()
  -- Initialize game vars
  entities = {}
  -- Spawn initial entities
  puzzle = Puzzle:spawn({
    x = 200,
    y = 200,
    puzzleData = PUZZLES[puzzleIndex]
  })
end

function love.update(dt)
  -- Update all entities
  local index, entity
  for index, entity in ipairs(entities) do
    entity:update(dt)
  end
  -- Move on to the next puzzle
  if puzzle:isFullyCleared() and puzzleIndex <= 9 then
    puzzleIndex = puzzleIndex + 1
    puzzle:die()
    puzzle = Puzzle:spawn({
      x = 200,
      y = 200,
      puzzleData = PUZZLES[puzzleIndex]
    })
  end
  -- Remove dead entities (I am confident I can find a better way to do this)
  local newEntities = {}
  for index, entity in ipairs(entities) do
    if entity.isAlive then
      table.insert(newEntities, entity)
    end
  end
  entities = newEntities
end

function love.draw()
  -- Draw the puzzle number
  love.graphics.setFont(PUZZLE_TITLE_FONT)
  love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
  love.graphics.print('Puzzle '..puzzleIndex, 150, 100)
  love.graphics.setFont(PUZZLE_DESCRIPTION_FONT)
  love.graphics.print('Clear 2x2 areas that sum to 4', 150, 140)
  love.graphics.print('(Press spacebar to reset puzzle)', 150, 160)
  -- Draw all entities
  local index, entity
  for index, entity in ipairs(entities) do
    entity:draw()
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    puzzle:onClick(x, y)
  end
end

function love.keypressed(key, isrepeat)
  if key == 'space' then
    puzzle:reset()
  end
end
