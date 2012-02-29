require './lib/registerable'

class Action
  include Registerable

  def initialize(name, &block)
    @name = name
    @block = block
    register
  end


  def interpretation
    @block
  end

  def has_default? 
    !!interpretation
  end
end

module Kernel
  def action(*args, &block)
    Action.new(*args, &block)
  end
end
