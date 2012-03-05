require 'spec_helper'

describe Advisable do
  subject { Advisable }
  it { should be_a Module }
end

=begin

The API I'd like is:


class Foo
  include Advisable

  def bar
    puts "Foo#bar"
  end
end

class Furble
  def bar
    puts "Furble#bar"
  end
end

class Flum
  extend Advisable
  def self.bar
    puts "Flum.bar"
  end
end

advice :example_advice_group do
  advise :before, Foo => :bar do
    puts "Advice#before" 
  end

  advise :after, any? { respond_to?(:bar) } => :bar do
    puts "Advice#after"
  end
end

#----#

Foo.new.bar

# => Advice#before
# => Foo#bar
# => Advice#after

Furble.new.bar

# => Furble#bar

Flum.bar

# => Flum.bar
# => Advice#after

#####

That is, only those which include Advisable will respond, but we can advise
everyone who adheres to a particular interface so long as they include
Advisable. 

Further, advisable classes should be able to turn advice off dynamically, so
you might have an "#ignore" method which prevents advice from running

Further still, you may choose to adopt a blacklist/whitelist for advice, so that
instead of accepting advice on any method, you can choose to only accept advice
on a list of "advisable" methods

You should be able to forward-specify dependencies like in rake on other advice.
So that if I wrote a logging-advice like:

    advice :logging do
      advise :after, any? { respond_to?(:save, :save!) } => :save do
        #log update of a thing
      end

      advise :after, any? { reponde_to?(:create, :create!) } => :save do
        #log creation of a new thing
      end
    end

and I wanted to have it also log some additional information to another source
(maybe an analytics thing). I should be able to do:

    advice :analytics do
      advise :after, :depends_on => :logging, any? { respond_to?(:save) } => :save do
        #analytics
      end
    end

The #ignore method mentioned earlier would take an advice-group-name (eg,
:logging or :analytics in the above example above), and ignore any advice related to that

=end

