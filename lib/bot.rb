class Bot 
  attr_accessor :name

  def initialize
    @name = assigned_name
    @health = 1
    register
  end

  def health
    @health
  end

  def hurt(amt)
    @health -= amt 
  end


  def self.find_by_name(bot_name)
    @@bot_registry[bot_name] 
  end

  def self.clear
    @@bot_number = 0 
    @@bot_registry = {}
  end

  def self.count
    @@bot_number 
  end

  private 

  @@bot_number = 0 
  def assigned_name
    @@bot_number += 1
    "bot-#{@@bot_number}"
  end

  @@bot_registry = {}
  def register
    @@bot_registry[name] = self
  end
end
