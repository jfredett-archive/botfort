require 'rspec'
(Dir['./lib/*.rb'] + Dir['./lib/**/*.rb']).each do |file|
  puts "loading: #{file}" if ENV['VERBOSE']
  require file
end

(Dir['./spec/helpers/*.rb']).each do |file|
  puts "loading: #{file}" if ENV['VERBOSE']
  require file
end

require 'pry'
