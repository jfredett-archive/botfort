require './lib/registerable'

class Advice
  include Registerable

  attr_reader :name, :actions

  def initialize(name)
    @name = name
    register
  end
end

module Kernel
  def advice(name, &block)
    Advice.new(name, &block)
  end

  def advise(*_)

  end
end
