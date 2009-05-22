require "rubygems"
require "rake"
require "koguma"

task :default => "test"

desc "run tests (default)"
task :test do
  require 'rake/runtest'
  Rake.run_tests '**/*_test.rb'  
end