require 'spec_helper'

describe Agent do
  it { should be_a Module }
end

describe do
  subject { AnAgent.new }

  before :all do
    class AnAgent
      include Agent
    end

    action :instance_action_with_default do
      "Done"
    end

    action :class_action_with_default do 
      "Class"
    end

    action :instance_action_without_default
    action :class_action_without_default 

    action :unclaimed_action
  end

  before :each do
    AnAgent.claim(:class_action_with_default)
    AnAgent.claim(:class_action_without_default)
  end

  after :each do
    AnAgent.forget_all!
    subject.forget_all!
  end

  after :all do
    #clean up the namespace
    Object.send(:remove_const, :AnAgent)
  end

  context "basic API" do
    context "instance" do 
      it { should respond_to :perform }
      it { should respond_to :understands? }
      it { should respond_to :claim }       # an instance can claim a particular action
      it { should respond_to :forget_all! } # un-claims all instance-claimed actions
      it { should respond_to :forget }      # forgets a single named action
    end

    context "class" do
      subject { AnAgent }
      it { should respond_to :forget_all! }  # un-claims all class-claimed actions
      it { should respond_to :forget }       # forgets a single named action
      it { should respond_to :claim }        # by default, an entire class can claim an action
      it { should respond_to :understands? } # similarly, an entire class can understand an action
    end
  end

  context Agent do
    context do
      subject { AnAgent }

      describe ".claim" do
        it "should be able to claim an action with a provided implementation" 
        it "should be able to claim an action with no default, if it provides one"
        it "should not be able to claim an action with no default, when it doesn't provide one"
        it "should be able to override a default implementation"
      end

      describe ".understands?" do
        it { should understand :class_action_with_default }           # because it claims it
        it { should understand :class_action_without_default }        # because it claims it
        it { should_not understand :instance_action_with_default }    # because it doesn't
        it { should_not understand :instance_action_without_default } # because it doesn't
      end

      describe ".forget" do
        before { subject.forget :class_action_with_default }

        it { should_not understand :class_action_with_default }
        it { should understand :class_action_without_default  }

        its(:new) { should_not understand :class_action_with_default }
        its(:new) { should understand :class_action_without_default  }
      end

      describe ".forget_all!" do
        before { subject.forget_all! }

        it { should_not understand :class_action_with_default    }
        it { should_not understand :class_action_without_default }

        its(:new) { should_not understand :class_action_with_default    }
        its(:new) { should_not understand :class_action_without_default }
      end
    end


    context do
      subject { AnAgent.new } 

      before :each do
        subject.claim(:instance_action_with_default) 
        subject.claim(:instance_action_without_default) 
      end

      describe "#forget" do
        before { subject.forget :instance_action_with_default }

        it { should_not understand :instance_action_with_default }
        it { should understand :instance_action_without_default  }
        it { should understand :class_action_with_default        }
        it { should understand :class_action_without_default     }
      end

      describe "#forget_all!" do
        before { subject.forget_all! }

        it { should_not understand :instance_action_with_default    }
        it { should_not understand :instance_action_without_default }
        it { should understand :class_action_with_default           }
        it { should understand :class_action_without_default        }
      end

      describe "#claim" do
        it "should be able to claim an action with a provided implementation" 
        it "should be able to claim an action with no default, if it provides one" 
        it "should not be able to claim an action with no default, when it doesn't provide one"
        it "should not be able to claim an action unless the dependencies of that action are also understood"
      end

      describe "after claiming a method" do
        it "should respond to each action as if it were an instance method" do
          expect { 
            subject.should_receive(:perform).with(:instance_action_with_default)
            subject.instance_action_with_default 
          }.to_not raise_error NoMethodError
        end

        it "should respond_to a claimed action as if it were a method" do
          subject.should respond_to :instance_action_without_default
        end
      end

      describe "#understands?" do
        it { should understand :instance_action_without_default } # because it claims it directly
        it { should understand :instance_action_with_default    } # because it claims it directly
        it { should understand :class_action_without_default    } # because it's on it's class.
        it { should understand :class_action_with_default       } # because it's on it's class.
        it { should_not understand :unclaimed_action            } # because it and it's class don't claim it
      end

      describe "#perform" do
        it "should cause the associated action definition to be executed in the instance context" do
          Action.find(:instance_action_with_default).should_receive(:call)
          subject.perform(:instance_action_with_default)
        end

        it "should throw an error if the action is not understood by the agent" do
          #note: subject does not claim to understand another valid action
          expect { subject.perform(:instance_action_without_default) }.to raise_error Agent::ActionNotUnderstood
        end

        it "should alter the internal state of the agent if the action implementation would do so" 
        it "should handle actions which take arguments"
      end
    end
  end

end
