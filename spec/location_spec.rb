require 'spec_helper'
describe Location do
  let(:loc1) { Location[1,2] }
  let(:loc2) { Location[3,2] }
  subject { loc1 } 

  context "representation and equality" do
    it { should respond_to :coordinates } 

    it { should == loc1 } 

    it { should_not == loc2 }

    context "is a flyweight, " do
      it "should only create each location once" do
        #we have to do it this way to ensure we compare references
        Location[1,2].equal?(Location[1,2]).should be_true 
      end
    end
  end


  context "contents of a location" do
    it { should respond_to :content } 
    its(:content) { should_not be_nil }

    context "when there is a bot at the given location" do
      let(:bot) { Bot.new }
      subject { bot.move(to: loc1) ; loc1 }
      its(:content) { should include bot }
    end
  end
  describe "#to_s and #inspect" do
    it "should show the coordinates of the location" do
      Location[3,2].to_s.should == "(3,2)"
      Location[3,2].inspect.should == "(3,2)"
    end
  end
end
