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
        move 0,1
        "Done"
      end
    }

    let!(:another_valid_action) {
      action :another_valid_action
    }

    before { subject.claim(:valid_action) }

    context "Agent" do
      subject { AnAgent }

      describe ".claim" do
        it "should be able to claim an action with a provided implementation" 
        it "should be able to claim an action with no default, if it provides one"
        it "should not be able to claim an action with no default, when it doesn't provide one"
        it "should be able to override a default implementation"
      end

      describe ".understands?" do
        it { should understand :valid_action }             # because it claims it
        it { should_not understand :another_valid_action } # because it doesn't
      end
    end

    context "Agent" do
      describe "#claim" do
        it "should be able to claim an action with a provided implementation" 
        it "should be able to claim an action with no default, if it provides one" 
        it "should not be able to claim an action with no default, when it doesn't provide one"
        it "should not be able to claim an action unless the dependencies of that action are also understood"
      end

      describe "after claiming a method" do
        it "should respond to each action as if it were an instance method" do
          expect { subject.valid_action }.to_not raise_error NoMethodError
        end
      end

      describe "#understands?" do
        before { subject.class.claim(:another_valid_action) }

        it { should understand :another_valid_action } # because it's on it's class.
        it { should understand :valid_action }         # because it claims it directly
        it { should_not understand :unclaimed_action } # because it and it's class don't claim it
      end

      describe "#perform" do
        it "should cause the associated action definition to be executed in the instance context" do
          valid_action.should_receive(:call)
          subject.perform(:valid_action)
        end

        it "should throw an error if the action is not understood by the agent" do
          #note: subject does not claim to understand another valid action
          expect { subject.perform(:another_valid_action) }.to raise_error Agent::ActionNotUnderstood
        end

        it "should alter the internal state of the agent if the action implementation would do so" 
        it "should handle actions which take arguments"
      end
    end
  end

end
