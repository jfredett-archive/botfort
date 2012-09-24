require 'spec_helper'
describe Action do
  context ".find" do
    subject { Action }

    before  do 
      action :valid_action do
        move abs: [0,0]
        move 1, -2
        wait
      end

      action :valid_action_without_impl
    end

    it { should respond_to :find }

    context "when creating and looking up an action" do
      it "should register the action by name" do
        Action.find(:valid_action).should_not be_nil
      end

      it "should return nil if you search for an action which is undefined" do
        Action.find(:undefined_action).should be_nil
      end
    end

    context "after finding an action with a default interpretation" do
      subject { Action.find(:valid_action) }

      it { should respond_to :call }
      it { should respond_to :to_proc }
      it { should respond_to :interpretation }
      it { should respond_to :name }
      it { should respond_to :has_default? }

      its(:interpretation) { should respond_to :call }
      its(:has_default?)   { should be_true }
    end

    context "after finding an action without a default interpretation" do
      subject { Action.find(:valid_action_without_impl) }

      it { should respond_to :interpretation }
      it { should respond_to :call }
      it { should respond_to :to_proc }
      it { should respond_to :name }
      it { should respond_to :has_default? }

      its(:has_default?) { should be_false }

      it "should raise an error if you try to execute it's action" do
        expect { subject.interpretation.call }.to raise_error Agent::ActionNotUnderstood
      end

      it "should raise an error if you try to convert it to a proc" do
        expect { subject.to_proc }.to raise_error Agent::ActionNotUnderstood
      end
    end
  end
end
