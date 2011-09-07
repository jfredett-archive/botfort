require 'spec_helper'

describe Bot do
  it "should be able to identify itself" do
    bot = Bot.new
    bot.name.should_not be_empty
  end
end
