
task :test do
  $LOAD_PATH.unshift './lib'
  require 'lazy_load'
  require 'minitest/autorun'
  begin; require 'turn'; rescue LoadError; end
  Dir.glob("test/**/*_test.rb").each { |test| require "./#{test}" }
end

task :shell do
  system 'pry -I lib -r lazy_load --trace'
end

task :default => :test



