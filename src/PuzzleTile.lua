local createClass = require 'src/createClass'
local Entity = require 'src/Entity'

return createClass({
  draw = function(self)
    -- Draw rectangle
    love.graphics.setColor(0.4, 0.4, 1.0, 1.0)
    love.graphics.rectangle('fill', self.x, self.y, 20, 20)
    -- Draw values text
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    love.graphics.print(self.value, self.x + 5, self.y + 5)
  end
}, Entity)
