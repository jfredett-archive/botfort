class Location
  def initialize(x = 0, y = 0)
    @coords = [ x, y ]  
  end

  def coordinates
  end

  def ==(other_loc)
    self.coordinates == other_loc.coordinates
  end
end
