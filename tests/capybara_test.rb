ENV['RACK_ENV'] = 'test'
require 'rising' 
require 'capybara'
require 'capybara/dsl'
require 'minitest/autorun'

class CapybaraTest < Minitest::Test 
    include Capybara::DSL

    def setup
      Capybara.app = Sinatra::Application.new
    end
    
    def test_if_it_works
      visit '/'
      assert page.has_content?('New Game')
    end
end
