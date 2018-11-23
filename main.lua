-- local blah = require 'blah'
-- local bloo = 1

local Puzzle = require 'src/Puzzle'

local test = Puzzle.new({ health = 5 })

local debugText = "xxx"

function love.load()
  printx = 0
  printy = 0
  print("hi")
  print(test.health)
  test:blah()
  print(test.health)
end

function love.update(dt)
end

function love.draw()
  love.graphics.setColor(0.4, 0.4, 1.0, 1.0)
  love.graphics.circle("fill", 100, 100, 20, 32)
  love.graphics.print("Text"..printx, printx, printy)
  love.graphics.print(debugText, 20, 20)
end

function love.mousepressed(x, y, button, istouch)
   if button == 1 then
      printx = x
      printy = y
   end
end

function love.mousereleased(x, y, button, istouch)
   if button == 1 then
      printx = x
      printy = y
   end
end
