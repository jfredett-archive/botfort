class Bot 
  attr_accessor :name

  def initialize
    @name = assigned_name
    register
  end

  def self.find_by_name(bot_name)
    @@bot_registry[bot_name]
  end

  def self.clear
    @@bot_number = -1
    @@bot_registry = {}
  end

  def self.count
    @@bot_number + 1
  end

  private

  @@bot_number = -1
  def assigned_name
    @@bot_number += 1
    "bot-#{@@bot_number}"
  end

  @@bot_registry = {}
  def register
    @@bot_registry[name] = self
  end
end
