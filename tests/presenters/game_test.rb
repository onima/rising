require 'coveralls'
Coveralls.wear!
require 'minitest/autorun'
require 'presenters/game'
module Presenters
  class GameTest < Minitest::Test

    def setup
      @game_presenter = Game.new(GameMaster.new(GameState.new))
      @game_presenter.game_master.game_state.initialize_map_turn_tracker_rising_id
      @raceboard = @game_presenter.game_master.game_state.raceboard
      @players = @game_presenter.game_master.game_state.players 
      @turn_tracker = @game_presenter.game_master.game_state.turn_tracker
    end

    def test_if_method_players_show_each_game_master_game_state_players
      @game_presenter.game_master.create_players( ["bob", "alice"] )
      assert_equal "bob", @game_presenter.players[0].name
    end

    def test_if_method_player_show_the_current_player
      @game_presenter.game_master.create_players( ["bob", "alice"] )
      assert_equal "bob", @game_presenter.player.name
      @turn_tracker.update(@turn_tracker.players[0])
      assert_equal "alice", @game_presenter.player.name
    end

    def test_if_method_races_show_raceboard_races
      assert_equal 2, @game_presenter.races.length
    end

    def test_if_method_players_without_races_works
      @game_presenter.game_master.create_players( ["bob", "alice"] )
      assert @game_presenter.players_without_race
      @players[0].race = [Race.new("humans", 15)].to_set
      @players[1].race = [Race.new("orcs", 15)].to_set
      refute @game_presenter.players_without_race
    end

    def test_if_method_map_show_map
      @game_presenter.game_master.game_state.initialize_map_turn_tracker_rising_id
      assert_equal "1,1", @game_presenter.map.regions[0].id
    end

    def test_if_method_turn_tracker_show_turn_tracker
      @game_presenter.game_master.game_state.initialize_map_turn_tracker_rising_id
      assert_equal 1, @game_presenter.turn_tracker.actual_turn
    end

  end
end
