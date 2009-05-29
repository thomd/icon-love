require "rubygems"
require "rake"
require "iconlove"

task :default => "test"

desc "run tests (default)"
task :test do
  require 'rake/runtest'
  Rake.run_tests '**/*_test.rb'  
end