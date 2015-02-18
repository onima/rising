require 'minitest/autorun'
require 'models/turn_tracker.rb'
require 'models/player.rb'
require 'models/game_master.rb'
require 'config/game_state.rb'

class TestTurntracker < MiniTest::Unit::TestCase
  def setup
    @state = GameState.new
    @state.reset!
    @player_1 = Player.new("alexis", "North")
    @player_2 = Player.new("manue", "East")
    @player_3 = Player.new("tom", "South")
    @state.players = [@player_1, @player_2 , @player_3]
    @turn_tracker = TurnTracker.new(10, @state.players)
  end

  def test_if_array_turn_played_hold_a_player
    @turn_tracker.update(@turn_tracker.players.first)
    assert_equal @player_1, @turn_tracker.turn_played[0]
  end

  def test_if_turns_left_decrease_and_actual_turn_increase
    @turn_tracker.players.each do |player|
      @turn_tracker.update(player)
    end
    assert_equal 9, @turn_tracker.turns_left
    assert_equal 2, @turn_tracker.actual_turn
    assert_equal [], @turn_tracker.turn_played
  end
end
