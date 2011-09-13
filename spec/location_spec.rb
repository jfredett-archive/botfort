describe Location do
  it "should have a coordinate representation" do
    Location.new.should respond_to :coordinates
  end

end
