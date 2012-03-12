require './lib/registerable'

class Advice
  include Registerable

  attr_reader :name
  attr_reader :actions

  def initialize(name)
    @name = name
    register
  end
end

module Kernel
  def advice(name)
    Advice.new(name)
  end

  def advise(*_)

  end
end
