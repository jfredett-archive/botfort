require './lib/registerable'

class Action
  include Registerable

  def initialize(name, &block)
    @name = name
    @block = block
    register
  end
end

module Kernel
  def action(*args, &block)
    Action.new(*args, &block)
  end
end
