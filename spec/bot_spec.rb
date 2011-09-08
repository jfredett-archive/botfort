require 'spec_helper'

describe Bot do

  it "should be able to identify itself" do
    bot = Bot.new
    bot.name.should_not be_empty
  end

  it "should be able to return a count of all the bots in existence" do
    Bot.new
    Bot.count.should == 1
    Bot.new
    Bot.count.should == 2
  end
  it "should be able to reset it's knowledge of all bots" do
    Bot.new
    Bot.new
    Bot.new
    Bot.clear
    Bot.count.should == 0
  end
  it "should be able to uniquely identify itself amongst several bots" do
    bot0 = Bot.new
    bot1 = Bot.new
    bot0.name.should_not == bot1.name
  end

  it "should be able to compare itself to another bot, and tell me if they're the same" do
    bot0 = Bot.new
    bot1 = Bot.new
    bot0.should == bot0
    bot1.should_not == bot0
  end
end
