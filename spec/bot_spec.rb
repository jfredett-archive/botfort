require 'spec_helper'

describe Bot do

  it "should be able to identify itself" do
    bot = Bot.new
    bot.name.should_not be_empty
  end

  it "should be able to uniquely identify itself amongst several bots" do
    bot1 = Bot.new
    bot2 = Bot.new
    bot1.name.should_not == bot2.name
  end
end
