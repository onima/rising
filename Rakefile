require 'rake/testtask'

task default: 'test'

Rake::TestTask.new do |t|
  current_dir = File.dirname(__FILE__)
  t.libs << current_dir
  t.pattern = File.join(current_dir, "tests", "**", "*_test.rb")
end
