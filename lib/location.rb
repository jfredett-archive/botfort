class Location
  attr_reader :content
  include Registerable

  def copy
    Location.new(*coordinates)
  end

  def self.[](*args)
    return find args if exists? args
    new(*args)
  end

  def coordinates
    [ @x_coord , @y_coord ] 
  end

  def move
    @x_coord += 1
    @y_coord += 1
  end

  private

  #used in registration
  def name
    coordinates
  end

  def initialize(x = 0, y = 0)
    @x_coord = x
    @y_coord = y
    @content = []
    register
  end

end
