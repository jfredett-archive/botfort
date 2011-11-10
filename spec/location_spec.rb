describe Location do
  subject { Location.new(1,2) } 

  context "representation and equality" do
    it { should respond_to :coordinates } 
    it { expect { subject.should_not raise_exception } }
    it { should == Location.new(1,2) } 
    it { should_not == Location.new(2,3) }
  end
  
  context "#[]" do
    subject { Location[1,2] }
    it { expect { subject.should_not raise_exception }} 
    it { should == Location.new(1,2) }
  end
end
