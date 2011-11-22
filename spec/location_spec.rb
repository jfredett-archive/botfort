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

  context "querying locations" do
    describe "#within" do
      it "should get all the locations within some given distance of the location" do
        area = Location[0,0].within(1)
        area.should include Location[1,1]
        area.should include Location[-1,-1]
        area.should_not include Location[-1,-3]
      end

      it "should contain the location it is called on" do
        area = Location[0,0].within(1).should include Location[0,0]
      end

      it "should raise an error when you pass it a negative range" do
        expect { Location[1,4].within(-5) }.should raise_error
      end

      it "should raise an error unless you provide it an integer" do
        expect { Location[1,4].within(4.03) }.should raise_error
      end

      it "should return no duplicate locations" do
        area = Location[0,0].within(1)
        area.uniq.should == area
        area.count.should == 9
      end
    end
  end

  describe "#to_s and #inspect" do
    it "should show the coordinates of the location" do
      Location[3,2].to_s.should == "(3,2)"
      Location[3,2].inspect.should == "(3,2)"
    end
  end
end
