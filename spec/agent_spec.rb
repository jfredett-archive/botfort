require 'spec_helper'

describe Agent do
  it { should be_a Module }
end

describe "An Agent" do
  subject do
    class AnAgent
      include Agent
    end

    AnAgent.new
  end
  after :all do
    #clean up the namespace
    Object.send(:remove_const, :AnAgent)
  end

  it { should respond_to :perform }
  it { should respond_to :understands? }

end
