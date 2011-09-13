describe Location do
  context "representation and equality" do
    it "should have a coordinate representation" do
      Location.new.should respond_to :coordinates
    end

    it "should allow me to specify it's location using coordinates" do
      #should_not raise_exception seems to be broken?
      Location.new(1,2) # will fail if this raises an exception
    end

    it "should be equal to other locations with the same coordinate representation" do 
      Location.new(1,2).should == Location.new(1,2)
    end

    it "should not be equal to other locations with different coordinate representation" do
      Location.new(2,3).should_not == Location.new(1,2)
    end
  end
end
