class Bot 
  attr_accessor :name

  def initialize
    @name = assigned_name
  end
  def self.clear
    @@bot_number = -1
  def self.count
    @@bot_number + 1
  end

  private

  @@bot_number = -1
  def assigned_name
    @@bot_number += 1
    "bot-#{@@bot_number}"
  end
end
