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

  def test_if_game_end_method_returns_true
    @game_master = GameMaster.new(GameState.new)
    @game_master.create_players(["bob", "alice"])
    @game_master.game_state.turn_tracker_generate
    @game_master.game_state.turn_tracker.turns_left = 1

    actual_player_name = "alice"
    assert @game_master.game_state.game_end?(actual_player_name)
  end

  def test_update_method
    @game_master = GameMaster.new(GameState.new)
    @game_master.create_players(["bob", "alice"])

    @game_state = @game_master.game_state
    @game_state.initialize_map_turn_tracker_rising_id

    @region_9                           = @game_state.map.regions[8]
    @region_9.has_tribe                 = false
    @region_9.land_type.conquest_points = 6

    @player_1      = @game_state.players[0]
    @player_1.race = [Race.new("humans", 5)].to_set
    @player_1.occupied_regions << @region_9

    @player_2      = @game_state.players[1]
    @player_2.race = [Race.new("orcs", 2)].to_set

    @game_state.turn_tracker.turn_played << @player_1
    turn_before_update = @game_state.turn_tracker.actual_turn
    @game_state.update(@player_2, turn_before_update)

    assert_equal 5, @player_2.race.to_a[0].troops_number
    assert_equal 'decreasing', @region_9.land_type.status_point
    assert_equal 5, @region_9.land_type.conquest_points
    assert @game_state.turn_tracker.turn_played.empty?
  end
end
