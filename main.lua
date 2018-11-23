local Entity = require 'src/Entity'
local Puzzle = require 'src/Puzzle'
local PUZZLES = require 'src/puzzles'

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
    y = 100,
    puzzleData = PUZZLES[1]
  })
end

function love.update(dt)
  -- Update all entities
  local index, entity
  for index, entity in ipairs(entities) do
    entity:update(dt)
  end
end

function love.draw()
  -- Draw all entities
  local index, entity
  for index, entity in ipairs(entities) do
    entity:draw()
  end
end
