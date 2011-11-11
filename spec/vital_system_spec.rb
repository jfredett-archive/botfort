describe VitalSystem do
  it { should respond_to :health }
  it { should respond_to :hurt_for } 
  it { should respond_to :alive? }
  it { should respond_to :dead? }
  it { should be_alive }
  it { should_not be_dead }

  it "should be able to track it's health" do 
    subject.health.should_not be_nil
  end

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

  it "should be able to tell me if it's dead" do
    subject.hurt_for(subject.health * 2).should be_dead
  end

  it "should be alive by default" do
    subject.should be_alive
    subject.should_not be_dead
  end
end
