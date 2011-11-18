require 'spec_helper'

describe Bot do
  before :each do
    @bot1 = Bot.new 
    @bot2 = Bot.new 
  end

  after (:each) { Bot.clear } 


  context "identification" do 
    subject { Bot.new } 
    it { should respond_to :name } 
    it { subject.name.should_not be_empty } 

    it { subject.should_not == @bot1 } 
    it { should == subject } 

    it "should allow me to change it's name" do
      @bot1.name = "test"
    end
    
    it "should be able to identify itself independent of it's name" do
      @bot1.name = "test"
      @bot2.name = "test"
      @bot2.should_not == @bot1
    end
  end

  context "class actions" do
    it "should be able to return a count of all the bots in existence" do
      Bot.clear
      Bot.new
      Bot.count.should == 1
      Bot.new
      Bot.count.should == 2
    end

    it "should be able to reset it's knowledge of all bots" do
      Bot.new
      Bot.new
      Bot.new
      Bot.count.should_not == 0
      Bot.clear
      Bot.count.should == 0
    end

    it "should add itself to a registry of bots, indexed by name" do
      Bot.find("bot-1").should == @bot1
      Bot.find("bot-2").should == @bot2
    end

    it "should update itself in the registry when I change it's name" do
      bot = Bot.find("bot-1")
      bot.name = "foo"
      expect { Bot.find("foo") }.should_not raise_error
      Bot.find("foo").should_not be_nil
      bot.should == Bot.find("foo")
    end
  end

  context "health" do
    subject { Bot.new } 
    it { should respond_to :health }
    it { subject.health.should_not be_nil } 

    it { should respond_to :hurt_for }
    it "should be able to lose health" do
      orig_health = subject.health
      subject.hurt_for(1).health.should be < orig_health
    end

    it "should let me set it's health" do
      subject.health = 100
      subject.health.should == 100
      subject.health = 1000
      subject.health.should == 1000
    end

    it { should respond_to :dead? }
    it "should die if it is hurt for more than it's remaining health" do
      subject.hurt_for(subject.health * 2).should be_dead
    end

    it { should be_alive } #FRANKENSTEIN!
    it { should_not be_dead } #this is equivalent to the above, but worded differently.
  end

  context "movement and location" do
    subject { Bot.new }
    it { should respond_to :location }
    its(:location) { should_not be_nil } 
    
    it { should respond_to :move } 
    it "should be able to move to a new, random location" do
      old_location = subject.location
      subject.move
      old_location.should_not == subject.location
    end

    it "should be able to move from it's current location to another" do
      subject.move(to: Location[8, 9])
      subject.location.should == Location[8, 9]
    end

    it "should return itself after it moves" do
      subject.move(to: Location[8,9]).should == subject
    end
  end
end
