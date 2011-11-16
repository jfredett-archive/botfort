describe Location do
  let(:loc1) { Location.new(1,2) }
  let(:loc2) { Location.new(3,2) }
  subject { loc1 } 

  context "representation and equality" do
    it { should respond_to :coordinates } 

    it { should == loc1 } 
    it { should_not == loc2 }
  end
  
  context "#[]" do
    subject { Location[1,2] }
    it { should == loc1 }
  end

  context "contents of a location" do
    it { should respond_to :content } 
  end
end
