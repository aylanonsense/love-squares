local PuzzleTile = require 'src/PuzzleTile'

-- Entity vars
local entities

function spawnEntity(class, args)
  local entity = class.new(args)
  table.insert(entities, entity)
  return entity
end

function love.load()
  entities = {}
  spawnEntity(PuzzleTile, {
    x = 200,
    y = 100,
    value = 3
  })
end

function love.update(dt)
end

function love.draw()
  local index, entity
  for index, entity in ipairs(entities) do
    entity:draw()
  end
end
