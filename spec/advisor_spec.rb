require 'spec_helper'

#class Parent
  #include Advisable
  #attr_reader :messages

  #def initialize
    #@messages = []
  #end
#end

##class DummyClass < Parent
  ##def hookable
    ##@messages << "dummy class" 
  ##end
##end

##class OtherDummyClass < Parent
  ##def hookable
    ##@messages < "other dummy class"
  ##end
##end

##class NonAdvisable
  ##attr_reader :messages
  ##def initialize 
    ##@messages = []
  ##end

  ##def hookable
    ##@messages << "unadvised"
  ##end
##end

#describe "top-level API" do
  #subject { Kernel }

  #it { should respond_to :advice } 
  #it { should respond_to :advise } 

  #describe "defining some advice" do
    #before :all do 
      #advice(:empty_advice) { }

      #advice :non_empty do
        #advise :before, any? { respond_to?(:hookable) } => :hookable do
          #@messages << "before"
        #end

        #advice :after, DummyClass => :hookable do
          #@messages << "after"
        #end
      #end
    #end

    #after :all do
      #Advice.clear!
    #end

    ##context DummyClass do
      ##subject { DummyClass.new } 
      ##before { subject.hookable }
      ##its(:messages) { should == ["before", "dummy class", "after"] } 
    ##end

    ##context OtherDummyClass do
      ##subject { OtherDummyClass.new } 
      ##before { subject.hookable }
      ##its(:messages) { should == ["other dummy class", "after"] } 
    ##end

    ##context NonAdvisable do
      ##subject { NonAdvisable.new } 
      ##before { subject.hookable }
      ##its(:messages) { should == ["unadvised"] } 
    ##end
  #end
#end

#describe Advisable do
  
#end

describe Advice do
  subject { Advice }  
  it { should respond_to :clear! } 
  it { should respond_to :find } 

  before do
    advice(:empty_advice) do
      "nothing"
    end

    advice(:advice_with_actions) do
      advise :before, any? { respond_to? :foo } do
        puts "bar"
      end
    end
  end

  describe "empty advice"  do
    subject { Advice.find(:empty_advice) } 

    it { should be } 
    it { should respond_to :name }
    it { should respond_to :actions } 
    its(:name) { should == :empty_advice } 
    its(:actions) { should be_nil } 
  end

  describe "advice with actions" do
    subject { Advice.find(:advice_with_actions) }

    it { should be } 
    it { should respond_to :name }
    it { should respond_to :actions } 
    its(:name) { should == :advice_with_actions } 
    its(:actions) { should_not be_nil } 
  end
end


=begin

The API I'd like is:

advice :example do
  advise { respond_to?(:foo) and is_not_a?(Fooble) }

  for :foo do
    before do
      puts "before #foo"
    end

    after do
      puts "after #foo"
    end
  end

  for :baz do
    before do
      puts "before #baz"
    end
  end

  for :a_method do
    #some advice
  end
end

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
      advise { 
        (respond_to?(:save, :save!) or respond_to?(:create, :create!)) and respond_to?(:id)
      }

      for [:save, :save!] do
        before do
          Logger.log("Saving #{id}")
        end
      end

      for [:create, :create!] do
        before do
          Logger.log("Creating #{id}")
        end
      end

      for [:create, :create!, :save, :save!] do
        after do
          Logger.log("Finished with #{id}")
        end
      end
    end

and I wanted to have it also log some additional information to another source
(maybe an analytics thing). I should be able to do:

    advice :analytics => :logging do
      #advise field is additive, so we can assume that we respond to all the
      #things :logging does

      for [:create, :create!, :save, :save!] do
        after do
          HTTPLibary.post("http://analytics.url.com/#{id}")
        end
      end
    end

The #ignore method mentioned earlier would take an advice-group-name (eg,
:logging or :analytics in the above example above), and ignore any advice related to that

=end

