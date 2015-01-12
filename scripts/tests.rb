#!/usr/bin/env ruby

test_dir = File.expand_path(File.join(__dir__, "..", "tests"))

require_relative File.join(test_dir, "test_helper.rb")

require 'minitest/autorun'
Dir.glob("**/*_test.rb").each {|f| require f }
