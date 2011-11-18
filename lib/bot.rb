require './lib/registerable'
require 'forwardable'

class Bot 
  include Registerable
  extend Forwardable

  delegate [:alive?, :dead?, :health, :health=] => :@health 

  def initialize
    @health = VitalSystem.new
    @location = Location.new
    register
  end

  def location
    @location.copy
  end

  def move(dest = {})
    return @location.move unless dest[:to]
    @location = dest[:to]
    dest[:to].add_content(self)
    self
  end

  def hurt_for(amt)
    @health.hurt_for(amt)
    self
  end
end
