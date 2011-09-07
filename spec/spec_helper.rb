require 'rspec'
(Dir['./lib/*.rb'] + Dir['./lib/**/*.rb']).each do |file|
  require file
end
