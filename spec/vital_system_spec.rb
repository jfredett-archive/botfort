
describe VitalSystem do
  before :each do 
    @vitals = VitalSystem.new
  end

  it "should be able to track it's health" do 
    @vitals.health.should_not be_nil
  end

  it "should be able to lose health" do
    orig_health = @vitals.health
    @vitals.hurt_for(1).health.should be < orig_health
  end

  it "should let me set it's health" do
    @vitals.health = 100
    @vitals.health.should == 100
    @vitals.health = 1000
    @vitals.health.should == 1000
  end

  it "should be able to tell me if it's dead" do
    @vitals.hurt_for(@vitals.health * 2).should be_dead
  end

  it "should be alive by default" do
    @vitals.should be_alive
    @vitals.should_not be_dead
  end

end
