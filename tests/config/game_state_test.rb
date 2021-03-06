require 'coveralls'
Coveralls.wear!
require 'minitest/autorun'

class TestGameState < Minitest::Test
  def test_if_initialize_map_turn_tracker_rising_id_method_works
    @game_state = GameState.new
    @game_state.initialize_map_turn_tracker_rising_id
    assert @game_state.map
  end

  def test_if_players_have_races
    @game_master = GameMaster.new(GameState.new) 
    @game_master.create_players(["bob", "alice"])
    assert @game_master.game_state.players_without_race?
    @game_master.game_state.players[0].race = [Race.new("humans", 5)].to_set
    @game_master.game_state.players[1].race = [Race.new("orcs", 5)].to_set
    refute @game_master.game_state.players_without_race?
  end

end
