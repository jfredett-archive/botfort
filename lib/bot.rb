class Bot 
  attr_accessor :name

  def initialize
    @name = "bot-#{@@bot_number}"
  def self.clear
    @@bot_number = -1
  def self.count
    @@bot_number + 1
  end

  private

  @@bot_number = -1
    @@bot_number += 1
  end
end
