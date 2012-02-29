require 'spec_helper'
describe Action do
  context ".find" do
    subject { Action } 
    let!(:valid_action) { 
      action :valid_action do
        move abs: [0,0]
        move 1, -2
        wait
      end
    }

    let!(:valid_action_without_impl) {
      action :valid_action_without_impl
    } 

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

      it { should respond_to :interpretation }
      it { should respond_to :name }
      it { should respond_to :has_default? }

      its(:interpretation) { should respond_to :call }
      its(:has_default?) { should be_true }
    end

    context "after finding an action without a default interpretation" do
      subject { Action.find(:valid_action_without_impl) } 

      it { should respond_to :interpretation }
      it { should respond_to :name }
      it { should respond_to :has_default? }

      its(:interpretation) { should be_nil }
      its(:has_default?) { should be_false }
    end
  end
end
