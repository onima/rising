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
    
    def test_if_application_works
      visit '/'
      page.click_on('new_game')
      assert_equal '/players_choice', page.current_path
      
      #User must use comma to create players
      page.fill_in 'players', :with => 'Alice Bob'
      page.click_on('validate_players')
      assert_equal '/choose_race', page.current_path
    end
end
