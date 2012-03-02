require 'rspec/expectations'

RSpec::Matchers.define :understand do |expected|
  match do |agent|
    agent.understands?(expected) 
  end
end
