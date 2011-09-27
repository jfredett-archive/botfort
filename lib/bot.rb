require './lib/registerable'

class Bot 
  include Registerable

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
  end

  def dead?
    @health.dead?
  end

  def health
    @health.health
  end

  def health=(amt)
    @health.health = amt
  end

  def alive?
    @health.alive?
  end

  def hurt_for(amt)
    @health.hurt_for(amt)
    self
  end

end
