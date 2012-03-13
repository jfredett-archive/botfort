require 'forwardable'
# Abstracts a class that maintains a internal registry of it's instances
module Registerable
  def self.included(klass)
    klass.extend self::ClassMethods
    klass.clear
  end

  module ClassMethods
    attr_reader :registry, :number
    extend Forwardable

    attr_reader :registry, :number

    def clear
      @number = 0
      @registry = {}
    end

    def register(name, instance)
      (name ||= assigned_name).tap { |n| @registry[n] = instance }
    end

    def update_name(old, new)
      register(new, delete(old))
    end
    delegate [:delete, :has_key?, :[]] => :@registry
    alias find []
    alias clear! clear
    alias exists? has_key?
    alias count number

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
