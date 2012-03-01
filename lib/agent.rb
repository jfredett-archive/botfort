module Agent
  def self.included(cls)
    cls.send(:include, InstanceMethods)
    cls.send(:extend,  ClassMethods)
  end

  module InstanceMethods
    

    def understands?(action_name)
      __understood_actions.has_key?(action_name)
    end

    def perform(action_name)
      raise ActionNotUnderstood(action_name) unless understands? action_name
      execute(Action.find(action_name))
    end

    def claim(action_name)
      __understood_actions[action_name] = Action.find(action_name)
    end

    def execute(action)
    end

    private

    def __understood_actions 
      @__understood_actions ||= {}
    end
  end

  module ClassMethods
    def claim 
    end

    def understands?

    end
  end

end

class ActionNotUnderstood < Exception ; end

def ActionNotUnderstood(msg)
  ActionNotUnderstood.new(msg)
end
