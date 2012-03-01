module Agent
  def self.included(cls)
    cls.send(:include, InstanceMethods)
    cls.send(:extend,  Claimant)
    cls.class.send(:include, ClassMethods) #it really does need to be this way...
  end

  # a thing that can claim an action is a claimant
  module Claimant 
    def claim(action_name)
      __understood_actions[action_name] = Action.find(action_name)
    end

    def understands?(action_name)
      __understood_actions.has_key?(action_name) || self.class.understands?(action_name)
    end

    private 

    def __understood_actions 
      @__understood_actions ||= Hash.new(proc { |n| raise ActionNotUnderstood.new(n) })
    end
  end

  module InstanceMethods
    include Agent::Claimant

    def perform(action_name)
      __understood_actions[action_name].call
    end

    alias old_method_missing method_missing
    def method_missing(method, *args, &block)
      perform(action_name) if understands?(method)
      old_method_missing(method, *args, &block)
    end
  end

  module ClassMethods
    def understands?(_); end
  end

  class ActionNotUnderstood < Exception ; end
end
