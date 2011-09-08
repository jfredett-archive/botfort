class Bot 
  attr_accessor :name
  @@bot_number = 0

  def initialize
    @name = "bot-#{@@bot_number}"
    @@bot_number += 1
  end
end
