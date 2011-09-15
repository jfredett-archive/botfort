require './lib/registerable'

class Bot 
  include Registerable
  attr_accessor :name, :health

  def initialize
    @health = 1
    @location = Location.new
    register
  end

  def location
    @location
  end

  def move(dest = {})
    return @location.move unless dest[:to]
    @location = dest[:to]
  end

  def dead?
    @health <= 0
  end

  def hurt(amt)
    @health -= amt 
  end

end
