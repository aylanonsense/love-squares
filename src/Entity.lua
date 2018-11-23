local createClass = require 'src/createClass'

return createClass({
  blah = function(self)
    self.health = self.health - 2
  end
})
