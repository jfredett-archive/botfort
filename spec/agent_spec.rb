require 'spec_helper'

describe Agent do
  it { should be_a Module }
end

describe do
  before :all do
    class AnAgent
      include Agent
    end
  end

  after :all do
    #clean up the namespace
    Object.send(:remove_const, :AnAgent)
  end

  subject { AnAgent.new }

  context "basic API" do
    it { should respond_to :perform }
    it { should respond_to :understands? }
    it { should respond_to :claim }                 # an instance can claim a particular action
    its(:class) { should respond_to :claim }        # by default, an entire class can claim an action
    its(:class) { should respond_to :understands? } # similarly, an entire class can understand an action
  end

  context do
    let!(:valid_action) {
      action :valid_action do
        move 0, 1
        puts "I Moved!"
      end
    }

    let!(:valid_action_no_default) { 
      action :valid_action_no_default
    }

    context "Agent" do
      subject { AnAgent }

      describe ".claim" do
        it "should be able to claim an action with a provided implementation" 
        it "should be able to claim an action with no default, if it provides one"
        it "should be able to override a default implementation"
      end

      describe ".understands?" do
        subject { AnAgent }
        it "should understand any action that it claims"
        it "should not understand any action it does not claim"
      end
    end

    context "Agent" do
      describe "#claim" do
        it "should be able to claim an action with a provided implementation" 
        it "should be able to claim an action with no default, if it provides one" 
        
        it "should understand any actions it claims to understand" do
          subject.claim(:valid_action)
          subject.understands?(:valid_action).should be_true
        end

        it "should not understand any actions it does not claim to understand" do
          subject.understands?(:valid_action).should be_false
        end

        it "should not be able to claim an action unless the dependencies of that action are also understood"
      end

      describe "#understands?" do
        it "should be that a new instance understands all of the commands it's class claims"
        it "should understand any action that it claims"
        it "should not understand any action it does not claim"
      end

      describe "#perform" do
        it "should cause the associated action definition to be executed in the instance context" do
          subject.claim(:valid_action)
          subject.should_receive(:execute).with(instance_of(Action))
          subject.perform(:valid_action)
        end

        it "should throw an error if the action is not understood by the agent" do
          #note: subject does not claim to understand valid action
          expect { subject.perform(:valid_action) }.to raise_error ActionNotUnderstood
        end
      end
    end
  end

end
