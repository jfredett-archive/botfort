require './lib/registerable'

class Action
  include Registerable
  extend Forwardable

  def initialize(name, &block)
    @name = name
    @block = block
    register
  end

  delegate :call => :interpretation

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
