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
      @registry[name] = instance 
    end

    def count
      @number 
    end

    def assigned_name
      @number += 1
      "#{basename}-#{@number}"
    end

    private 

    def basename
      "bot"
    end
  end

  attr_reader :name

  def name=(new_name)
    self.class.delete(name)
    @name = new_name
    register
  end

  def register
    @name ||= assigned_name
    self.class.register(name, self)
    @name
  end

  private 

  def assigned_name
    self.class.assigned_name
  end
end
