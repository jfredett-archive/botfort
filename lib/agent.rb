module Agent
  def self.included(cls)
    cls.send(:include, InstanceMethods)
    cls.send(:extend,  ClassMethods)
  end

  module InstanceMethods
    def understands?

    end

    def perform

    end

    def claim

    end
  end

  module ClassMethods
    def claim 
    end
  end

end
