require 'spec_helper'

describe Agent do
  it { should be_a Module }
end

describe do
  subject { AnAgent.new }

  before :all do
    class AnAgent
      include Agent

      attr_accessor :foo

      def initialize(foo=nil)
        @foo = foo
      end
    end

    action :instance_action_with_default do
      "Instance"
    end

    action :class_action_with_default do 
      "Class"
    end

    action :instance_action_without_default
    action :class_action_without_default 

    action :no_default_to_be_claimed

    action :with_default_to_be_claimed do
      "TBC"
    end

    action :unclaimed_action
  end

  before :each do
    AnAgent.claim(:class_action_with_default)
    AnAgent.claim(:class_action_without_default) do
      "Default implementation of :class_action_without_default"
    end
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
        it "should be able to claim an action with a provided implementation" do
          expect { 
            subject.claim(:with_default_to_be_claimed) 
          }.to_not raise_error Agent::NoImplementationGiven
        end

        it "should be able to claim an action with no default, if it provides one" do
          expect { 
            subject.claim(:no_default_to_be_claimed) do
              "Given Impl"
            end
          }.to_not raise_error Agent::NoImplementationGiven
        end

        it "should not be able to claim an action with no default, when it doesn't provide one" do
          expect { 
            subject.claim(:no_default_to_be_claimed) 
          }.to raise_error Agent::NoImplementationGiven
        end

        it "should be able to override a default implementation" do
          expect { 
            subject.claim(:with_default_to_be_claimed) do
              "Overridden Impl"
            end
          }.to_not raise_error Agent::NoImplementationGiven
          subject.new.perform(:with_default_to_be_claimed).should == "Overridden Impl"
        end
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
        subject.claim(:instance_action_without_default) do
          "A implementation of :instance_action_with_default" 
        end
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
        it "should be able to claim an action with a provided implementation" do
          expect { 
            subject.claim(:with_default_to_be_claimed) 
          }.to_not raise_error Agent::NoImplementationGiven
        end

        it "should be able to claim an action with no default, if it provides one" do
          expect { 
            subject.claim(:no_default_to_be_claimed) do
              "Given Impl"
            end
          }.to_not raise_error Agent::NoImplementationGiven
        end

        it "should not be able to claim an action with no default, when it doesn't provide one" do
          expect { 
            subject.claim(:no_default_to_be_claimed) 
          }.to raise_error Agent::NoImplementationGiven
        end

        it "should be able to override a default implementation" do
          expect { 
            subject.claim(:with_default_to_be_claimed) do
              "Overridden Impl"
            end
          }.to_not raise_error Agent::NoImplementationGiven
          subject.perform(:with_default_to_be_claimed).should == "Overridden Impl"
        end
      end

      describe "claiming actions from within an action" do
        before do
          action :meta_action do
            claim :another_action
            claim :an_action_with_an_impl do
              "Impl"
            end
          end

          action :another_action do
            "Impl of Another Action"
          end

          action :an_action_with_an_impl 

          subject.claim(:meta_action)
        end

        context "before claiming the meta action" do

          it { should_not understand :another_action }
          it { should_not understand :an_action_with_an_impl }
        end

        context "after claiming the meta action" do
          before { subject.perform(:meta_action) }

          it { should understand :another_action }
          it { should understand :an_action_with_an_impl }
        end
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
        it "should throw an error if the action is not understood by the agent" do
          #note: subject does not claim to understand another valid action
          subject.should_not understand :unclaimed_action 
          expect { subject.perform(:unclaimed_action) }.to raise_error Agent::ActionNotUnderstood
        end

        context "effects" do
          subject { AnAgent.new("Unaltered") }
          before do
            action :alters_foo do
              @foo = "Altered"
            end
            action :alters_with_arg do |f|
              @foo = f
            end
            subject.claim(:alters_foo)
            subject.claim(:alters_with_arg)

            subject.foo.should_not == "Altered" #sanity check
          end

          it "should be capable of altering internal state" do
            subject.alters_foo
            subject.foo.should == "Altered"
          end

          it "should handle actions which take arguments" do
            subject.alters_with_arg("Altered via Argument")
            subject.foo.should == "Altered via Argument"
          end
        end

      end
    end
  end
end
