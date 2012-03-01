class Location
  attr_reader :content
  include Registerable

  def copy
    Location.new(*coordinates)
  end

  def self.[](*args)
    find(args) || new(*args)
  end

  def within(r)
    raise "Must provide a positive whole value for r" unless r >= 0 and r.is_a? Integer
    coords = []
    (r+1).times do |i|
      (r+1).times do |j|
        coords << Location[@x_coord - i, @y_coord - j]
        coords << Location[@x_coord + i, @y_coord + j]
        coords << Location[@x_coord + i, @y_coord - j]
        coords << Location[@x_coord - i, @y_coord + j]
      end
    end
    coords.uniq! #this whole thing is pretty terrible.
  end

  def coordinates
    [ @x_coord , @y_coord ] 
  end

  def move
    @x_coord += 1
    @y_coord += 1
  end

  def add_content(obj)
    @content << obj
  end

  def to_s
    "(#{@x_coord},#{@y_coord})"
  end
  alias_method :inspect, :to_s

  def terrain
    Terrain.new 
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
