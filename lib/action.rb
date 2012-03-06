require './lib/registerable'
require './lib/exceptions'

class Action
  include Registerable
  extend Forwardable

  def initialize(name, &block)
    @name = name
    @block = block
    @has_default = !!block
    register
  end

  delegate :call => :interpretation

  def interpretation
    @block || proc { |n| raise Agent::ActionNotUnderstood.new(n) } 
  end

  def has_default? 
    @has_default
  end
end


module Kernel
  def action(*args, &block)
    Action.new(*args, &block)
  end
end
