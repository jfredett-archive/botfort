module Agent
  def self.included(cls)
    cls.send(:include, InstanceMethods)
    cls.send(:extend,  ClassMethods)
  end

  module InstanceMethods

    def understands?(action_name)
      __understood_actions.has_key?(action_name) || self.class.understands?(action_name)
    end

    def perform(action_name)
      execute(__understood_actions[action_name])
    end

    def claim(action_name)
      __understood_actions[action_name] = Action.find(action_name)
    end

    private

    def execute(action)
      action.call
    end

    def __understood_actions 
      @__understood_actions ||= Hash.new(proc { |n| raise ActionNotUnderstood(n) })
    end
  end

  module ClassMethods
    def claim(action_name)
      __understood_actions[action_name] = Action.find(action_name)
    end

    def understands?(action_name)
      __understood_actions.has_key?(action_name)
    end

    private 

    def __understood_actions 
      @__understood_actions ||= Hash.new(proc { |n| raise ActionNotUnderstood(n) })
    end
  end

end

class ActionNotUnderstood < Exception ; end

def ActionNotUnderstood(msg)
  ActionNotUnderstood.new(msg)
end
