class Location
  attr_reader :content

  def copy
    Location.new(*coordinates)
  end

  def self.[](*args)
    new(*args)
  end

  def coordinates
    [ @x_coord , @y_coord ] 
  end

  def ==(other_loc)
    coordinates.
      zip(other_loc.coordinates).
      inject(true) { |a,v| a && (v.first == v.last) }
  end

  def move
    @x_coord += 1
    @y_coord += 1
  end

  private

  def initialize(x = 0, y = 0)
    @x_coord = x
    @y_coord = y
    @content = []
  end

end
