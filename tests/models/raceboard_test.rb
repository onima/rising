require 'coveralls'
Coveralls.wear!
require 'minitest/autorun'
class TestRaceBoard < Minitest::Test
  def setup
    @state = GameState.new
    @state.reset!
    @raceboard = @state.raceboard
    @human_race = @raceboard.races.first
    @player = Player.new("Bob", "North")
    @player2 = Player.new("Alice", "South")
  end

  def test_if_races_were_initialized
    assert_equal 'humans', @raceboard.races.first.name
  end

  def test_if_pick_race_method_assign_race_to_player
    @raceboard.pick_race(@human_race, @player)
    @name_troops_number_ary = @player.race.map do |item|
      [item.name, item.troops_number]
    end
    assert_equal 'humans', @name_troops_number_ary.flatten[0] 
  end

end
