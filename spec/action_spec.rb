require 'spec_helper'
describe Action do
  context "creating an action" do
    let!(:valid_action) { 
      action :valid_action do
        move abs: [0,0]
        mov 1, -2
        wait
      end
    }

    it "should register the action by name" do
      Action.find(:valid_action).should_not be_nil   
    end
  end
end
