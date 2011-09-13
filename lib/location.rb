class Location
  def initialize(x = 0, y = 0)
    @coords = [ x, y ]  
  end

  def coordinates
    @coords
  end

  def ==(other_loc)
    self.coordinates.zip(other_loc.coordinates).inject(true) { |a,v| a && (v.first == v.last) }
  end
end
