class VitalSystem
  attr_accessor :health

  def initialize 
    @health = 1
  end

  def alive? 
    @health > 0
  end

  def dead? 
    not alive?
  end

  def hurt_for(amt)
    @health -= amt
    self
  end
end
