# Abstracts a class that maintains a internal registry of it's instances
module Registerable 
  def self.included(klass)
    klass.extend self::ClassMethods
    klass.clear
  end

  module ClassMethods
    attr_reader :registry, :number 
    def clear
      @number = 0 
      @registry = {}
    end

    def delete(name)
      @registry.reject! { |k,v| k == name } 
    end

    def find(name)
      @registry[name] 
    end

    def exists?(name)
      @registry.keys.include?(name)
    end

    def register(name, instance)
      name ||= assigned_name
      @registry[name] = instance 
      name
    end

    def update_name(old, new)
      obj = find(old)
      delete(old)
      register(new, obj)
    end

    def count
      @number 
    end

    private 

    def assigned_name
      @number += 1
      "#{basename}-#{@number}"
    end

    def basename
      "entry"
    end
  end

  attr_reader :name

  def name=(new_name)
    @name = self.class.update_name(name, new_name)
  end

  def register
    @name = self.class.register(name, self)
  end
end
