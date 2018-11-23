local createClass = require 'src/createClass'

-- This is the base class for all game entities
local Entity = createClass({
  constructor = function(self) end,
  update = function(self, dt) end,
  draw = function(self) end
})

return Entity
